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
  - [ ] Submit version for App Store review / release
  - [x] Query version-level localization text (Implemented: `list_app_store_version_localizations`)
  - [x] Update version-level localization (Description, Keywords, Promotional Text) (Implemented: `update_app_store_version_localizations`)
  - [ ] Manage phased releases / progressive updates
- **App Infos & Categories**:
  - [x] Query app info (including category relationships, etc.) (Implemented: `list_app_infos`)
  - [x] Query category localization (Implemented: `list_app_info_localizations`)
  - [x] Update app subtitle (Implemented: `update_app_info_localizations`)
  - [x] List all official App Store category IDs (Implemented: `list_app_categories`)
  - [x] Modify app primary category (Implemented: `update_app_info`)
  - [ ] Manage data privacy declarations and age ratings
- **Screenshots & Previews**:
  - [ ] List app screenshot sets
  - [ ] Upload app screenshots
  - [ ] Delete, reorder screenshots
  - [ ] Manage app preview sets and assets
- **Pricing & Availability**:
  - [ ] Query or modify global pricing tiers
  - [ ] Configure territory availability (per-country release / takedown)
  - [ ] Manage pre-order status

---

### 2. TestFlight & Beta Testing
- **Builds**:
  - [x] List all builds uploaded from Xcode and their processing status (Implemented: `list_builds`)
  - [x] Get the latest build status for a specific version (Implemented: `get_latest_build_info`)
  - [ ] Update build export compliance declarations
  - [ ] Update TestFlight "What to Test" notes
- **Beta Groups**:
  - [x] List beta test groups for an app (Implemented: `list_beta_groups`)
  - [x] Automatically create public or internal test groups (Implemented: `create_beta_group`)
  - [ ] Modify or delete test groups (e.g., enable Public Link invites)
- **Beta Testers**:
  - [x] List all beta testers in a specific group (Implemented: `list_beta_testers`)
  - [x] Add existing testers to a group (Implemented: `add_beta_tester_to_group`)
  - [ ] Add / invite new beta testers (external / internal)
  - [ ] Remove testers from a group or app
- **Sandbox Testers**:
  - [ ] List sandbox Apple ID accounts
  - [ ] Clear purchase history for a specific sandbox account

---

### 3. In-App Purchases & Subscriptions
- **In-App Purchases (IAP)**:
  - [ ] Create consumable, non-consumable, and non-renewing subscription IAPs
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
  - [ ] Delete published replies

---

### 5. Users, Roles & Permissions
- **Team Members**:
  - [x] List all people and roles under the developer account (Implemented: `list_users`)
  - [ ] Change team member roles
  - [ ] Restrict non-admin users to specific app visibility
- **User Invitations**:
  - [ ] Send email invitations to new team members
  - [ ] Revoke or delete pending invitations

---

### 6. Reports & Analytics
- [ ] Download Sales and Trends Reports (CSV)
- [ ] Download Finance Reports
- [ ] Query app crash logs and statistics
- [ ] Get power, launch time, memory, and other performance metrics

---

### 7. Certificates, Identifiers & Profiles
- [ ] Create, revoke, download development / distribution certificates
- [ ] Register and list test device UDIDs
- [ ] Register Bundle IDs and configure service capabilities
- [ ] Generate, download, and delete provisioning profiles

---

### 8. Advanced Marketing Features
- [ ] Create and configure custom product pages
- [ ] Configure App Store A/B test experiments
- [ ] Create in-app event promotions
