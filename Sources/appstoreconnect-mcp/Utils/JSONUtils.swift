import Foundation
import MCP

public struct JSONUtils {
    /// Convert any Encodable object to a JSON string with pretty printing
    public static func prettyPrint<T: Encodable>(_ object: T) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        do {
            let data = try encoder.encode(object)
            return String(data: data, encoding: .utf8) ?? String(describing: object)
        } catch {
            return String(describing: object)
        }
    }

    /// Safely decode arguments dictionary to a specific Decodable type
    public static func decode<T: Decodable>(_ arguments: [String: Value]?, to type: T.Type) throws -> T {
        guard let arguments = arguments else {
            // Decode from empty json if nil
            let emptyData = "{}".data(using: .utf8)!
            return try JSONDecoder().decode(T.self, from: emptyData)
        }
        let data = try JSONEncoder().encode(arguments)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
