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

## 🛠️ Build & Install

This server is a native Swift command-line program. You can build it locally using `xcodebuild`:

```bash
cd /Users/jihongbo/Developer/appstoreconnect-mcp
xcodebuild -project appstoreconnect-mcp.xcodeproj -scheme MyTool -configuration Debug
```

The built binary will be located at:
`/Users/jihongbo/Library/Developer/Xcode/DerivedData/appstoreconnect-mcp-dzybcwfrwbweqicopheydixfpeol/Build/Products/Debug/MyTool`

---

## ⚙️ MCP Host Configuration

Add the following configuration to your global MCP config file (typically located at `/Users/jihongbo/.gemini/config/mcp_config.json` or `/Users/yourusername/.codeium/config.json`):

```json
{
  "mcpServers": {
    "appstoreconnect-mcp": {
      "command": "/Users/jihongbo/Library/Developer/Xcode/DerivedData/appstoreconnect-mcp-dzybcwfrwbweqicopheydixfpeol/Build/Products/Debug/MyTool",
      "args": [],
      "env": {
        "APP_STORE_CONNECT_ISSUER_ID": "Your_Issuer_ID_Ex_4f70c262-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
        "APP_STORE_CONNECT_PRIVATE_KEY_ID": "Your_Key_ID_Ex_TKY25M6624",
        "APP_STORE_CONNECT_PRIVATE_KEY_PATH": "/Users/yourusername/Downloads/AuthKey_TKY25M6624.p8"
      }
    }
  }
}
```

### 🔑 Environment Variables:
1. `APP_STORE_CONNECT_ISSUER_ID`: The Issuer ID from the top of the Apple API Keys page.
2. `APP_STORE_CONNECT_PRIVATE_KEY_ID`: The Key ID of your private key.
3. `APP_STORE_CONNECT_PRIVATE_KEY_PATH`: The **absolute path** to your `.p8` private key file downloaded from App Store Connect.

---

## 💻 Debugging & CLI Testing

You can also run the binary directly in your terminal for point diagnostics. Pass the `--test` flag to automatically check your API connection and credentials:

```bash
/Users/jihongbo/Library/Developer/Xcode/DerivedData/appstoreconnect-mcp-dzybcwfrwbweqicopheydixfpeol/Build/Products/Debug/MyTool --test
```
