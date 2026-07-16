import Foundation
import MCP
import AppStoreConnect_Swift_SDK

public struct ToolHandlers {
    // We instantiate ASCClient dynamically per request to avoid global mutable state concurrency issues
    private static func getClient() throws -> ASCClient {
        let credentials = try Credentials.loadFromEnvironment()
        return try ASCClient(credentials: credentials)
    }

    public static func handleCallTool(name: String, arguments: [String: Value]?) async -> CallTool.Result {
        do {
            let client = try getClient()
            
            switch name {
            case "list_apps":
                struct Args: Codable { let limit: Int? }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let apps = try await client.listApps(limit: args.limit)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(apps), annotations: nil, _meta: nil)],
                    isError: false
                )
                
            case "get_app_details":
                struct Args: Codable { let app_id: String }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let app = try await client.getAppDetails(appId: args.app_id)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(app), annotations: nil, _meta: nil)],
                    isError: false
                )
                
            case "list_builds":
                struct Args: Codable {
                    let app_id: String?
                    let limit: Int?
                }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let builds = try await client.listBuilds(appId: args.app_id, limit: args.limit)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(builds), annotations: nil, _meta: nil)],
                    isError: false
                )
                
            case "list_app_store_versions":
                struct Args: Codable {
                    let app_id: String
                    let limit: Int?
                }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let versions = try await client.listAppStoreVersions(appId: args.app_id, limit: args.limit)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(versions), annotations: nil, _meta: nil)],
                    isError: false
                )
                
            case "get_latest_build_info":
                struct Args: Codable { let app_id: String }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                if let build = try await client.getLatestBuildInfo(appId: args.app_id) {
                    return CallTool.Result(
                        content: [.text(text: JSONUtils.prettyPrint(build), annotations: nil, _meta: nil)],
                        isError: false
                    )
                } else {
                    return CallTool.Result(
                        content: [.text(text: "No builds found for app \(args.app_id)", annotations: nil, _meta: nil)],
                        isError: false
                    )
                }
                
            case "create_app_store_version":
                struct Args: Codable {
                    let app_id: String
                    let version_string: String
                    let platform: String
                }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                
                // Map string to Platform enum
                let platformLower = args.platform.lowercased()
                let platform: Platform
                switch platformLower {
                case "ios": platform = .ios
                case "macos": platform = .macOs
                case "tvos": platform = .tvOs
                case "visionos": platform = .visionOs
                default:
                    return CallTool.Result(
                        content: [.text(text: "Invalid platform: \(args.platform). Must be one of: ios, macOs, tvOs, visionOs", annotations: nil, _meta: nil)],
                        isError: true
                    )
                }
                
                let version = try await client.createAppStoreVersion(
                    appId: args.app_id,
                    versionString: args.version_string,
                    platform: platform
                )
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(version), annotations: nil, _meta: nil)],
                    isError: false
                )
                
            case "update_app_store_version_localizations":
                struct Args: Codable {
                    let localization_id: String
                    let promotional_text: String?
                    let description: String?
                    let keywords: String?
                }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let localization = try await client.updateAppStoreVersionLocalizations(
                    localizationId: args.localization_id,
                    promotionalText: args.promotional_text,
                    description: args.description,
                    keywords: args.keywords
                )
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(localization), annotations: nil, _meta: nil)],
                    isError: false
                )
                
            case "list_app_store_version_localizations":
                struct Args: Codable { let version_id: String }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let localizations = try await client.listAppStoreVersionLocalizations(versionId: args.version_id)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(localizations), annotations: nil, _meta: nil)],
                    isError: false
                )
                
            case "list_app_infos":
                struct Args: Codable { let app_id: String }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let appInfos = try await client.listAppInfos(appId: args.app_id)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(appInfos), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "list_app_info_localizations":
                struct Args: Codable { let app_info_id: String }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let localizations = try await client.listAppInfoLocalizations(appInfoId: args.app_info_id)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(localizations), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "update_app_info_localizations":
                struct Args: Codable {
                    let localization_id: String
                    let subtitle: String?
                    let privacy_policy_url: String?
                }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let localization = try await client.updateAppInfoLocalization(
                    localizationId: args.localization_id,
                    subtitle: args.subtitle,
                    privacyPolicyUrl: args.privacy_policy_url
                )
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(localization), annotations: nil, _meta: nil)],
                    isError: false
                )
                
            case "list_app_categories":
                let categories = try await client.listAppCategories()
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(categories), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "update_app_info":
                struct Args: Codable {
                    let app_info_id: String
                    let primary_category_id: String
                }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let appInfo = try await client.updateAppInfo(
                    appInfoId: args.app_info_id,
                    primaryCategoryId: args.primary_category_id
                )
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(appInfo), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "list_beta_groups":
                struct Args: Codable { let app_id: String }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let groups = try await client.listBetaGroups(appId: args.app_id)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(groups), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "create_beta_group":
                struct Args: Codable {
                    let app_id: String
                    let name: String
                }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let group = try await client.createBetaGroup(appId: args.app_id, name: args.name)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(group), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "list_beta_testers":
                struct Args: Codable { let beta_group_id: String }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let testers = try await client.listBetaTesters(betaGroupId: args.beta_group_id)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(testers), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "add_beta_tester_to_group":
                struct Args: Codable {
                    let beta_group_id: String
                    let beta_tester_id: String
                }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                try await client.addBetaTesterToGroup(betaGroupId: args.beta_group_id, betaTesterId: args.beta_tester_id)
                return CallTool.Result(
                    content: [.text(text: "Successfully linked tester \(args.beta_tester_id) to group \(args.beta_group_id).", annotations: nil, _meta: nil)],
                    isError: false
                )

            case "list_customer_reviews":
                struct Args: Codable {
                    let app_id: String
                    let limit: Int?
                }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let reviews = try await client.listCustomerReviews(appId: args.app_id, limit: args.limit)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(reviews), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "submit_customer_review_reply":
                struct Args: Codable {
                    let review_id: String
                    let body: String
                }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let reply = try await client.submitCustomerReviewReply(reviewId: args.review_id, body: args.body)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(reply), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "list_users":
                let users = try await client.listUsers()
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(users), annotations: nil, _meta: nil)],
                    isError: false
                )
                
            case "submit_app_store_version":
                struct Args: Codable { let version_id: String }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                try await client.submitAppStoreVersion(versionId: args.version_id)
                return CallTool.Result(
                    content: [.text(text: "Successfully submitted version \(args.version_id) for review.", annotations: nil, _meta: nil)],
                    isError: false
                )

            case "manage_phased_release":
                struct Args: Codable {
                    let version_id: String
                    let action: String
                }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let phased = try await client.managePhasedRelease(versionId: args.version_id, action: args.action)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(phased), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "list_app_price_points":
                struct Args: Codable { let app_id: String }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let prices = try await client.listAppPricePoints(appId: args.app_id)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(prices), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "get_app_availability":
                struct Args: Codable { let app_id: String }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let availability = try await client.getAppAvailability(appId: args.app_id)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(availability), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "set_app_availability":
                struct Args: Codable {
                    let app_id: String
                    let available_in_new_territories: Bool
                    let territory_ids: [String]
                }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let availability = try await client.setAppAvailability(
                    appId: args.app_id,
                    availableInNewTerritories: args.available_in_new_territories,
                    territoryIds: args.territory_ids
                )
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(availability), annotations: nil, _meta: nil)],
                    isError: false
                )
                
            default:
                return CallTool.Result(
                    content: [.text(text: "Unknown tool: \(name)", annotations: nil, _meta: nil)],
                    isError: true
                )
            }
        } catch {
            return CallTool.Result(
                content: [.text(text: "Error executing tool \(name): \(error.localizedDescription)", annotations: nil, _meta: nil)],
                isError: true
            )
        }
    }
}
