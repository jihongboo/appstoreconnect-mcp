# App Store Connect API Todo List

This document lists all core capabilities supported by the Apple [App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi) and marks the tools already implemented by this MCP server.

---

## 📋 Business Areas & Capabilities

### 1. App Metadata & Lifecycle Management
- **App Basics**:
  - [x] List apps (Implemented: `list_apps`)
  - [x] Get app details (Implemented: `get_app_details`)
- **App Store Versions**:
  - [x] List versions for a given app (Implemented: `list_app_store_versions`)
  - [x] Create a new version ready for submission (Implemented: `create_app_store_version`)
  - [x] Submit version for App Store review / release (Implemented: `submit_app_store_version`)
  - [x] Query version-level localization text (Implemented: `list_app_store_version_localizations`)
  - [x] Update version-level localization (Description, Keywords, Promotional Text) (Implemented: `update_app_store_version_localizations`)
  - [x] Manage phased releases / progressive updates (Implemented: `manage_phased_release`)
- **App Infos & Categories**:
  - [x] Query app info (including category relationships, etc.) (Implemented: `list_app_infos`)
  - [x] Query category localization (Implemented: `list_app_info_localizations`)
  - [x] Update app subtitle (Implemented: `update_app_info_localizations`)
  - [x] List all official App Store category IDs (Implemented: `list_app_categories`)
  - [x] Modify app primary category (Implemented: `update_app_info`)
  - [ ] Manage data privacy declarations and age ratings
- **Screenshots & Previews**:
  - [x] List app screenshot sets (Implemented: `list_app_screenshot_sets`)
  - [x] Upload app screenshots (Implemented: `upload_app_screenshot`)
  - [x] Delete, reorder screenshots (Implemented: `delete_app_screenshot`)
  - [ ] Manage app preview sets and assets
- **Pricing & Availability**:
  - [x] Query or modify global pricing tiers (Implemented: `list_app_price_points`)
  - [x] Configure territory availability (per-country release / takedown) (Implemented: `get_app_availability`, `set_app_availability`)
  - [ ] Manage pre-order status

---

### 2. TestFlight & Beta Testing
- **Builds**:
  - [x] List all builds uploaded from Xcode and their processing status (Implemented: `list_builds`)
  - [x] Get the latest build status for a specific version (Implemented: `get_latest_build_info`)
  - [x] Update build export compliance declarations (Implemented: `update_build_export_compliance`)
  - [x] Update TestFlight "What to Test" notes (Implemented: `update_build_testing_info`)
- **Beta Groups**:
  - [x] List beta test groups for an app (Implemented: `list_beta_groups`)
  - [x] Automatically create public or internal test groups (Implemented: `create_beta_group`)
  - [x] Modify or delete test groups (e.g., enable Public Link invites) (Implemented: `delete_beta_group`)
- **Beta Testers**:
  - [x] List all beta testers in a specific group (Implemented: `list_beta_testers`)
  - [x] Add existing testers to a group (Implemented: `add_beta_tester_to_group`)
  - [x] Add / invite new beta testers (external / internal) (Implemented: `invite_beta_tester`)
  - [x] Remove testers from a group or app (Implemented: `remove_beta_tester`)
- **Sandbox Testers**:
  - [x] List sandbox Apple ID accounts (Implemented: `list_sandbox_testers`)
  - [x] Clear purchase history for a specific sandbox account (Implemented: `clear_sandbox_purchase_history`)

---

### 3. In-App Purchases & Subscriptions
- **In-App Purchases (IAP)**:
  - [x] List In-App Purchases (Implemented: `list_in_app_purchases`)
  - [x] Create consumable, non-consumable, and non-renewing subscription IAPs (Implemented: `create_in_app_purchase`)
  - [ ] Modify IAP metadata and pricing schedules
  - [ ] Manage IAP localized display names and descriptions
  - [ ] Upload and manage IAP App Store review screenshots
- **Auto-Renewable Subscriptions**:
  - [ ] Create and manage subscription groups and subscription items
  - [ ] Configure introductory offers
  - [ ] Manage promotional offer codes
  - [ ] Configure win-back offers

---

### 4. Ratings & Customer Reviews
- **Ratings**:
  - [ ] Get aggregate rating statistics for an app
- **Customer Reviews**:
  - [x] Fetch reviews and ratings for a specific app (Implemented: `list_customer_reviews`)
- **Review Replies**:
  - [x] Submit or modify developer replies to customer reviews (Implemented: `submit_customer_review_reply`)
  - [x] Delete published replies (Implemented: `delete_customer_review_reply`)

---

### 5. Users, Roles & Permissions
- **Team Members**:
  - [x] List all people and roles under the developer account (Implemented: `list_users`)
  - [x] Change team member roles (Implemented: `update_user_role`)
  - [ ] Restrict non-admin users to specific app visibility
- **User Invitations**:
  - [x] Send email invitations to new team members (Implemented: `invite_team_user`)
  - [x] Revoke or delete pending invitations (Implemented: `delete_user_invitation`)

---

### 6. Reports & Analytics
- [x] Download Sales and Trends Reports (CSV) (Implemented: `download_sales_and_trends_reports`)
- [x] Download Finance Reports (Implemented: `download_finance_reports`)
- [ ] Query app crash logs and statistics
- [ ] Get power, launch time, memory, and other performance metrics

---

### 7. Certificates, Identifiers & Profiles
- [x] Create, revoke, download development / distribution certificates (Implemented: `list_certificates`)
- [x] Register and list test device UDIDs (Implemented: `list_devices`, `register_device`)
- [ ] Register Bundle IDs and configure service capabilities
- [x] Generate, download, and delete provisioning profiles (Implemented: `list_provisioning_profiles`)

---

### 8. Advanced Marketing Features
- [ ] Create and configure custom product pages
- [ ] Configure App Store A/B test experiments
- [ ] Create in-app event promotions
