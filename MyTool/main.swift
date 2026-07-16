import Foundation
import MCP
import AppStoreConnect_Swift_SDK

// Define a safe thread-safe helper to write to standard error (stderr)
// This avoids main actor-isolated var inout sharing issues in Swift 6 concurrency
func logToStderr(_ message: String, terminator: String = "\n") {
    let handle = FileHandle.standardError
    if let data = (message + terminator).data(using: .utf8) {
        handle.write(data)
    }
}

// -------------------------------------------------------------
// Built-in Diagnostic Test Mode (with Interactive Support)
// -------------------------------------------------------------
if CommandLine.arguments.contains("--test") {
    logToStderr("=========================================================")
    logToStderr("           App Store Connect MCP Diagnostic             ")
    logToStderr("=========================================================")
    
    // Check if variables are missing
    let env = ProcessInfo.processInfo.environment
    let missingIssuer = env["APP_STORE_CONNECT_ISSUER_ID"]?.isEmpty ?? true
    let missingKeyID = env["APP_STORE_CONNECT_PRIVATE_KEY_ID"]?.isEmpty ?? true
    let missingKey = (env["APP_STORE_CONNECT_PRIVATE_KEY"]?.isEmpty ?? true) && (env["APP_STORE_CONNECT_PRIVATE_KEY_PATH"]?.isEmpty ?? true)
    
    if missingIssuer || missingKeyID || missingKey {
        logToStderr("Tip: No pre-configured environment variables detected. We'll guide you through interactive input for testing.")
        logToStderr("(Note: These inputs are only valid for this test run and will NOT modify your system environment variables)")
        logToStderr("---------------------------------------------------------")
        
        var inputIssuer = ""
        while inputIssuer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            logToStderr("1. Enter APP_STORE_CONNECT_ISSUER_ID (UUID format):")
            logToStderr("> ", terminator: "")
            inputIssuer = readLine() ?? ""
        }
        setenv("APP_STORE_CONNECT_ISSUER_ID", inputIssuer.trimmingCharacters(in: .whitespacesAndNewlines), 1)
        
        var inputKeyID = ""
        while inputKeyID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            logToStderr("\n2. Enter APP_STORE_CONNECT_PRIVATE_KEY_ID (10-character Key ID):")
            logToStderr("> ", terminator: "")
            inputKeyID = readLine() ?? ""
        }
        setenv("APP_STORE_CONNECT_PRIVATE_KEY_ID", inputKeyID.trimmingCharacters(in: .whitespacesAndNewlines), 1)
        
        logToStderr("\n3. Enter the private key:")
        logToStderr("   - If using a key file, enter the absolute path to the .p8 file (e.g. /Users/xx/AuthKey_xx.p8)")
        logToStderr("   - If pasting the key content, paste it and type END on a new line to finish:")
        logToStderr("> ", terminator: "")
        
        if let firstLine = readLine() {
            let trimmedFirst = firstLine.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedFirst.hasPrefix("/") || trimmedFirst.contains(".p8") {
                // File path entered
                setenv("APP_STORE_CONNECT_PRIVATE_KEY_PATH", trimmedFirst, 1)
            } else {
                // Key content pasted
                var lines = [firstLine]
                if trimmedFirst != "END" {
                    while let line = readLine() {
                        let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                        if trimmedLine == "END" {
                            break
                        }
                        lines.append(line)
                    }
                }
                let fullKey = lines.joined(separator: "\n")
                setenv("APP_STORE_CONNECT_PRIVATE_KEY", fullKey, 1)
            }
        }
        logToStderr("---------------------------------------------------------")
    }
    
    logToStderr("Starting diagnostic tests...\n")
    
    do {
            // 1. Test Credentials loading
            logToStderr("[1/4] Testing Credentials loading...")
            let credentials = try Credentials.loadFromEnvironment()
            logToStderr("      ✓ Credentials loaded successfully.")
            logToStderr("        Issuer ID: \(credentials.issuerID)")
            logToStderr("        Key ID:    \(credentials.privateKeyID)")
            
            // 2. Test ASCClient initialization
            logToStderr("[2/4] Testing ASCClient initialization...")
            let client = try ASCClient(credentials: credentials)
            logToStderr("      ✓ ASCClient initialized successfully.")
            
            // 3. Test listApps API call
            logToStderr("[3/4] Testing real App Store Connect API connection...")
            let apps = try await client.listApps(limit: 1)
            logToStderr("      ✓ API connection successful! Retrieved \(apps.count) app(s).")
            if let firstApp = apps.first {
                logToStderr("        First App Name: \(firstApp.attributes?.name ?? "No Name")")
                logToStderr("        First App ID:   \(firstApp.id)")
            }
            
            // 4. Test MCP tool call routing
            logToStderr("[4/4] Testing MCP tool call routing locally...")
            let result = await ToolHandlers.handleCallTool(
                name: "list_apps",
                arguments: ["limit": 1]
            )
            if result.isError == true {
                logToStderr("      ✗ Local tool routing failed.")
                logToStderr("        Result: \(JSONUtils.prettyPrint(result))")
                exit(1)
            } else {
                logToStderr("      ✓ Local tool routing successful.")
                logToStderr("        Result Content Count: \(result.content.count)")
            }
            
            logToStderr("=========================================================")
            logToStderr("✓ SUCCESS: All diagnostic tests passed successfully!")
            logToStderr("Your App Store Connect MCP Server is ready to use.")
            logToStderr("=========================================================")
            exit(0)
        } catch {
            logToStderr("=========================================================")
            logToStderr("✗ ERROR: Diagnostic test failed!")
            logToStderr("  Reason: \(error.localizedDescription)")
            logToStderr("=========================================================")
            exit(1)
        }
}

// -------------------------------------------------------------
// Normal Server Mode
// -------------------------------------------------------------
logToStderr("Initializing App Store Connect MCP Server...")

// 1. Initialize the MCP Server with tool capabilities
// Use compiler type-inference to construct Capabilities
let server = Server(
    name: "AppStoreConnect-MCP-Server",
    version: "1.0.0",
    capabilities: .init(
        tools: .init(listChanged: false)
    )
)

// 2. Register handler for ListTools
await server.withMethodHandler(ListTools.self) { _ in
    await logToStderr("Received listTools request")
    return await ListTools.Result(tools: ToolDefinitions.allTools)
}

// 3. Register handler for CallTool
await server.withMethodHandler(CallTool.self) { params in
    await logToStderr("Received callTool request for: \(params.name)")
    return await ToolHandlers.handleCallTool(name: params.name, arguments: params.arguments)
}

// 4. Start the server using Stdio transport (stdin/stdout communication)
let transport = StdioTransport()
logToStderr("App Store Connect MCP Server is running and listening on Stdio transport.")

do {
    try await server.start(transport: transport)
    
    // CRITICAL: StdioTransport's start method in the official Swift SDK launches the message handling 
    // loop in a background task and returns immediately. We MUST keep the main thread suspended indefinitely 
    // to prevent the CLI process from terminating and causing "calling 'initialize': EOF" in the IDE.
    try await Task.sleep(nanoseconds: UInt64.max)
} catch {
    logToStderr("Server terminated with error: \(error.localizedDescription)")
    exit(1)
}
