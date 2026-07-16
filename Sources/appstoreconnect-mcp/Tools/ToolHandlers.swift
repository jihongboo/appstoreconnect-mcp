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
                
            case "list_app_screenshot_sets":
                struct Args: Codable { let localization_id: String }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let sets = try await client.listAppScreenshotSets(localizationId: args.localization_id)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(sets), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "upload_app_screenshot":
                struct Args: Codable {
                    let screenshot_set_id: String
                    let file_path: String
                }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let screenshot = try await client.uploadAppScreenshot(screenshotSetId: args.screenshot_set_id, filePath: args.file_path)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(screenshot), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "delete_app_screenshot":
                struct Args: Codable { let screenshot_id: String }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                try await client.deleteAppScreenshot(screenshotId: args.screenshot_id)
                return CallTool.Result(
                    content: [.text(text: "Successfully deleted app screenshot \(args.screenshot_id).", annotations: nil, _meta: nil)],
                    isError: false
                )

            case "update_build_export_compliance":
                struct Args: Codable {
                    let build_id: String
                    let uses_non_exempt_encryption: Bool
                }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let build = try await client.updateBuildExportCompliance(buildId: args.build_id, usesNonExemptEncryption: args.uses_non_exempt_encryption)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(build), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "update_build_testing_info":
                struct Args: Codable {
                    let build_id: String
                    let locale: String
                    let whats_new: String
                }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let localized = try await client.updateBuildTestingInfo(buildId: args.build_id, locale: args.locale, whatsNew: args.whats_new)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(localized), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "invite_beta_tester":
                struct Args: Codable {
                    let email: String
                    let first_name: String?
                    let last_name: String?
                    let beta_group_id: String
                }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let tester = try await client.inviteBetaTester(email: args.email, firstName: args.first_name, lastName: args.last_name, betaGroupId: args.beta_group_id)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(tester), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "remove_beta_tester":
                struct Args: Codable { let beta_tester_id: String }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                try await client.removeBetaTester(betaTesterId: args.beta_tester_id)
                return CallTool.Result(
                    content: [.text(text: "Successfully removed beta tester \(args.beta_tester_id).", annotations: nil, _meta: nil)],
                    isError: false
                )

            case "list_sandbox_testers":
                let testers = try await client.listSandboxTesters()
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(testers), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "clear_sandbox_purchase_history":
                struct Args: Codable { let sandbox_tester_id: String }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let result = try await client.clearSandboxPurchaseHistory(sandboxTesterId: args.sandbox_tester_id)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(result), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "update_user_role":
                struct Args: Codable {
                    let user_id: String
                    let roles: [String]
                }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let user = try await client.updateUserRole(userId: args.user_id, roles: args.roles)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(user), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "invite_team_user":
                struct Args: Codable {
                    let email: String
                    let first_name: String
                    let last_name: String
                    let roles: [String]
                }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let invitation = try await client.inviteTeamUser(email: args.email, firstName: args.first_name, lastName: args.last_name, roles: args.roles)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(invitation), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "list_certificates":
                let certs = try await client.listCertificates()
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(certs), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "list_devices":
                let devices = try await client.listDevices()
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(devices), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "register_device":
                struct Args: Codable {
                    let name: String
                    let platform: String
                    let udid: String
                }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let device = try await client.registerDevice(name: args.name, platform: args.platform, udid: args.udid)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(device), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "list_provisioning_profiles":
                let profiles = try await client.listProvisioningProfiles()
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(profiles), annotations: nil, _meta: nil)],
                    isError: false
                )
                
            case "download_sales_and_trends_reports":
                struct Args: Codable {
                    let vendor_number: String
                    let report_type: String
                    let sub_type: String
                    let frequency: String
                    let date: String?
                    let version: String?
                }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let csv = try await client.downloadSalesReports(
                    vendorNumber: args.vendor_number,
                    reportType: args.report_type,
                    subType: args.sub_type,
                    frequency: args.frequency,
                    date: args.date,
                    version: args.version
                )
                return CallTool.Result(
                    content: [.text(text: csv, annotations: nil, _meta: nil)],
                    isError: false
                )

            case "download_finance_reports":
                struct Args: Codable {
                    let vendor_number: String
                    let report_type: String
                    let region_code: String
                    let date: String
                }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let csv = try await client.downloadFinanceReports(
                    vendorNumber: args.vendor_number,
                    reportType: args.report_type,
                    regionCode: args.region_code,
                    date: args.date
                )
                return CallTool.Result(
                    content: [.text(text: csv, annotations: nil, _meta: nil)],
                    isError: false
                )

            case "list_in_app_purchases":
                struct Args: Codable { let app_id: String }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let iaps = try await client.listInAppPurchases(appId: args.app_id)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(iaps), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "create_in_app_purchase":
                struct Args: Codable {
                    let app_id: String
                    let name: String
                    let product_id: String
                    let type: String
                }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                let iap = try await client.createInAppPurchase(appId: args.app_id, name: args.name, productId: args.product_id, type: args.type)
                return CallTool.Result(
                    content: [.text(text: JSONUtils.prettyPrint(iap), annotations: nil, _meta: nil)],
                    isError: false
                )

            case "delete_beta_group":
                struct Args: Codable { let beta_group_id: String }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                try await client.deleteBetaGroup(betaGroupId: args.beta_group_id)
                return CallTool.Result(
                    content: [.text(text: "Successfully deleted Beta Group \(args.beta_group_id).", annotations: nil, _meta: nil)],
                    isError: false
                )

            case "delete_user_invitation":
                struct Args: Codable { let invitation_id: String }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                try await client.deleteUserInvitation(invitationId: args.invitation_id)
                return CallTool.Result(
                    content: [.text(text: "Successfully revoked user invitation \(args.invitation_id).", annotations: nil, _meta: nil)],
                    isError: false
                )

            case "delete_customer_review_reply":
                struct Args: Codable { let reply_id: String }
                let args = try JSONUtils.decode(arguments, to: Args.self)
                try await client.deleteCustomerReviewReply(replyId: args.reply_id)
                return CallTool.Result(
                    content: [.text(text: "Successfully deleted customer review reply/response \(args.reply_id).", annotations: nil, _meta: nil)],
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
