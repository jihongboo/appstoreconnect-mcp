# AGENTS.md — App Store Connect MCP

## Build

```bash
xcodebuild -project appstoreconnect-mcp.xcodeproj -scheme MyTool -configuration Debug
```

Build output: `~/Library/Developer/Xcode/DerivedData/appstoreconnect-mcp-*/Build/Products/Debug/MyTool`

## Run

Standard MCP stdio mode — the binary reads/writes JSON over stdin/stdout. No other config.

Diagnostic test (reports credential/API/link health):
```bash
<build-output>/MyTool --test
```
Interactive fallback prompts if env vars are missing.

## Credentials (required at runtime)

| Env var | Description |
|---|---|
| `APP_STORE_CONNECT_ISSUER_ID` | UUID from API Keys page |
| `APP_STORE_CONNECT_PRIVATE_KEY_ID` | 10-char Key ID |
| `APP_STORE_CONNECT_PRIVATE_KEY_PATH` | Path to `.p8` file |
| _or_ `APP_STORE_CONNECT_PRIVATE_KEY` | Raw PEM key content |

## Architecture

- **Entrypoint**: `MyTool/main.swift` — `--test` flag runs diagnostics; otherwise starts MCP server on `StdioTransport`.
- **Tool definitions**: `MyTool/Tools/ToolDefinitions.swift` — 25 tools in `ToolDefinitions.allTools`.
- **Handler dispatch**: `MyTool/Tools/ToolHandlers.swift` — decode args → call `ASCClient` → return `CallTool.Result`.
- **API layer**: `MyTool/ASCClient.swift` — wraps `APIProvider` from `AppStoreConnect-Swift-SDK` (v4.4.1) with per-request instantiation.
- **Credentials**: `MyTool/Credentials.swift` — `loadFromEnvironment()` reads env vars, supports `.p8` file or inline PEM string.
- **Utils**: `MyTool/Utils/JSONUtils.swift` — pretty-print JSON, decode MCP `Value` dicts.
- **Transport**: `StdioTransport` via `mcp-swift-sdk` (v0.12.1). Server idle-keeps via `Task.sleep(nanoseconds: UInt64.max)`.

## Key constraints

- **Xcode project, not SwiftPM** — no `Package.swift`. All deps fetched by Xcode during build.
- **Swift 6 warnings** — `RunLoop.current.run()` in `--test` path (async context) and deprecated `.text(...)` API in handlers are pre-existing; avoid "fixing" them without explicit request.
- **No tests, no CI, no linter config** in this repo.
- Adding a new tool requires editing **3 files**: `ToolDefinitions.swift` (schema), `ToolHandlers.swift` (handler), `ASCClient.swift` (API method).
