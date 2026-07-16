# AGENTS.md — App Store Connect MCP

## Build

```bash
swift build
```

Build output: `.build/debug/appstoreconnect-mcp`

Release build:
```bash
swift build -c release
```

Build output: `.build/release/appstoreconnect-mcp`

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

- **Entrypoint**: `Sources/appstoreconnect-mcp/main.swift` — `--test` flag runs diagnostics; otherwise starts MCP server on `StdioTransport`.
- **Tool definitions**: `Sources/appstoreconnect-mcp/Tools/ToolDefinitions.swift` — 25 tools in `ToolDefinitions.allTools`.
- **Handler dispatch**: `Sources/appstoreconnect-mcp/Tools/ToolHandlers.swift` — decode args → call `ASCClient` → return `CallTool.Result`.
- **API layer**: `Sources/appstoreconnect-mcp/ASCClient.swift` — wraps `APIProvider` from `AppStoreConnect-Swift-SDK` (v4.4.1) with per-request instantiation.
- **Credentials**: `Sources/appstoreconnect-mcp/Credentials.swift` — `loadFromEnvironment()` reads env vars, supports `.p8` file or inline PEM string.
- **Utils**: `Sources/appstoreconnect-mcp/Utils/JSONUtils.swift` — pretty-print JSON, decode MCP `Value` dicts.
- **Transport**: `StdioTransport` via `mcp-swift-sdk` (v0.12.1). Server idle-keeps via `Task.sleep(nanoseconds: UInt64.max)`.

## Key constraints

- **SwiftPM package** — `Package.swift` at root. Use `swift build` to compile.
- **Swift 6 warnings** — `RunLoop.current.run()` in `--test` path (async context) and deprecated `.text(...)` API in handlers are pre-existing; avoid "fixing" them without explicit request.
- **No tests, no CI, no linter config** in this repo.
- Adding a new tool requires editing **3 files**: `ToolDefinitions.swift` (schema), `ToolHandlers.swift` (handler), `ASCClient.swift` (API method).
