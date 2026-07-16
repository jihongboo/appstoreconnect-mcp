import Foundation
import AppStoreConnect_Swift_SDK

public struct Credentials {
    public let issuerID: String
    public let privateKeyID: String
    public let privateKeySource: PrivateKeySource

    public enum PrivateKeySource {
        case file(URL)
        case string(String)
    }

    public enum Error: LocalizedError {
        case missingIssuerID
        case missingPrivateKeyID
        case missingPrivateKeyOrPath
        case invalidPrivateKeyPath(String)

        public var errorDescription: String? {
            switch self {
            case .missingIssuerID:
                return "Missing APP_STORE_CONNECT_ISSUER_ID environment variable."
            case .missingPrivateKeyID:
                return "Missing APP_STORE_CONNECT_PRIVATE_KEY_ID environment variable."
            case .missingPrivateKeyOrPath:
                return "Missing both APP_STORE_CONNECT_PRIVATE_KEY and APP_STORE_CONNECT_PRIVATE_KEY_PATH environment variables. Provide at least one."
            case .invalidPrivateKeyPath(let path):
                return "Private key path is invalid or file does not exist at: \(path)"
            }
        }
    }

    /// Load credentials from environment variables
    public static func loadFromEnvironment() throws -> Credentials {
        let env = ProcessInfo.processInfo.environment

        guard let issuerID = env["APP_STORE_CONNECT_ISSUER_ID"], !issuerID.isEmpty else {
            throw Error.missingIssuerID
        }

        guard let privateKeyID = env["APP_STORE_CONNECT_PRIVATE_KEY_ID"], !privateKeyID.isEmpty else {
            throw Error.missingPrivateKeyID
        }

        if let keyPath = env["APP_STORE_CONNECT_PRIVATE_KEY_PATH"], !keyPath.isEmpty {
            let fileURL = URL(fileURLWithPath: keyPath)
            guard FileManager.default.fileExists(atPath: fileURL.path) else {
                throw Error.invalidPrivateKeyPath(keyPath)
            }
            return Credentials(issuerID: issuerID, privateKeyID: privateKeyID, privateKeySource: .file(fileURL))
        }

        guard let privateKey = env["APP_STORE_CONNECT_PRIVATE_KEY"], !privateKey.isEmpty else {
            throw Error.missingPrivateKeyOrPath
        }

        return Credentials(issuerID: issuerID, privateKeyID: privateKeyID, privateKeySource: .string(privateKey))
    }

    /// Create APIConfiguration from credentials, automatically formatting raw keys if necessary
    public func makeConfiguration() throws -> APIConfiguration {
        switch privateKeySource {
        case .file(let url):
            return try APIConfiguration(
                issuerID: issuerID,
                privateKeyID: privateKeyID,
                privateKeyURL: url
            )
        case .string(let rawKey):
            // If it contains the BEGIN header, it's a full PEM key.
            // AppStoreConnect-Swift-SDK APIConfiguration(privateKey:) expects a single-line key without PEM headers/footers and line breaks.
            // If it is PEM format, we can write it to a temporary file and load it via URL, which is much safer and easier than regex parsing.
            if rawKey.contains("-----BEGIN PRIVATE KEY-----") {
                let tempDir = FileManager.default.temporaryDirectory
                let tempFileURL = tempDir.appendingPathComponent("AuthKey_\(privateKeyID).p8")
                
                // Write PEM key to temp file
                try rawKey.write(to: tempFileURL, atomically: true, encoding: .utf8)
                
                return try APIConfiguration(
                    issuerID: issuerID,
                    privateKeyID: privateKeyID,
                    privateKeyURL: tempFileURL
                )
            } else {
                // Otherwise, assume it's already a sanitized single-line private key.
                let sanitizedKey = rawKey.replacingOccurrences(of: "\n", with: "")
                                        .replacingOccurrences(of: "\r", with: "")
                                        .trimmingCharacters(in: .whitespacesAndNewlines)
                return try APIConfiguration(
                    issuerID: issuerID,
                    privateKeyID: privateKeyID,
                    privateKey: sanitizedKey
                )
            }
        }
    }
}
