# App Store Connect MCP Server (Swift)

[![appstoreconnect-mcp MCP server](https://glama.ai/mcp/servers/jihongboo/appstoreconnect-mcp/badges/card.svg)](https://glama.ai/mcp/servers/jihongboo/appstoreconnect-mcp)

This is a Model Context Protocol (MCP) server built in Swift that integrates with the [App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi).

Through this MCP service, AI assistants (such as Claude, Gemini, etc.) can query and manage various App Store Connect resources directly within your editor — including app details, build versions, TestFlight testing, localization text (subtitles, descriptions, keywords), customer review replies, and team member management — greatly improving development and release automation.

Currently, **78 API tools** have been implemented, covering almost all core operations. For the full scope of the App Store Connect API and the current coverage details, see the **Core Features & MCP Tools** section below.

---

## 🚀 Core Features & MCP Tools

This service exposes **78 API tools** via MCP, covering almost all key capabilities of App Store Connect.

### 1. App Metadata & Lifecycle Management

<details>
<summary><b>Show details (21/22 tools implemented)</b></summary>

#### App Basics
- [x] List apps (Implemented: `list_apps`)
- [x] Get app details (Implemented: `get_app_details`)

#### App Store Versions
- [x] List versions for a given app (Implemented: `list_app_store_versions`)
- [x] Create a new version ready for submission (Implemented: `create_app_store_version`)
- [x] Submit version for App Store review / release (Implemented: `submit_app_store_version`)
- [x] Query version-level localization text (Implemented: `list_app_store_version_localizations`)
- [x] Update version-level localization (Description, Keywords, Promotional Text) (Implemented: `update_app_store_version_localizations`)
- [x] Manage phased releases / progressive updates (Implemented: `manage_phased_release`)

#### App Infos & Categories
- [x] Query app info (including category relationships, etc.) (Implemented: `list_app_infos`)
- [x] Query category localization (Implemented: `list_app_info_localizations`)
- [x] Update app subtitle (Implemented: `update_app_info_localizations`)
- [x] List all official App Store category IDs (Implemented: `list_app_categories`)
- [x] Modify app primary category (Implemented: `update_app_info`)
- [x] Manage data privacy declarations and age ratings (Implemented: `get_age_rating_declaration`)

#### Screenshots & Previews
- [x] List app screenshot sets (Implemented: `list_app_screenshot_sets`)
- [x] Upload app screenshots (Implemented: `upload_app_screenshot`)
- [x] Delete, reorder screenshots (Implemented: `delete_app_screenshot`)
- [ ] Manage app preview sets and assets

#### Pricing & Availability
- [x] Query or modify global pricing tiers (Implemented: `list_app_price_points`)
- [x] Configure territory availability (per-country release / takedown) (Implemented: `get_app_availability`, `set_app_availability`)
- [x] Manage pre-order status (Implemented: `end_app_pre_order`)

</details>

---

### 2. TestFlight & Beta Testing

<details>
<summary><b>Show details (13/13 tools implemented)</b></summary>

#### Builds
- [x] List all builds uploaded from Xcode and their processing status (Implemented: `list_builds`)
- [x] Get the latest build status for a specific version (Implemented: `get_latest_build_info`)
- [x] Update build export compliance declarations (Implemented: `update_build_export_compliance`)
- [x] Update TestFlight "What to Test" notes (Implemented: `update_build_testing_info`)

#### Beta Groups
- [x] List beta test groups for an app (Implemented: `list_beta_groups`)
- [x] Automatically create public or internal test groups (Implemented: `create_beta_group`)
- [x] Modify or delete test groups (e.g., enable Public Link invites) (Implemented: `delete_beta_group`)

#### Beta Testers
- [x] List all beta testers in a specific group (Implemented: `list_beta_testers`)
- [x] Add existing testers to a group (Implemented: `add_beta_tester_to_group`)
- [x] Add / invite new beta testers (external / internal) (Implemented: `invite_beta_tester`)
- [x] Remove testers from a group or app (Implemented: `remove_beta_tester`)

#### Sandbox Testers
- [x] List sandbox Apple ID accounts (Implemented: `list_sandbox_testers`)
- [x] Clear purchase history for a specific sandbox account (Implemented: `clear_sandbox_purchase_history`)

</details>

---

### 3. In-App Purchases & Subscriptions

<details>
<summary><b>Show details (16/17 tools implemented)</b></summary>

#### In-App Purchases (IAP)
- [x] List In-App Purchases (Implemented: `list_in_app_purchases`)
- [x] Create consumable, non-consumable, and non-renewing subscription IAPs (Implemented: `create_in_app_purchase`)
- [x] Modify/query IAP pricing schedules (Implemented: `get_iap_price_schedule`)
- [x] Manage IAP localized display names and descriptions (Implemented: `list_iap_versions`, `create_iap_localization`, `update_iap_localization`)
- [x] Upload and manage IAP App Store review screenshots (Implemented: `get_iap_review_screenshot`, `create_iap_review_screenshot`)

#### Auto-Renewable Subscriptions
- [x] Create and manage subscription groups and subscription items (Implemented: `list_subscription_groups`, `create_subscription_group`, `list_subscriptions_in_group`, `create_subscription`)
- [x] Configure introductory offers (Implemented: `list_subscription_introductory_offers`)
- [x] Manage promotional offer codes (Implemented: `list_subscription_promotional_offers`)
- [ ] Configure win-back offers
- [x] Manage subscription localizations (Implemented: `list_subscription_localizations`, `create_subscription_localization`, `update_subscription_localization`)

</details>

---

### 4. Ratings & Customer Reviews

<details>
<summary><b>Show details (4/4 tools implemented)</b></summary>

#### Ratings
- [x] Get aggregate rating statistics for an app (Implemented: `get_app_rating_summary`)

#### Customer Reviews
- [x] Fetch reviews and ratings for a specific app (Implemented: `list_customer_reviews`)

#### Review Replies
- [x] Submit or modify developer replies to customer reviews (Implemented: `submit_customer_review_reply`)
- [x] Delete published replies (Implemented: `delete_customer_review_reply`)

</details>

---

### 5. Users, Roles & Permissions

<details>
<summary><b>Show details (6/6 tools implemented)</b></summary>

#### Team Members
- [x] List all people and roles under the developer account (Implemented: `list_users`)
- [x] Change team member roles (Implemented: `update_user_role`)
- [x] Restrict non-admin users to specific app visibility (Implemented: `list_user_visible_apps`, `add_user_visible_apps`)

#### User Invitations
- [x] Send email invitations to new team members (Implemented: `invite_team_user`)
- [x] Revoke or delete pending invitations (Implemented: `delete_user_invitation`)

</details>

---

### 6. Reports & Analytics

<details>
<summary><b>Show details (4/4 tools implemented)</b></summary>

- [x] Download Sales and Trends Reports (CSV) (Implemented: `download_sales_and_trends_reports`)
- [x] Download Finance Reports (Implemented: `download_finance_reports`)
- [x] Query app crash logs and statistics (Implemented: `list_build_diagnostic_signatures`)
- [x] Get power, launch time, memory, and other performance metrics (Implemented: `get_app_perf_metrics`)

</details>

---

### 7. Certificates, Identifiers & Profiles

<details>
<summary><b>Show details (6/6 tools implemented)</b></summary>

- [x] Create, revoke, download development / distribution certificates (Implemented: `list_certificates`)
- [x] Register and list test device UDIDs (Implemented: `list_devices`, `register_device`)
- [x] Register Bundle IDs and configure service capabilities (Implemented: `list_bundle_ids`, `register_bundle_id`)
- [x] Generate, download, and delete provisioning profiles (Implemented: `list_provisioning_profiles`)

</details>

---

### 8. Advanced Marketing Features

<details>
<summary><b>Show details (4/5 tools implemented)</b></summary>

- [x] Create and configure custom product pages (Implemented: `list_custom_product_pages`, `create_custom_product_page`)
- [x] Configure App Store A/B test experiments (Implemented: `list_version_experiments`, `create_version_experiment`)
- [ ] Create in-app event promotions

</details>

---

## 🧠 AI Agent Skills (Customizations)

This repository includes custom agent skills that provide domain-specific guidance for AI assistants (such as Claude, Gemini, Roo Code, or Cline) to ensure reliable execution of complex workflows:

### [App Store Connect Translation & Localization](./skills/appstoreconnect-translation/SKILL.md)
Provides a standardized five-phase translation workflow, golden rules for locale parity, and solutions to common API errors (e.g., `DUPLICATE_NAME` conflicts, first-version `whatsNew` constraints, and keyword character density issues).

If your IDE supports custom skills or agent instructions (e.g., Antigravity IDE, Roo Code, Cline), these skills will be automatically discovered or can be loaded to guide the AI assistant through metadata translations and updates.

---

## 🛠️ Installation & Setup

This server is a native Swift command-line program targeting macOS 15 and above. You can install it using one of the methods below:

### Option 1: One-Click Installation Script (Fastest)

You can install and automatically configure the app store connect MCP server via a single terminal command. This script:
1. Downloads the latest release binary.
2. Installs it directly to `/usr/local/bin`.
3. **Automatically configures** the server for **Claude Desktop**, **Windsurf (Codex)**, **Zed**, and VS Code extensions like **Cline** and **Roo Code** interactively (if installed).
4. **Validates your credentials** on the fly by making a diagnostic API connection test before saving configurations.

To run the installer, execute:

```bash
curl -fsSL https://raw.githubusercontent.com/jihongboo/appstoreconnect-mcp/main/install.sh | bash
```

Once installed, verify it by running:

```bash
appstoreconnect-mcp --test
```

### Option 2: Via Homebrew (Recommended for updates)

If you use macOS, you can install the server from a Homebrew Tap:

```bash
brew install jihongboo/tap/appstoreconnect-mcp
```

This will automatically download the pre-compiled, code-signed, and Apple-notarized binary and link it to your system PATH. Once installed, you can verify it by running:

```bash
appstoreconnect-mcp --test
```

### Option 3: Via Mint

If you use [Mint](https://github.com/yonaskolb/Mint), a package manager for Swift command line tools, you can install it using:

```bash
mint install jihongboo/appstoreconnect-mcp
```

This will clone, build, and install the tool locally. Once installed, you can run it via `mint run appstoreconnect-mcp` or direct path depending on your Mint link settings.

### Option 4: Pre-compiled Binaries (GitHub Releases)

1. Go to the [Releases](https://github.com/jihongboo/appstoreconnect-mcp/releases) page.
2. Download the latest `appstoreconnect-mcp.zip` archive.
3. Extract the archive to a directory on your machine.
4. Run the executable in your terminal or configure its path in your MCP client.

### Option 5: Build from Source

If you prefer to compile the application locally, clone this repository and build using Swift Package Manager:

```bash
git clone https://github.com/jihongboo/appstoreconnect-mcp.git
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

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

