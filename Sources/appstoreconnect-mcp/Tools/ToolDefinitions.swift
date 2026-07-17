import MCP

public struct ToolDefinitions {
    public static let listApps = Tool(
        name: "list_apps",
        description: "List apps in your App Store Connect account.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "limit": .object([
                    "type": .string("integer"),
                    "description": .string("Maximum number of apps to return (default 10).")
                ])
            ])
        ])
    )

    public static let getAppDetails = Tool(
        name: "get_app_details",
        description: "Retrieve details of a specific app in your App Store Connect account.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_id": .object([
                    "type": .string("string"),
                    "description": .string("The unique identifier (ID) of the app.")
                ])
            ]),
            "required": .array([.string("app_id")])
        ])
    )

    public static let listBuilds = Tool(
        name: "list_builds",
        description: "List builds, optionally filtered by a specific app.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_id": .object([
                    "type": .string("string"),
                    "description": .string("Filter builds by specific app ID (optional).")
                ]),
                "limit": .object([
                    "type": .string("integer"),
                    "description": .string("Maximum number of builds to return (default 10).")
                ])
            ])
        ])
    )

    public static let listAppStoreVersions = Tool(
        name: "list_app_store_versions",
        description: "List all App Store versions of a specific app.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_id": .object([
                    "type": .string("string"),
                    "description": .string("The unique identifier (ID) of the app.")
                ]),
                "limit": .object([
                    "type": .string("integer"),
                    "description": .string("Maximum number of versions to return (default 10).")
                ])
            ]),
            "required": .array([.string("app_id")])
        ])
    )

    public static let getLatestBuildInfo = Tool(
        name: "get_latest_build_info",
        description: "Get information about the most recently uploaded build for a specific app.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_id": .object([
                    "type": .string("string"),
                    "description": .string("The unique identifier (ID) of the app.")
                ])
            ]),
            "required": .array([.string("app_id")])
        ])
    )

    public static let createAppStoreVersion = Tool(
        name: "create_app_store_version",
        description: "Create a new App Store version for a specific app.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_id": .object([
                    "type": .string("string"),
                    "description": .string("The unique identifier (ID) of the app.")
                ]),
                "version_string": .object([
                    "type": .string("string"),
                    "description": .string("The version string, e.g., '1.0.0'.")
                ]),
                "platform": .object([
                    "type": .string("string"),
                    "description": .string("The platform of the version (ios, macOs, tvOs, visionOs, watchOs).")
                ])
            ]),
            "required": .array([
                .string("app_id"),
                .string("version_string"),
                .string("platform")
            ])
        ])
    )

    public static let updateAppStoreVersionLocalizations = Tool(
        name: "update_app_store_version_localizations",
        description: "Update the localized metadata (promotional text, description, keywords, support URL, marketing URL) of an App Store version localization.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "localization_id": .object([
                    "type": .string("string"),
                    "description": .string("The unique identifier (ID) of the app store version localization.")
                ]),
                "promotional_text": .object([
                    "type": .string("string"),
                    "description": .string("The promotional text (optional).")
                ]),
                "description": .object([
                    "type": .string("string"),
                    "description": .string("The description of the version (optional).")
                ]),
                "keywords": .object([
                    "type": .string("string"),
                    "description": .string("The keywords for search separated by commas (optional).")
                ]),
                "support_url": .object([
                    "type": .string("string"),
                    "description": .string("The support URL (optional).")
                ]),
                "marketing_url": .object([
                    "type": .string("string"),
                    "description": .string("The marketing URL (optional).")
                ])
            ]),
            "required": .array([.string("localization_id")])
        ])
    )
    public static let listAppStoreVersionLocalizations = Tool(
        name: "list_app_store_version_localizations",
        description: "List localizations (e.g. description, keywords) for a specific App Store version.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "version_id": .object([
                    "type": .string("string"),
                    "description": .string("The unique identifier (ID) of the app store version.")
                ])
            ]),
            "required": .array([.string("version_id")])
        ])
    )

    public static let listAppInfos = Tool(
        name: "list_app_infos",
        description: "List App Infos (contains categories) for a specific app.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_id": .object([
                    "type": .string("string"),
                    "description": .string("The unique identifier (ID) of the app.")
                ])
            ]),
            "required": .array([.string("app_id")])
        ])
    )

    public static let listAppInfoLocalizations = Tool(
        name: "list_app_info_localizations",
        description: "List App Info Localizations (contains subtitle, privacy policy) for a specific App Info ID.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_info_id": .object([
                    "type": .string("string"),
                    "description": .string("The unique identifier (ID) of the app info.")
                ])
            ]),
            "required": .array([.string("app_info_id")])
        ])
    )

    public static let updateAppInfoLocalizations = Tool(
        name: "update_app_info_localizations",
        description: "Update the localized App Info (subtitle, privacy policy URL) of an App Info Localization.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "localization_id": .object([
                    "type": .string("string"),
                    "description": .string("The unique identifier (ID) of the app info localization.")
                ]),
                "subtitle": .object([
                    "type": .string("string"),
                    "description": .string("The subtitle of the app (optional).")
                ]),
                "privacy_policy_url": .object([
                    "type": .string("string"),
                    "description": .string("The privacy policy URL (optional).")
                ])
            ]),
            "required": .array([.string("localization_id")])
        ])
    )

    public static let listAppCategories = Tool(
        name: "list_app_categories",
        description: "List all App categories on App Store Connect.",
        inputSchema: .object(["type": .string("object"), "properties": .object([:])])
    )
    
    public static let updateAppInfo = Tool(
        name: "update_app_info",
        description: "Update general App Info, such as setting the primary category.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_info_id": .object(["type": .string("string"), "description": .string("The App Info ID.")]),
                "primary_category_id": .object(["type": .string("string"), "description": .string("The category ID (e.g. UTILITIES).")])
            ]),
            "required": .array([.string("app_info_id"), .string("primary_category_id")])
        ])
    )
    
    public static let listBetaGroups = Tool(
        name: "list_beta_groups",
        description: "List TestFlight beta groups for a specific app.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_id": .object(["type": .string("string"), "description": .string("The unique identifier (ID) of the app.")])
            ]),
            "required": .array([.string("app_id")])
        ])
    )
    
    public static let createBetaGroup = Tool(
        name: "create_beta_group",
        description: "Create a new TestFlight beta group.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_id": .object(["type": .string("string"), "description": .string("The App ID.")]),
                "name": .object(["type": .string("string"), "description": .string("The name of the beta group.")])
            ]),
            "required": .array([.string("app_id"), .string("name")])
        ])
    )
    
    public static let listBetaTesters = Tool(
        name: "list_beta_testers",
        description: "List beta testers in a specific TestFlight beta group.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "beta_group_id": .object(["type": .string("string"), "description": .string("The Beta Group ID.")])
            ]),
            "required": .array([.string("beta_group_id")])
        ])
    )
    
    public static let addBetaTesterToGroup = Tool(
        name: "add_beta_tester_to_group",
        description: "Add an existing beta tester to a TestFlight beta group.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "beta_group_id": .object(["type": .string("string"), "description": .string("The Beta Group ID.")]),
                "beta_tester_id": .object(["type": .string("string"), "description": .string("The Beta Tester ID.")])
            ]),
            "required": .array([.string("beta_group_id"), .string("beta_tester_id")])
        ])
    )
    
    public static let listCustomerReviews = Tool(
        name: "list_customer_reviews",
        description: "List customer reviews for a specific app.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_id": .object(["type": .string("string"), "description": .string("The App ID.")]),
                "limit": .object(["type": .string("integer"), "description": .string("Max reviews to fetch.")])
            ]),
            "required": .array([.string("app_id")])
        ])
    )
    
    public static let submitCustomerReviewReply = Tool(
        name: "submit_customer_review_reply",
        description: "Submit or update a reply to a customer review.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "review_id": .object(["type": .string("string"), "description": .string("The Customer Review ID.")]),
                "body": .object(["type": .string("string"), "description": .string("The reply text body.")])
            ]),
            "required": .array([.string("review_id"), .string("body")])
        ])
    )
    
    public static let listUsers = Tool(
        name: "list_users",
        description: "List developers/members in your developer team account.",
        inputSchema: .object(["type": .string("object"), "properties": .object([:])])
    )

    public static let submitAppStoreVersion = Tool(
        name: "submit_app_store_version",
        description: "Submit an App Store version for review.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "version_id": .object(["type": .string("string"), "description": .string("The App Store Version ID.")])
            ]),
            "required": .array([.string("version_id")])
        ])
    )
    
    public static let managePhasedRelease = Tool(
        name: "manage_phased_release",
        description: "Manage TestFlight / App Store phased release (actions: create, pause, resume, complete).",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "version_id": .object(["type": .string("string"), "description": .string("The App Store Version ID.")]),
                "action": .object(["type": .string("string"), "description": .string("The phased release action: create, pause, resume, complete.")])
            ]),
            "required": .array([.string("version_id"), .string("action")])
        ])
    )
    
    public static let listAppPricePoints = Tool(
        name: "list_app_price_points",
        description: "List App Price Points for a specific app.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_id": .object(["type": .string("string"), "description": .string("The unique identifier (ID) of the app.")])
            ]),
            "required": .array([.string("app_id")])
        ])
    )
    
    public static let getAppAvailability = Tool(
        name: "get_app_availability",
        description: "Get current sales availability and territories for an App.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_id": .object(["type": .string("string"), "description": .string("The unique identifier (ID) of the app.")])
            ]),
            "required": .array([.string("app_id")])
        ])
    )
    
    public static let setAppAvailability = Tool(
        name: "set_app_availability",
        description: "Set App availability globally or for specific territories.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_id": .object(["type": .string("string"), "description": .string("The unique identifier (ID) of the app.")]),
                "available_in_new_territories": .object(["type": .string("boolean"), "description": .string("Whether it is available in new territories.")]),
                "territory_ids": .object([
                    "type": .string("array"),
                    "items": .object(["type": .string("string")]),
                    "description": .string("List of territory ISO codes (e.g. ['USA', 'CHN']).")
                ])
            ]),
            "required": .array([.string("app_id"), .string("available_in_new_territories"), .string("territory_ids")])
        ])
    )

    public static let listAppScreenshotSets = Tool(
        name: "list_app_screenshot_sets",
        description: "List App Screenshot Sets for a specific version localization ID.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "localization_id": .object(["type": .string("string"), "description": .string("The App Store Version Localization ID.")])
            ]),
            "required": .array([.string("localization_id")])
        ])
    )
    
    public static let uploadAppScreenshot = Tool(
        name: "upload_app_screenshot",
        description: "Upload a screenshot from local file path to a specific screenshot set.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "screenshot_set_id": .object(["type": .string("string"), "description": .string("The App Screenshot Set ID.")]),
                "file_path": .object(["type": .string("string"), "description": .string("The absolute local file path of the image.")])
            ]),
            "required": .array([.string("screenshot_set_id"), .string("file_path")])
        ])
    )
    
    public static let deleteAppScreenshot = Tool(
        name: "delete_app_screenshot",
        description: "Delete an app screenshot by ID.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "screenshot_id": .object(["type": .string("string"), "description": .string("The App Screenshot ID.")])
            ]),
            "required": .array([.string("screenshot_id")])
        ])
    )
    
    public static let updateBuildExportCompliance = Tool(
        name: "update_build_export_compliance",
        description: "Set export compliance declaration (usesNonExemptEncryption) on a build.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "build_id": .object(["type": .string("string"), "description": .string("The Build ID.")]),
                "uses_non_exempt_encryption": .object(["type": .string("boolean"), "description": .string("Whether the build uses non-exempt encryption.")])
            ]),
            "required": .array([.string("build_id"), .string("uses_non_exempt_encryption")])
        ])
    )
    
    public static let updateBuildTestingInfo = Tool(
        name: "update_build_testing_info",
        description: "Update TestFlight testing info (What to Test) for a build and locale.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "build_id": .object(["type": .string("string"), "description": .string("The Build ID.")]),
                "locale": .object(["type": .string("string"), "description": .string("The language locale, e.g. en-US.")]),
                "whats_new": .object(["type": .string("string"), "description": .string("The text describing what to test in this build.")])
            ]),
            "required": .array([.string("build_id"), .string("locale"), .string("whats_new")])
        ])
    )
    
    public static let inviteBetaTester = Tool(
        name: "invite_beta_tester",
        description: "Invite a new TestFlight beta tester and add them to a beta group.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "email": .object(["type": .string("string"), "description": .string("Tester's email address.")]),
                "first_name": .object(["type": .string("string"), "description": .string("Optional first name.")]),
                "last_name": .object(["type": .string("string"), "description": .string("Optional last name.")]),
                "beta_group_id": .object(["type": .string("string"), "description": .string("The Beta Group ID.")])
            ]),
            "required": .array([.string("email"), .string("beta_group_id")])
        ])
    )
    
    public static let removeBetaTester = Tool(
        name: "remove_beta_tester",
        description: "Remove a TestFlight beta tester by ID.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "beta_tester_id": .object(["type": .string("string"), "description": .string("The Beta Tester ID.")])
            ]),
            "required": .array([.string("beta_tester_id")])
        ])
    )
    
    public static let listSandboxTesters = Tool(
        name: "list_sandbox_testers",
        description: "List SandBox testers.",
        inputSchema: .object(["type": .string("object"), "properties": .object([:])])
    )
    
    public static let clearSandboxPurchaseHistory = Tool(
        name: "clear_sandbox_purchase_history",
        description: "Clear SandBox purchase history for a specific tester.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "sandbox_tester_id": .object(["type": .string("string"), "description": .string("The Sandbox Tester ID.")])
            ]),
            "required": .array([.string("sandbox_tester_id")])
        ])
    )
    
    public static let updateUserRole = Tool(
        name: "update_user_role",
        description: "Update team user roles on the developer account.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "user_id": .object(["type": .string("string"), "description": .string("The User ID.")]),
                "roles": .object([
                    "type": .string("array"),
                    "items": .object(["type": .string("string")]),
                    "description": .string("List of roles (e.g. ['ADMIN', 'DEVELOPER']).")
                ])
            ]),
            "required": .array([.string("user_id"), .string("roles")])
        ])
    )
    
    public static let inviteTeamUser = Tool(
        name: "invite_team_user",
        description: "Invite a new team member to your developer account.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "email": .object(["type": .string("string"), "description": .string("Email address.")]),
                "first_name": .object(["type": .string("string"), "description": .string("First name.")]),
                "last_name": .object(["type": .string("string"), "description": .string("Last name.")]),
                "roles": .object([
                    "type": .string("array"),
                    "items": .object(["type": .string("string")]),
                    "description": .string("List of roles (e.g. ['DEVELOPER']).")
                ])
            ]),
            "required": .array([.string("email"), .string("first_name"), .string("last_name"), .string("roles")])
        ])
    )
    
    public static let listCertificates = Tool(
        name: "list_certificates",
        description: "List developer certificates.",
        inputSchema: .object(["type": .string("object"), "properties": .object([:])])
    )
    
    public static let listDevices = Tool(
        name: "list_devices",
        description: "List provisioning UDID devices.",
        inputSchema: .object(["type": .string("object"), "properties": .object([:])])
    )
    
    public static let registerDevice = Tool(
        name: "register_device",
        description: "Register a new provisioning UDID device.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "name": .object(["type": .string("string"), "description": .string("Device name.")]),
                "platform": .object(["type": .string("string"), "description": .string("Platform: IOS or MAC_OS.")]),
                "udid": .object(["type": .string("string"), "description": .string("The UDID of the device.")])
            ]),
            "required": .array([.string("name"), .string("platform"), .string("udid")])
        ])
    )
    
    public static let listProvisioningProfiles = Tool(
        name: "list_provisioning_profiles",
        description: "List provisioning profiles.",
        inputSchema: .object(["type": .string("object"), "properties": .object([:])])
    )

    public static let downloadSalesReports = Tool(
        name: "download_sales_and_trends_reports",
        description: "Download App Store Sales and Trends Reports (decompressed CSV format).",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "vendor_number": .object(["type": .string("string"), "description": .string("The Apple vendor number, e.g. 8xxxxxx.")]),
                "report_type": .object(["type": .string("string"), "description": .string("The report type: SALES, PRE_ORDER, NEWSSTAND, SUBSCRIPTION, SUBSCRIPTION_EVENT, SUBSCRIBER, SUBSCRIPTION_OFFER_CODE_REDEMPTION, INSTALLS, FIRST_ANNUAL, WIN_BACK_ELIGIBILITY.")]),
                "sub_type": .object(["type": .string("string"), "description": .string("The report sub-type: SUMMARY, DETAILED, SUMMARY_INSTALL_TYPE, SUMMARY_TERRITORY, SUMMARY_CHANNEL.")]),
                "frequency": .object(["type": .string("string"), "description": .string("The frequency: DAILY, WEEKLY, MONTHLY, YEARLY.")]),
                "date": .object(["type": .string("string"), "description": .string("Optional report date (YYYY-MM-DD or YYYY-MM for monthly).")]),
                "version": .object(["type": .string("string"), "description": .string("Optional report version (e.g. '1_0').")])
            ]),
            "required": .array([.string("vendor_number"), .string("report_type"), .string("sub_type"), .string("frequency")])
        ])
    )
    
    public static let downloadFinanceReports = Tool(
        name: "download_finance_reports",
        description: "Download App Store Financial Reports (decompressed CSV format).",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "vendor_number": .object(["type": .string("string"), "description": .string("The Apple vendor number, e.g. 8xxxxxx.")]),
                "report_type": .object(["type": .string("string"), "description": .string("The report type: FINANCIAL, FINANCE_DETAIL.")]),
                "region_code": .object(["type": .string("string"), "description": .string("The region code (e.g. US, CN, EU).")]),
                "date": .object(["type": .string("string"), "description": .string("The report date (YYYY-MM).")])
            ]),
            "required": .array([.string("vendor_number"), .string("report_type"), .string("region_code"), .string("date")])
        ])
    )
    
    public static let listInAppPurchases = Tool(
        name: "list_in_app_purchases",
        description: "List all In-App Purchases (V2) for a specific app.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_id": .object(["type": .string("string"), "description": .string("The unique identifier (ID) of the app.")])
            ]),
            "required": .array([.string("app_id")])
        ])
    )
    
    public static let createInAppPurchase = Tool(
        name: "create_in_app_purchase",
        description: "Create a new In-App Purchase (V2) item.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_id": .object(["type": .string("string"), "description": .string("The unique identifier (ID) of the app.")]),
                "name": .object(["type": .string("string"), "description": .string("The name of the in-app purchase.")]),
                "product_id": .object(["type": .string("string"), "description": .string("The unique product ID (SKU) for IAP.")]),
                "type": .object(["type": .string("string"), "description": .string("Type: CONSUMABLE, NON_CONSUMABLE, NON_RENEWING_SUBSCRIPTION.")])
            ]),
            "required": .array([.string("app_id"), .string("name"), .string("product_id"), .string("type")])
        ])
    )
    
    public static let deleteBetaGroup = Tool(
        name: "delete_beta_group",
        description: "Delete an existing TestFlight Beta Group.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "beta_group_id": .object(["type": .string("string"), "description": .string("The Beta Group ID.")])
            ]),
            "required": .array([.string("beta_group_id")])
        ])
    )
    
    public static let deleteUserInvitation = Tool(
        name: "delete_user_invitation",
        description: "Revoke a pending team user invitation.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "invitation_id": .object(["type": .string("string"), "description": .string("The User Invitation ID.")])
            ]),
            "required": .array([.string("invitation_id")])
        ])
    )
    
    public static let deleteCustomerReviewReply = Tool(
        name: "delete_customer_review_reply",
        description: "Delete developer reply response to a customer review.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "reply_id": .object(["type": .string("string"), "description": .string("The Customer Review Response/Reply ID.")])
            ]),
            "required": .array([.string("reply_id")])
        ])
    )

    public static let listBundleIds = Tool(
        name: "list_bundle_ids",
        description: "List all registered Bundle IDs.",
        inputSchema: .object(["type": .string("object"), "properties": .object([:])])
    )
    
    public static let registerBundleId = Tool(
        name: "register_bundle_id",
        description: "Register a new Bundle ID for an App.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "name": .object(["type": .string("string"), "description": .string("The name of the Bundle ID.")]),
                "platform": .object(["type": .string("string"), "description": .string("Platform: IOS, MAC_OS, UNIVERSAL.")]),
                "identifier": .object(["type": .string("string"), "description": .string("The unique identifier, e.g. com.example.app.")])
            ]),
            "required": .array([.string("name"), .string("platform"), .string("identifier")])
        ])
    )
    
    public static let listIapVersions = Tool(
        name: "list_iap_versions",
        description: "List versions of a specific In-App Purchase.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "iap_id": .object(["type": .string("string"), "description": .string("The In-App Purchase V2 ID.")])
            ]),
            "required": .array([.string("iap_id")])
        ])
    )
    
    public static let createIapLocalization = Tool(
        name: "create_iap_localization",
        description: "Create localization metadata for an In-App Purchase version.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "iap_version_id": .object(["type": .string("string"), "description": .string("The In-App Purchase Version ID.")]),
                "name": .object(["type": .string("string"), "description": .string("The display name of the IAP product.")]),
                "locale": .object(["type": .string("string"), "description": .string("The locale code, e.g. en-US.")]),
                "description": .object(["type": .string("string"), "description": .string("Optional description for the IAP product.")])
            ]),
            "required": .array([.string("iap_version_id"), .string("name"), .string("locale")])
        ])
    )
    
    public static let updateIapLocalization = Tool(
        name: "update_iap_localization",
        description: "Update localization metadata for an In-App Purchase localization.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "localization_id": .object(["type": .string("string"), "description": .string("The In-App Purchase Localization V2 ID.")]),
                "name": .object(["type": .string("string"), "description": .string("Optional new display name.")]),
                "description": .object(["type": .string("string"), "description": .string("Optional new description.")])
            ]),
            "required": .array([.string("localization_id")])
        ])
    )



    public static let listSubscriptionGroups = Tool(
        name: "list_subscription_groups",
        description: "List subscription groups for a specific app.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_id": .object(["type": .string("string"), "description": .string("The unique identifier (ID) of the app.")])
            ]),
            "required": .array([.string("app_id")])
        ])
    )
    
    public static let createSubscriptionGroup = Tool(
        name: "create_subscription_group",
        description: "Create a new auto-renewable subscription group for an app.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_id": .object(["type": .string("string"), "description": .string("The unique identifier (ID) of the app.")]),
                "reference_name": .object(["type": .string("string"), "description": .string("The reference name of the subscription group.")])
            ]),
            "required": .array([.string("app_id"), .string("reference_name")])
        ])
    )
    
    public static let listSubscriptionsInGroup = Tool(
        name: "list_subscriptions_in_group",
        description: "List subscription items inside a specific subscription group.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "group_id": .object(["type": .string("string"), "description": .string("The subscription group ID.")])
            ]),
            "required": .array([.string("group_id")])
        ])
    )
    
    public static let createSubscription = Tool(
        name: "create_subscription",
        description: "Create a new auto-renewable subscription item in a group.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "group_id": .object(["type": .string("string"), "description": .string("The subscription group ID.")]),
                "name": .object(["type": .string("string"), "description": .string("The display name of the subscription.")]),
                "product_id": .object(["type": .string("string"), "description": .string("The unique product ID (SKU) for this subscription.")]),
                "period": .object(["type": .string("string"), "description": .string("Period: ONE_WEEK, ONE_MONTH, TWO_MONTHS, THREE_MONTHS, SIX_MONTHS, ONE_YEAR.")]),
                "group_level": .object(["type": .string("integer"), "description": .string("Optional group level (1 is highest, then 2, etc.)")])
            ]),
            "required": .array([.string("group_id"), .string("name"), .string("product_id")])
        ])
    )

    public static let listSubscriptionLocalizations = Tool(
        name: "list_subscription_localizations",
        description: "List localization metadata for a specific auto-renewable subscription.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "subscription_id": .object(["type": .string("string"), "description": .string("The subscription item ID.")])
            ]),
            "required": .array([.string("subscription_id")])
        ])
    )
    
    public static let createSubscriptionLocalization = Tool(
        name: "create_subscription_localization",
        description: "Create localization metadata for a subscription item.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "subscription_id": .object(["type": .string("string"), "description": .string("The subscription item ID.")]),
                "name": .object(["type": .string("string"), "description": .string("The display name of the subscription product.")]),
                "locale": .object(["type": .string("string"), "description": .string("The locale code, e.g. en-US.")]),
                "description": .object(["type": .string("string"), "description": .string("Optional description for the subscription product.")])
            ]),
            "required": .array([.string("subscription_id"), .string("name"), .string("locale")])
        ])
    )
    
    public static let updateSubscriptionLocalization = Tool(
        name: "update_subscription_localization",
        description: "Update localization metadata for an existing subscription localization.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "localization_id": .object(["type": .string("string"), "description": .string("The subscription localization ID.")]),
                "name": .object(["type": .string("string"), "description": .string("Optional new display name.")]),
                "description": .object(["type": .string("string"), "description": .string("Optional new description.")])
            ]),
            "required": .array([.string("localization_id")])
        ])
    )

    public static let listUserVisibleApps = Tool(
        name: "list_user_visible_apps",
        description: "List apps visible to a specific non-admin user.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "user_id": .object(["type": .string("string"), "description": .string("The unique ID of the user.")])
            ]),
            "required": .array([.string("user_id")])
        ])
    )
    
    public static let addUserVisibleApps = Tool(
        name: "add_user_visible_apps",
        description: "Grant specific apps visibility to a non-admin user.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "user_id": .object(["type": .string("string"), "description": .string("The unique ID of the user.")]),
                "app_ids": .object(["type": .array([.string("string")]), "description": .string("Array of App unique IDs.")])
            ]),
            "required": .array([.string("user_id"), .string("app_ids")])
        ])
    )
    
    public static let listCustomProductPages = Tool(
        name: "list_custom_product_pages",
        description: "List Custom Product Pages for a specific app.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_id": .object(["type": .string("string"), "description": .string("The unique ID of the app.")])
            ]),
            "required": .array([.string("app_id")])
        ])
    )
    
    public static let createCustomProductPage = Tool(
        name: "create_custom_product_page",
        description: "Create a new Custom Product Page for an app.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_id": .object(["type": .string("string"), "description": .string("The unique ID of the app.")]),
                "name": .object(["type": .string("string"), "description": .string("The promotional name of the custom product page.")])
            ]),
            "required": .array([.string("app_id"), .string("name")])
        ])
    )
    
    public static let listVersionExperiments = Tool(
        name: "list_version_experiments",
        description: "List App Store Version Experiments (A/B Tests) for an app.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_id": .object(["type": .string("string"), "description": .string("The unique ID of the app.")])
            ]),
            "required": .array([.string("app_id")])
        ])
    )
    
    public static let createVersionExperiment = Tool(
        name: "create_version_experiment",
        description: "Create a new App Store Version Experiment (A/B Test) for an app.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_id": .object(["type": .string("string"), "description": .string("The unique ID of the app.")]),
                "name": .object(["type": .string("string"), "description": .string("The name of the A/B test experiment.")]),
                "platform": .object(["type": .string("string"), "description": .string("Platform: IOS, MAC_OS, TV_OS, VISION_OS.")]),
                "traffic_proportion": .object(["type": .string("integer"), "description": .string("Traffic split percentage (e.g. 50).")])
            ]),
            "required": .array([.string("app_id"), .string("name"), .string("platform"), .string("traffic_proportion")])
        ])
    )

    public static let getAppRatingSummary = Tool(
        name: "get_app_rating_summary",
        description: "Get aggregate customer reviews and ratings summarization for an app.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_id": .object(["type": .string("string"), "description": .string("The unique ID of the app.")]),
                "platform": .object(["type": .string("string"), "description": .string("Optional filter platform: IOS, MAC_OS, TV_OS, VISION_OS. Default is IOS.")])
            ]),
            "required": .array([.string("app_id")])
        ])
    )
    
    public static let listSubscriptionIntroductoryOffers = Tool(
        name: "list_subscription_introductory_offers",
        description: "List introductory offers for a specific auto-renewable subscription product.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "subscription_id": .object(["type": .string("string"), "description": .string("The subscription item ID.")])
            ]),
            "required": .array([.string("subscription_id")])
        ])
    )
    
    public static let listSubscriptionPromotionalOffers = Tool(
        name: "list_subscription_promotional_offers",
        description: "List promotional offers (offer codes) for a specific auto-renewable subscription product.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "subscription_id": .object(["type": .string("string"), "description": .string("The subscription item ID.")])
            ]),
            "required": .array([.string("subscription_id")])
        ])
    )

    public static let getIapPriceSchedule = Tool(
        name: "get_iap_price_schedule",
        description: "Get pricing points and availability schedule for a specific In-App Purchase.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "iap_id": .object(["type": .string("string"), "description": .string("The In-App Purchase unique ID.")])
            ]),
            "required": .array([.string("iap_id")])
        ])
    )
    
    public static let getIapReviewScreenshot = Tool(
        name: "get_iap_review_screenshot",
        description: "Get App Store Review Screenshot status for a specific In-App Purchase.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "iap_id": .object(["type": .string("string"), "description": .string("The In-App Purchase unique ID.")])
            ]),
            "required": .array([.string("iap_id")])
        ])
    )
    
    public static let createIapReviewScreenshot = Tool(
        name: "create_iap_review_screenshot",
        description: "Create an App Store Review Screenshot record for an In-App Purchase.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "iap_id": .object(["type": .string("string"), "description": .string("The In-App Purchase unique ID.")]),
                "file_name": .object(["type": .string("string"), "description": .string("The file name, e.g. screenshot.png.")]),
                "file_size": .object(["type": .string("integer"), "description": .string("The file size in bytes.")])
            ]),
            "required": .array([.string("iap_id"), .string("file_name"), .string("file_size")])
        ])
    )

    public static let getAppPerfMetrics = Tool(
        name: "get_app_perf_metrics",
        description: "Get performance and power metrics (hang rate, battery, launch time, memory) for a specific app.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_id": .object(["type": .string("string"), "description": .string("The unique ID of the app.")]),
                "platform": .object(["type": .string("string"), "description": .string("Optional filter platform: IOS.")]),
                "metric_type": .object(["type": .string("string"), "description": .string("Optional filter metric type: DISK, HANG, BATTERY, LAUNCH, MEMORY, ANIMATION, TERMINATION, STORAGE.")])
            ]),
            "required": .array([.string("app_id")])
        ])
    )
    
    public static let listBuildDiagnosticSignatures = Tool(
        name: "list_build_diagnostic_signatures",
        description: "List diagnostic signatures (crash logs, hang logs) for a specific Xcode build.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "build_id": .object(["type": .string("string"), "description": .string("The build unique ID.")]),
                "diagnostic_type": .object(["type": .string("string"), "description": .string("Optional diagnostic type filter: DISK_WRITES, HANGS, LAUNCHES.")]),
                "limit": .object(["type": .string("integer"), "description": .string("Optional pagination limit (1-50).")])
            ]),
            "required": .array([.string("build_id")])
        ])
    )
    
    public static let getAgeRatingDeclaration = Tool(
        name: "get_age_rating_declaration",
        description: "Get age rating declaration details for a specific app info ID.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_info_id": .object(["type": .string("string"), "description": .string("The app info ID.")])
            ]),
            "required": .array([.string("app_info_id")])
        ])
    )
    
    public static let endAppPreOrder = Tool(
        name: "end_app_pre_order",
        description: "End app pre-order state immediately and make the app available on App Store.",
        inputSchema: .object([
            "type": .string("object"),
            "properties": .object([
                "app_id": .object(["type": .string("string"), "description": .string("The unique ID of the app.")])
            ]),
            "required": .array([.string("app_id")])
        ])
    )

    public static let allTools = [
        listApps,
        getAppDetails,
        listBuilds,
        listAppStoreVersions,
        getLatestBuildInfo,
        createAppStoreVersion,
        updateAppStoreVersionLocalizations,
        listAppStoreVersionLocalizations,
        listAppInfos,
        listAppInfoLocalizations,
        updateAppInfoLocalizations,
        listAppCategories,
        updateAppInfo,
        listBetaGroups,
        createBetaGroup,
        listBetaTesters,
        addBetaTesterToGroup,
        listCustomerReviews,
        submitCustomerReviewReply,
        listUsers,
        submitAppStoreVersion,
        managePhasedRelease,
        listAppPricePoints,
        getAppAvailability,
        setAppAvailability,
        listAppScreenshotSets,
        uploadAppScreenshot,
        deleteAppScreenshot,
        updateBuildExportCompliance,
        updateBuildTestingInfo,
        inviteBetaTester,
        removeBetaTester,
        listSandboxTesters,
        clearSandboxPurchaseHistory,
        updateUserRole,
        inviteTeamUser,
        listCertificates,
        listDevices,
        registerDevice,
        listProvisioningProfiles,
        downloadSalesReports,
        downloadFinanceReports,
        listInAppPurchases,
        createInAppPurchase,
        deleteBetaGroup,
        deleteUserInvitation,
        deleteCustomerReviewReply,
        listBundleIds,
        registerBundleId,
        listIapVersions,
        createIapLocalization,
        updateIapLocalization,
        listSubscriptionGroups,
        createSubscriptionGroup,
        listSubscriptionsInGroup,
        createSubscription,
        listSubscriptionLocalizations,
        createSubscriptionLocalization,
        updateSubscriptionLocalization,
        listUserVisibleApps,
        addUserVisibleApps,
        listCustomProductPages,
        createCustomProductPage,
        listVersionExperiments,
        createVersionExperiment,
        getAppRatingSummary,
        listSubscriptionIntroductoryOffers,
        listSubscriptionPromotionalOffers,
        getIapPriceSchedule,
        getIapReviewScreenshot,
        createIapReviewScreenshot,
        getAppPerfMetrics,
        listBuildDiagnosticSignatures,
        getAgeRatingDeclaration,
        endAppPreOrder
    ]
}
