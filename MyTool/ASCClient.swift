import Foundation
import AppStoreConnect_Swift_SDK

public struct ASCClient {
    private let credentials: Credentials

    public init(credentials: Credentials) throws {
        self.credentials = credentials
    }

    private func makeProvider() throws -> APIProvider {
        let configuration = try credentials.makeConfiguration()
        return APIProvider(configuration: configuration)
    }

    /// List Apps in App Store Connect
    public func listApps(limit: Int?) async throws -> [App] {
        let provider = try makeProvider()
        let limitVal = limit ?? 10
        let request = APIEndpoint.v1.apps.get(parameters: .init(limit: limitVal))
        let response = try await provider.request(request)
        return response.data
    }

    /// Get App details
    public func getAppDetails(appId: String) async throws -> App {
        let provider = try makeProvider()
        let request = APIEndpoint.v1.apps.id(appId).get()
        let response = try await provider.request(request)
        return response.data
    }

    /// List Builds, optionally filtered by appId (filtered in memory due to SDK parameters constraint)
    public func listBuilds(appId: String?, limit: Int?) async throws -> [Build] {
        let provider = try makeProvider()
        let limitVal = limit ?? 10
        let request = APIEndpoint.v1.builds.get(parameters: .init(
            filterID: nil,
            limit: limitVal
        ))
        let response = try await provider.request(request)
        if let appId = appId {
            return response.data.filter { build in
                build.relationships?.app?.data?.id == appId
            }
        }
        return response.data
    }

    /// List all App Store Versions for a specific app
    public func listAppStoreVersions(appId: String, limit: Int?) async throws -> [AppStoreVersion] {
        let provider = try makeProvider()
        let limitVal = limit ?? 10
        let request = APIEndpoint.v1.apps.id(appId).appStoreVersions.get(parameters: .init(
            limit: limitVal
        ))
        let response = try await provider.request(request)
        return response.data
    }

    /// Get the latest build for a specific app (sorted by uploadedDate descending)
    public func getLatestBuildInfo(appId: String) async throws -> Build? {
        let provider = try makeProvider()
        let request = APIEndpoint.v1.builds.get(parameters: .init(
            filterID: nil,
            limit: 100 // fetch a reasonable amount to find the latest
        ))
        let response = try await provider.request(request)
        
        let appBuilds = response.data.filter { build in
            build.relationships?.app?.data?.id == appId
        }
        
        // Sort in memory: newest uploadedDate first
        return appBuilds.sorted { (b1, b2) -> Bool in
            guard let d1 = b1.attributes?.uploadedDate else { return false }
            guard let d2 = b2.attributes?.uploadedDate else { return true }
            return d1 > d2
        }.first
    }

    /// Create a new App Store Version
    public func createAppStoreVersion(appId: String, versionString: String, platform: Platform) async throws -> AppStoreVersion {
        let provider = try makeProvider()
        let appData = AppStoreVersionCreateRequest.Data.Relationships.App.Data(
            type: .apps,
            id: appId
        )
        let relationships = AppStoreVersionCreateRequest.Data.Relationships(
            app: .init(data: appData)
        )
        let attributes = AppStoreVersionCreateRequest.Data.Attributes(
            platform: platform,
            versionString: versionString
        )
        let data = AppStoreVersionCreateRequest.Data(
            type: .appStoreVersions,
            attributes: attributes,
            relationships: relationships
        )
        let request = APIEndpoint.v1.appStoreVersions.post(.init(data: data))
        let response = try await provider.request(request)
        return response.data
    }

    /// List all localizations for a specific app store version
    public func listAppStoreVersionLocalizations(versionId: String) async throws -> [AppStoreVersionLocalization] {
        let provider = try makeProvider()
        let request = APIEndpoint.v1.appStoreVersions.id(versionId).appStoreVersionLocalizations.get()
        let response = try await provider.request(request)
        return response.data
    }

    /// Update version localization (promotionalText, description, keywords)
    public func updateAppStoreVersionLocalizations(
        localizationId: String,
        promotionalText: String?,
        description: String?,
        keywords: String?
    ) async throws -> AppStoreVersionLocalization {
        let provider = try makeProvider()
        let attributes = AppStoreVersionLocalizationUpdateRequest.Data.Attributes(
            description: description,
            keywords: keywords,
            promotionalText: promotionalText
        )
        let data = AppStoreVersionLocalizationUpdateRequest.Data(
            type: .appStoreVersionLocalizations,
            id: localizationId,
            attributes: attributes
        )
        let request = APIEndpoint.v1.appStoreVersionLocalizations.id(localizationId).patch(.init(data: data))
        let response = try await provider.request(request)
        return response.data
    }

    private struct SubtitleUpdateRequest: Encodable {
        struct Data: Encodable {
            struct Attributes: Encodable {
                let privacyPolicyUrl: String?
                let subtitle: String?
            }
            let type = "appInfoLocalizations"
            let id: String
            let attributes: Attributes
        }
        let data: Data
    }

    /// List App Infos for a specific app
    public func listAppInfos(appId: String) async throws -> AppStoreConnect_Swift_SDK.AppInfosResponse {
        let provider = try makeProvider()
        let request = APIEndpoint.v1.apps.id(appId).appInfos.get()
        return try await provider.request(request)
    }

    /// List App Info Localizations for a specific App Info
    public func listAppInfoLocalizations(appInfoId: String) async throws -> AppStoreConnect_Swift_SDK.AppInfoLocalizationsResponse {
        let provider = try makeProvider()
        let request = APIEndpoint.v1.appInfos.id(appInfoId).appInfoLocalizations.get()
        return try await provider.request(request)
    }

    /// Update App Info Localization (subtitle, privacyPolicyUrl)
    public func updateAppInfoLocalization(
        localizationId: String,
        subtitle: String?,
        privacyPolicyUrl: String?
    ) async throws -> AppStoreConnect_Swift_SDK.AppInfoLocalizationResponse {
        let provider = try makeProvider()
        let body = SubtitleUpdateRequest(
            data: .init(
                id: localizationId,
                attributes: .init(privacyPolicyUrl: privacyPolicyUrl, subtitle: subtitle)
            )
        )
        let request = Request<AppStoreConnect_Swift_SDK.AppInfoLocalizationResponse>(
            path: "v1/appInfoLocalizations/\(localizationId)",
            method: "PATCH",
            body: body,
            id: "appInfoLocalizations-patch"
        )
        return try await provider.request(request)
    }

    // MARK: - App Category & Info Update
    
    /// List all app categories available on App Store Connect
    public func listAppCategories() async throws -> AppStoreConnect_Swift_SDK.AppCategoriesResponse {
        let provider = try makeProvider()
        let request = APIEndpoint.v1.appCategories.get()
        return try await provider.request(request)
    }
    
    private struct AppInfoUpdateRequest: Encodable {
        struct Data: Encodable {
            struct Relationships: Encodable {
                struct CategoryData: Encodable {
                    let type = "appCategories"
                    let id: String
                }
                struct PrimaryCategory: Encodable {
                    let data: CategoryData
                }
                let primaryCategory: PrimaryCategory
            }
            let type = "appInfos"
            let id: String
            let relationships: Relationships
        }
        let data: Data
    }
    
    /// Update App Info (primary category)
    public func updateAppInfo(appInfoId: String, primaryCategoryId: String) async throws -> AppStoreConnect_Swift_SDK.AppInfoResponse {
        let provider = try makeProvider()
        let body = AppInfoUpdateRequest(
            data: .init(
                id: appInfoId,
                relationships: .init(primaryCategory: .init(data: .init(id: primaryCategoryId)))
            )
        )
        let request = Request<AppStoreConnect_Swift_SDK.AppInfoResponse>(
            path: "v1/appInfos/\(appInfoId)",
            method: "PATCH",
            body: body,
            id: "appInfos-patch"
        )
        return try await provider.request(request)
    }

    // MARK: - TestFlight Beta Management
    
    /// List Beta Groups for a specific app
    public func listBetaGroups(appId: String) async throws -> AppStoreConnect_Swift_SDK.BetaGroupsWithoutIncludesResponse {
        let provider = try makeProvider()
        let request = APIEndpoint.v1.apps.id(appId).betaGroups.get()
        return try await provider.request(request)
    }
    
    private struct BetaGroupCreateRequest: Encodable {
        struct Data: Encodable {
            struct Attributes: Encodable {
                let name: String
            }
            struct Relationships: Encodable {
                struct AppData: Encodable {
                    let type = "apps"
                    let id: String
                }
                struct App: Encodable {
                    let data: AppData
                }
                let app: App
            }
            let type = "betaGroups"
            let attributes: Attributes
            let relationships: Relationships
        }
        let data: Data
    }
    
    /// Create a new Beta Group
    public func createBetaGroup(appId: String, name: String) async throws -> AppStoreConnect_Swift_SDK.BetaGroupResponse {
        let provider = try makeProvider()
        let body = BetaGroupCreateRequest(
            data: .init(
                attributes: .init(name: name),
                relationships: .init(app: .init(data: .init(id: appId)))
            )
        )
        let request = Request<AppStoreConnect_Swift_SDK.BetaGroupResponse>(
            path: "v1/betaGroups",
            method: "POST",
            body: body,
            id: "betaGroups-post"
        )
        return try await provider.request(request)
    }
    
    /// List Beta Testers in a Beta Group
    public func listBetaTesters(betaGroupId: String) async throws -> AppStoreConnect_Swift_SDK.BetaTestersWithoutIncludesResponse {
        let provider = try makeProvider()
        let request = APIEndpoint.v1.betaGroups.id(betaGroupId).betaTesters.get()
        return try await provider.request(request)
    }
    
    private struct BetaTesterGroupLinkageRequest: Encodable {
        struct Data: Encodable {
            let type = "betaTesters"
            let id: String
        }
        let data: [Data]
    }
    
    /// Add an existing Beta Tester to a Beta Group
    public func addBetaTesterToGroup(betaGroupId: String, betaTesterId: String) async throws {
        let provider = try makeProvider()
        let body = BetaTesterGroupLinkageRequest(data: [.init(id: betaTesterId)])
        let request = Request<Void>(
            path: "v1/betaGroups/\(betaGroupId)/relationships/betaTesters",
            method: "POST",
            body: body,
            id: "betaGroups-betaTesters-link"
        )
        try await provider.request(request)
    }

    // MARK: - Customer Reviews
    
    /// List customer reviews for a specific app
    public func listCustomerReviews(appId: String, limit: Int?) async throws -> AppStoreConnect_Swift_SDK.CustomerReviewsResponse {
        let provider = try makeProvider()
        let limitVal = limit ?? 10
        let request = APIEndpoint.v1.apps.id(appId).customerReviews.get(parameters: .init(limit: limitVal))
        return try await provider.request(request)
    }
    
    private struct ReviewReplyRequest: Encodable {
        struct Data: Encodable {
            struct Attributes: Encodable {
                let responseBody: String
            }
            struct Relationships: Encodable {
                struct ReviewData: Encodable {
                    let type = "customerReviews"
                    let id: String
                }
                struct Review: Encodable {
                    let data: ReviewData
                }
                let review: Review
            }
            let type = "customerReviewResponses"
            let attributes: Attributes
            let relationships: Relationships
        }
        let data: Data
    }
    
    /// Submit or update reply to a customer review
    public func submitCustomerReviewReply(reviewId: String, body: String) async throws -> AppStoreConnect_Swift_SDK.CustomerReviewResponseV1Response {
        let provider = try makeProvider()
        let requestBody = ReviewReplyRequest(
            data: .init(
                attributes: .init(responseBody: body),
                relationships: .init(review: .init(data: .init(id: reviewId)))
            )
        )
        let request = Request<AppStoreConnect_Swift_SDK.CustomerReviewResponseV1Response>(
            path: "v1/customerReviewReplies",
            method: "POST",
            body: requestBody,
            id: "customerReviewReplies-post"
        )
        return try await provider.request(request)
    }

    // MARK: - Users & Team Management
    
    /// List users of the developer account
    public func listUsers() async throws -> AppStoreConnect_Swift_SDK.UsersResponse {
        let provider = try makeProvider()
        let request = APIEndpoint.v1.users.get()
        return try await provider.request(request)
    }

    // MARK: - Phase 1: Submissions, Phased Releases, Pricing & Availabilities
    
    private struct VersionSubmissionRequest: Encodable {
        struct Data: Encodable {
            struct Relationships: Encodable {
                struct VersionData: Encodable {
                    let type = "appStoreVersions"
                    let id: String
                }
                struct AppStoreVersion: Encodable {
                    let data: VersionData
                }
                let appStoreVersion: AppStoreVersion
            }
            let type = "appStoreVersionSubmissions"
            let relationships: Relationships
        }
        let data: Data
    }
    
    /// Submit App Store Version for review
    public func submitAppStoreVersion(versionId: String) async throws {
        let provider = try makeProvider()
        let body = VersionSubmissionRequest(
            data: .init(relationships: .init(appStoreVersion: .init(data: .init(id: versionId))))
        )
        let request = Request<Void>(
            path: "v1/appStoreVersionSubmissions",
            method: "POST",
            body: body,
            id: "appStoreVersionSubmissions-post"
        )
        try await provider.request(request)
    }
    
    private struct PhasedReleaseCreateRequest: Encodable {
        struct Data: Encodable {
            struct Attributes: Encodable {
                let phasedReleaseState = "ACTIVE"
            }
            struct Relationships: Encodable {
                struct VersionData: Encodable {
                    let type = "appStoreVersions"
                    let id: String
                }
                struct AppStoreVersion: Encodable {
                    let data: VersionData
                }
                let appStoreVersion: AppStoreVersion
            }
            let type = "appStoreVersionPhasedReleases"
            let attributes: Attributes
            let relationships: Relationships
        }
        let data: Data
    }
    
    private struct PhasedReleaseUpdateRequest: Encodable {
        struct Data: Encodable {
            struct Attributes: Encodable {
                let phasedReleaseState: String // PAUSED, COMPLETE
            }
            let type = "appStoreVersionPhasedReleases"
            let id: String
            let attributes: Attributes
        }
        let data: Data
    }
    
    /// Manage Phased Release for an App Store Version (create, pause, resume, complete)
    public func managePhasedRelease(versionId: String, action: String) async throws -> AppStoreConnect_Swift_SDK.AppStoreVersionPhasedReleaseResponse {
        let provider = try makeProvider()
        
        if action == "create" {
            let body = PhasedReleaseCreateRequest(
                data: .init(
                    attributes: .init(),
                    relationships: .init(appStoreVersion: .init(data: .init(id: versionId)))
                )
            )
            let request = Request<AppStoreConnect_Swift_SDK.AppStoreVersionPhasedReleaseResponse>(
                path: "v1/appStoreVersionPhasedReleases",
                method: "POST",
                body: body,
                id: "phasedReleases-post"
            )
            return try await provider.request(request)
        } else {
            // First find the phased release for this version to get the ID
            let findRequest = APIEndpoint.v1.appStoreVersions.id(versionId).appStoreVersionPhasedRelease.get()
            let findResponse = try await provider.request(findRequest)
            guard let phasedReleaseId = findResponse.data?.id else {
                throw NSError(domain: "ASCClient", code: 404, userInfo: [NSLocalizedDescriptionKey: "No phased release found for version \(versionId)"])
            }
            
            let state: String
            if action == "pause" {
                state = "PAUSED"
            } else if action == "resume" {
                state = "ACTIVE"
            } else if action == "complete" {
                state = "COMPLETE"
            } else {
                throw NSError(domain: "ASCClient", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid phased release action: \(action)"])
            }
            
            let body = PhasedReleaseUpdateRequest(
                data: .init(
                    id: phasedReleaseId,
                    attributes: .init(phasedReleaseState: state)
                )
            )
            let request = Request<AppStoreConnect_Swift_SDK.AppStoreVersionPhasedReleaseResponse>(
                path: "v1/appStoreVersionPhasedReleases/\(phasedReleaseId)",
                method: "PATCH",
                body: body,
                id: "phasedReleases-patch"
            )
            return try await provider.request(request)
        }
    }
    
    /// Get Price Points for an App
    public func listAppPricePoints(appId: String) async throws -> AppStoreConnect_Swift_SDK.AppPricePointsV3Response {
        let provider = try makeProvider()
        let request = APIEndpoint.v1.apps.id(appId).appPricePoints.get()
        return try await provider.request(request)
    }
    
    /// Get current availability/territories for an App (v2)
    public func getAppAvailability(appId: String) async throws -> AppStoreConnect_Swift_SDK.AppAvailabilityV2Response {
        let provider = try makeProvider()
        let request = APIEndpoint.v1.apps.id(appId).appAvailabilityV2.get()
        return try await provider.request(request)
    }
    
    private struct AppAvailabilityCreateRequest: Encodable {
        struct Data: Encodable {
            struct Attributes: Encodable {
                let availableInNewTerritories: Bool
            }
            struct Relationships: Encodable {
                struct AppData: Encodable {
                    let type = "apps"
                    let id: String
                }
                struct App: Encodable {
                    let data: AppData
                }
                struct TerritoryData: Encodable {
                    let type = "territories"
                    let id: String
                }
                struct AvailableTerritories: Encodable {
                    let data: [TerritoryData]
                }
                let app: App
                let availableTerritories: AvailableTerritories
            }
            let type = "appAvailabilities"
            let attributes: Attributes
            let relationships: Relationships
        }
        let data: Data
    }
    
    /// Set app availability globally or for specific territories (v2)
    public func setAppAvailability(appId: String, availableInNewTerritories: Bool, territoryIds: [String]) async throws -> AppStoreConnect_Swift_SDK.AppAvailabilityV2Response {
        let provider = try makeProvider()
        let territories = territoryIds.map { AppAvailabilityCreateRequest.Data.Relationships.TerritoryData(id: $0) }
        let body = AppAvailabilityCreateRequest(
            data: .init(
                attributes: .init(availableInNewTerritories: availableInNewTerritories),
                relationships: .init(
                    app: .init(data: .init(id: appId)),
                    availableTerritories: .init(data: territories)
                )
            )
        )
        let request = Request<AppStoreConnect_Swift_SDK.AppAvailabilityV2Response>(
            path: "v2/appAvailabilities",
            method: "POST",
            body: body,
            id: "appAvailabilities-post"
        )
        return try await provider.request(request)
    }
}
