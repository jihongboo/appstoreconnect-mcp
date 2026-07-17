# App Store Connect MCP Server (Swift)

This is a Model Context Protocol (MCP) server built in Swift that integrates with the [App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi).

Through this MCP service, AI assistants (such as Claude, Gemini, etc.) can query and manage various App Store Connect resources directly within your editor — including app details, build versions, TestFlight testing, localization text (subtitles, descriptions, keywords), customer review replies, and team member management — greatly improving development and release automation.

For the full scope of the App Store Connect API and the current coverage of MCP tools, see our [Project Roadmap (ROADMAP.md)](./ROADMAP.md).

---

## 🚀 Core Features & MCP Tools

This service exposes the following 20 core API tools via MCP:

### 1. App Details & Version Management
- `list_apps`: List all apps under your account.
- `get_app_details`: Get detailed information about a specific app (e.g., ID, Bundle ID).
- `list_app_store_versions`: List all App Store versions for a given app (e.g., 1.0, 2.0).
- `create_app_store_version`: Create a new App Store version ready for submission (e.g., create version 1.0).

### 2. App Localization Metadata (Subtitle, Description, Keywords)
- `list_app_infos`: Get the app's basic attribute entity (including primary category, secondary category, etc.).
- `list_app_info_localizations`: List localized objects of app-level info in different languages.
- `update_app_info_localizations`: Modify the app subtitle or privacy policy URL.
- `list_app_store_version_localizations`: List localized information for a specific App Store version in different languages.
- `update_app_store_version_localizations`: Modify version-level localization data, including **Description**, **Keywords**, and **Promotional Text**.

### 3. Builds & TestFlight Management
- `list_builds`: List all uploaded IPA builds for a given app or version.
- `get_latest_build_info`: Get the latest build properties and status for a specific app version.
- `list_beta_groups`: Get all TestFlight tester groups for an app.
- `create_beta_group`: Create a new test group in TestFlight automatically.
- `list_beta_testers`: List all beta testers in a specific test group.
- `add_beta_tester_to_group`: Add an existing tester to a TestFlight group.

### 4. Category Queries & Updates
- `list_app_categories`: List all official App Store category IDs (e.g., `NEWS`, `UTILITIES`, `BUSINESS`).
- `update_app_info`: Update core app attributes, such as changing the primary category.

### 5. Customer Reviews & Interaction
- `list_customer_reviews`: Get user ratings and reviews for a specific app (supports `limit`).
- `submit_customer_review_reply`: Submit or modify a developer's official reply to a specific customer review.

### 6. Developer Team Management (Users & Roles)
- `list_users`: List all team members and their roles (e.g., ADMIN, ACCOUNT_HOLDER) under your developer account.

---

## 🛠️ Installation & Setup

This server is a native Swift command-line program targeting macOS 15 and above. You can install it using one of the methods below:

### Option 1: Via Homebrew (Recommended)

If you use macOS, you can easily install the app store connect MCP server from a Homebrew Tap:

```bash
brew install <your-github-username>/tap/appstoreconnect-mcp
```

This will automatically download the pre-compiled, code-signed, and Apple-notarized binary and link it to your system PATH. Once installed, you can verify it by running:

```bash
appstoreconnect-mcp --test
```

### Option 2: Pre-compiled Binaries (GitHub Releases)

1. Go to the [Releases](https://github.com/<your-github-username>/appstoreconnect-mcp/releases) page.
2. Download the latest `appstoreconnect-mcp.zip` archive.
3. Extract the archive to a directory on your machine.
4. Run the executable in your terminal or configure its path in your MCP client.

### Option 3: Build from Source

If you prefer to compile the application locally, clone this repository and build using Swift Package Manager:

```bash
git clone https://github.com/<your-github-username>/appstoreconnect-mcp.git
cd appstoreconnect-mcp
swift build -c release
```

The compiled binary will be located at:
`.build/release/appstoreconnect-mcp`

---

## ⚙️ MCP Client Configuration

To integrate this server with your AI assistant (e.g., Claude Desktop, Cursor, etc.), add the configuration to your global MCP host settings file (typically `~/Library/Application Support/Claude/mcp_config.json` for Claude Desktop).

### If installed via Homebrew:
```json
{
  "mcpServers": {
    "appstoreconnect-mcp": {
      "command": "appstoreconnect-mcp",
      "args": [],
      "env": {
        "APP_STORE_CONNECT_ISSUER_ID": "your-issuer-id",
        "APP_STORE_CONNECT_PRIVATE_KEY_ID": "your-key-id",
        "APP_STORE_CONNECT_PRIVATE_KEY_PATH": "/Users/username/keys/AuthKey_xxxx.p8"
      }
    }
  }
}
```

### If using downloaded/compiled binary:
Set the `"command"` field to the absolute path of the `appstoreconnect-mcp` binary:
```json
{
  "mcpServers": {
    "appstoreconnect-mcp": {
      "command": "/absolute/path/to/appstoreconnect-mcp",
      "args": [],
      "env": {
        "APP_STORE_CONNECT_ISSUER_ID": "your-issuer-id",
        "APP_STORE_CONNECT_PRIVATE_KEY_ID": "your-key-id",
        "APP_STORE_CONNECT_PRIVATE_KEY_PATH": "/Users/username/keys/AuthKey_xxxx.p8"
      }
    }
  }
}
```

### 🔑 Environment Variables & Credentials:
To authorize requests to Apple App Store Connect, configure these variables:
1. `APP_STORE_CONNECT_ISSUER_ID`: Your Apple Developer Issuer ID (UUID format).
2. `APP_STORE_CONNECT_PRIVATE_KEY_ID`: Your 10-character API Key ID.
3. `APP_STORE_CONNECT_PRIVATE_KEY_PATH`: The **absolute path** to your downloaded `.p8` private key file.
4. `APP_STORE_CONNECT_PRIVATE_KEY`: *(Alternative)* The raw content of your PEM private key. Use this instead of `APP_STORE_CONNECT_PRIVATE_KEY_PATH` if you prefer to inline the credentials or run in environment where writing files is not ideal.

---

## 💻 Diagnostics & Testing

You can run the binary with the `--test` flag in your terminal to verify API authentication. If you run it interactively, it will prompt you for missing environment parameters:

```bash
# If installed via Homebrew
appstoreconnect-mcp --test

# If using local binary
/path/to/appstoreconnect-mcp --test
```
