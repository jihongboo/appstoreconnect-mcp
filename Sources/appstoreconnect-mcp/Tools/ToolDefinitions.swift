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
        description: "Update the localized metadata (promotional text, description, keywords) of an App Store version localization.",
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
        setAppAvailability
    ]
}
