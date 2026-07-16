import Foundation
@preconcurrency import AppStoreConnect_Swift_SDK

public struct ASCClient {
    private let credentials: Credentials
    private let provider: APIProvider

    public init(credentials: Credentials) throws {
        self.credentials = credentials
        self.provider = try APIProvider(configuration: credentials.makeConfiguration())
    }

    /// List Apps in App Store Connect
    public func listApps(limit: Int?) async throws -> [App] {
        let limitVal = limit ?? 10
        let request = APIEndpoint.v1.apps.get(parameters: .init(limit: limitVal))
        let response = try await self.provider.request(request)
        return response.data
    }

    /// Get App details
    public func getAppDetails(appId: String) async throws -> App {
        let request = APIEndpoint.v1.apps.id(appId).get()
        let response = try await self.provider.request(request)
        return response.data
    }

    /// List Builds, optionally filtered by appId (filtered in memory due to SDK parameters constraint)
    public func listBuilds(appId: String?, limit: Int?) async throws -> [Build] {
        let limitVal = limit ?? 10
        let request = APIEndpoint.v1.builds.get(parameters: .init(
            filterID: nil,
            limit: limitVal
        ))
        let response = try await self.provider.request(request)
        if let appId = appId {
            return response.data.filter { build in
                build.relationships?.app?.data?.id == appId
            }
        }
        return response.data
    }

    /// List all App Store Versions for a specific app
    public func listAppStoreVersions(appId: String, limit: Int?) async throws -> [AppStoreVersion] {
        let limitVal = limit ?? 10
        let request = APIEndpoint.v1.apps.id(appId).appStoreVersions.get(parameters: .init(
            limit: limitVal
        ))
        let response = try await self.provider.request(request)
        return response.data
    }

    /// Get the latest build for a specific app (sorted by uploadedDate descending)
    public func getLatestBuildInfo(appId: String) async throws -> Build? {
        let request = APIEndpoint.v1.builds.get(parameters: .init(
            filterID: nil,
            limit: 100 // fetch a reasonable amount to find the latest
        ))
        let response = try await self.provider.request(request)
        
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
        let response = try await self.provider.request(request)
        return response.data
    }

    /// List all localizations for a specific app store version
    public func listAppStoreVersionLocalizations(versionId: String) async throws -> [AppStoreVersionLocalization] {
        let request = APIEndpoint.v1.appStoreVersions.id(versionId).appStoreVersionLocalizations.get()
        let response = try await self.provider.request(request)
        return response.data
    }

    /// Update version localization (promotionalText, description, keywords)
    public func updateAppStoreVersionLocalizations(
        localizationId: String,
        promotionalText: String?,
        description: String?,
        keywords: String?
    ) async throws -> AppStoreVersionLocalization {
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
        let response = try await self.provider.request(request)
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
        let request = APIEndpoint.v1.apps.id(appId).appInfos.get()
        return try await self.provider.request(request)
    }

    /// List App Info Localizations for a specific App Info
    public func listAppInfoLocalizations(appInfoId: String) async throws -> AppStoreConnect_Swift_SDK.AppInfoLocalizationsResponse {
        let request = APIEndpoint.v1.appInfos.id(appInfoId).appInfoLocalizations.get()
        return try await self.provider.request(request)
    }

    /// Update App Info Localization (subtitle, privacyPolicyUrl)
    public func updateAppInfoLocalization(
        localizationId: String,
        subtitle: String?,
        privacyPolicyUrl: String?
    ) async throws -> AppStoreConnect_Swift_SDK.AppInfoLocalizationResponse {
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
        return try await self.provider.request(request)
    }

    // MARK: - App Category & Info Update
    
    /// List all app categories available on App Store Connect
    public func listAppCategories() async throws -> AppStoreConnect_Swift_SDK.AppCategoriesResponse {
        let request = APIEndpoint.v1.appCategories.get()
        return try await self.provider.request(request)
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
        return try await self.provider.request(request)
    }

    // MARK: - TestFlight Beta Management
    
    /// List Beta Groups for a specific app
    public func listBetaGroups(appId: String) async throws -> AppStoreConnect_Swift_SDK.BetaGroupsWithoutIncludesResponse {
        let request = APIEndpoint.v1.apps.id(appId).betaGroups.get()
        return try await self.provider.request(request)
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
        return try await self.provider.request(request)
    }
    
    /// List Beta Testers in a Beta Group
    public func listBetaTesters(betaGroupId: String) async throws -> AppStoreConnect_Swift_SDK.BetaTestersWithoutIncludesResponse {
        let request = APIEndpoint.v1.betaGroups.id(betaGroupId).betaTesters.get()
        return try await self.provider.request(request)
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
        let body = BetaTesterGroupLinkageRequest(data: [.init(id: betaTesterId)])
        let request = Request<Void>(
            path: "v1/betaGroups/\(betaGroupId)/relationships/betaTesters",
            method: "POST",
            body: body,
            id: "betaGroups-betaTesters-link"
        )
        try await self.provider.request(request)
    }

    // MARK: - Customer Reviews
    
    /// List customer reviews for a specific app
    public func listCustomerReviews(appId: String, limit: Int?) async throws -> AppStoreConnect_Swift_SDK.CustomerReviewsResponse {
        let limitVal = limit ?? 10
        let request = APIEndpoint.v1.apps.id(appId).customerReviews.get(parameters: .init(limit: limitVal))
        return try await self.provider.request(request)
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
        return try await self.provider.request(request)
    }

    // MARK: - Users & Team Management
    
    /// List users of the developer account
    public func listUsers() async throws -> AppStoreConnect_Swift_SDK.UsersResponse {
        let request = APIEndpoint.v1.users.get()
        return try await self.provider.request(request)
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
        let body = VersionSubmissionRequest(
            data: .init(relationships: .init(appStoreVersion: .init(data: .init(id: versionId))))
        )
        let request = Request<Void>(
            path: "v1/appStoreVersionSubmissions",
            method: "POST",
            body: body,
            id: "appStoreVersionSubmissions-post"
        )
        try await self.provider.request(request)
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
            return try await self.provider.request(request)
        } else {
            // First find the phased release for this version to get the ID
            let findRequest = APIEndpoint.v1.appStoreVersions.id(versionId).appStoreVersionPhasedRelease.get()
            let findResponse = try await self.provider.request(findRequest)
            let phasedReleaseId = findResponse.data.id
            
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
            return try await self.provider.request(request)
        }
    }
    
    /// Get Price Points for an App
    public func listAppPricePoints(appId: String) async throws -> AppStoreConnect_Swift_SDK.AppPricePointsV3Response {
        let request = APIEndpoint.v1.apps.id(appId).appPricePoints.get()
        return try await self.provider.request(request)
    }
    
    /// Get current availability/territories for an App (v2)
    public func getAppAvailability(appId: String) async throws -> AppStoreConnect_Swift_SDK.AppAvailabilityV2Response {
        let request = APIEndpoint.v1.apps.id(appId).appAvailabilityV2.get()
        return try await self.provider.request(request)
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
        return try await self.provider.request(request)
    }

    // MARK: - Phase 2: Screenshots & Previews
    
    /// List Screenshot Sets for a version localization
    public func listAppScreenshotSets(localizationId: String) async throws -> AppStoreConnect_Swift_SDK.AppScreenshotSetsResponse {
        let request = APIEndpoint.v1.appStoreVersionLocalizations.id(localizationId).appScreenshotSets.get()
        return try await self.provider.request(request)
    }
    
    /// Delete an app screenshot by ID
    public func deleteAppScreenshot(screenshotId: String) async throws {
        let request = APIEndpoint.v1.appScreenshots.id(screenshotId).delete
        try await self.provider.request(request)
    }

    /// Upload a screenshot file (local path) to Apple Store Connect screenshot set
    public func uploadAppScreenshot(screenshotSetId: String, filePath: String) async throws -> AppStoreConnect_Swift_SDK.AppScreenshotResponse {
        let fileURL = URL(fileURLWithPath: filePath)
        let fileData = try Data(contentsOf: fileURL)
        let fileName = fileURL.lastPathComponent
        let fileSize = fileData.count
        
        // 1. Create instance placeholder on Apple to get S3 upload operations
        let createRequest = AppStoreConnect_Swift_SDK.AppScreenshotCreateRequest(
            data: .init(
                type: .appScreenshots,
                attributes: .init(fileSize: fileSize, fileName: fileName),
                relationships: .init(appScreenshotSet: .init(data: .init(type: .appScreenshotSets, id: screenshotSetId)))
            )
        )
        let placeholderRequest = APIEndpoint.v1.appScreenshots.post(createRequest)
        let placeholderResponse = try await self.provider.request(placeholderRequest)
        
        let screenshotId = placeholderResponse.data.id
        guard let operations = placeholderResponse.data.attributes?.uploadOperations else {
            throw NSError(domain: "ASCClient", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to get upload operations from Apple"])
        }
        
        // 2. Perform PUT operations to upload chunks to S3
        for operation in operations {
            guard let urlString = operation.url,
                  let url = URL(string: urlString),
                  let offset = operation.offset,
                  let length = operation.length else {
                continue
            }
            
            let chunkData = fileData.subdata(in: offset..<(offset + length))
            var request = URLRequest(url: url)
            request.httpMethod = operation.method ?? "PUT"
            request.httpBody = chunkData
            
            // Add custom S3 headers required by Apple
            if let headers = operation.requestHeaders {
                for header in headers {
                    if let name = header.name, let value = header.value {
                        request.setValue(value, forHTTPHeaderField: name)
                    }
                }
            }
            
            let (_, urlResponse) = try await URLSession.shared.data(for: request)
            guard let httpResponse = urlResponse as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                throw NSError(domain: "ASCClient", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to upload image chunk to Apple S3 storage"])
            }
        }
        
        // 3. Inform Apple that the upload is completed
        let updateRequest = AppStoreConnect_Swift_SDK.AppScreenshotUpdateRequest(
            data: .init(
                type: .appScreenshots,
                id: screenshotId,
                attributes: .init(isUploaded: true)
            )
        )
        let commitRequest = APIEndpoint.v1.appScreenshots.id(screenshotId).patch(updateRequest)
        return try await self.provider.request(commitRequest)
    }

    // MARK: - Phase 3: TestFlight compliance, invitations, sandbox, roles
    
    /// Update Build Export Compliance (usesNonExemptEncryption)
    public func updateBuildExportCompliance(buildId: String, usesNonExemptEncryption: Bool) async throws -> AppStoreConnect_Swift_SDK.BuildResponse {
        let requestBody = BuildUpdateRequest(
            data: .init(
                type: .builds,
                id: buildId,
                attributes: .init(usesNonExemptEncryption: usesNonExemptEncryption)
            )
        )
        let request = APIEndpoint.v1.builds.id(buildId).patch(requestBody)
        return try await self.provider.request(request)
    }
    
    private struct BetaBuildLocalizationCreateRequestLocal: Encodable {
        struct Data: Encodable {
            struct Attributes: Encodable {
                let locale: String
                let whatsNew: String
            }
            struct Relationships: Encodable {
                struct BuildData: Encodable {
                    let type = "builds"
                    let id: String
                }
                struct Build: Encodable {
                    let data: BuildData
                }
                let build: Build
            }
            let type = "betaBuildLocalizations"
            let attributes: Attributes
            let relationships: Relationships
        }
        let data: Data
    }
    
    private struct BetaBuildLocalizationUpdateRequestLocal: Encodable {
        struct Data: Encodable {
            struct Attributes: Encodable {
                let whatsNew: String
            }
            let type = "betaBuildLocalizations"
            let id: String
            let attributes: Attributes
        }
        let data: Data
    }
    
    /// Update or create TestFlight testing information (What to Test) for a build
    public func updateBuildTestingInfo(buildId: String, locale: String, whatsNew: String) async throws -> AppStoreConnect_Swift_SDK.BetaBuildLocalizationResponse {
        // 1. Fetch existing beta build localizations for this build
        let fetchRequest = APIEndpoint.v1.builds.id(buildId).betaBuildLocalizations.get()
        let fetchResponse = try await self.provider.request(fetchRequest)
        
        if let existing = fetchResponse.data.first(where: { $0.attributes?.locale == locale }) {
            // Update existing localization
            let updateBody = BetaBuildLocalizationUpdateRequestLocal(
                data: .init(id: existing.id, attributes: .init(whatsNew: whatsNew))
            )
            let request = Request<AppStoreConnect_Swift_SDK.BetaBuildLocalizationResponse>(
                path: "v1/betaBuildLocalizations/\(existing.id)",
                method: "PATCH",
                body: updateBody,
                id: "betaBuildLocalizations-patch"
            )
            return try await self.provider.request(request)
        } else {
            // Create a new localization
            let createBody = BetaBuildLocalizationCreateRequestLocal(
                data: .init(
                    attributes: .init(locale: locale, whatsNew: whatsNew),
                    relationships: .init(build: .init(data: .init(id: buildId)))
                )
            )
            let request = Request<AppStoreConnect_Swift_SDK.BetaBuildLocalizationResponse>(
                path: "v1/betaBuildLocalizations",
                method: "POST",
                body: createBody,
                id: "betaBuildLocalizations-post"
            )
            return try await self.provider.request(request)
        }
    }
    
    /// Invite a new Beta Tester and add to a specific Beta Group
    public func inviteBetaTester(email: String, firstName: String?, lastName: String?, betaGroupId: String) async throws -> AppStoreConnect_Swift_SDK.BetaTesterResponse {
        let groupLink = BetaTesterCreateRequest.Data.Relationships.BetaGroups(
            data: [.init(type: .betaGroups, id: betaGroupId)]
        )
        let createRequest = BetaTesterCreateRequest(
            data: .init(
                type: .betaTesters,
                attributes: .init(firstName: firstName, lastName: lastName, email: email),
                relationships: .init(betaGroups: groupLink, builds: nil)
            )
        )
        let request = APIEndpoint.v1.betaTesters.post(createRequest)
        return try await self.provider.request(request)
    }
    
    /// Remove beta tester by ID
    public func removeBetaTester(betaTesterId: String) async throws {
        let request = APIEndpoint.v1.betaTesters.id(betaTesterId).delete
        try await self.provider.request(request)
    }
    
    /// List Sandbox Testers (v2)
    public func listSandboxTesters() async throws -> AppStoreConnect_Swift_SDK.SandboxTestersV2Response {
        let request = APIEndpoint.v2.sandboxTesters.get()
        return try await self.provider.request(request)
    }
    
    /// Clear Sandbox purchase history for a tester
    public func clearSandboxPurchaseHistory(sandboxTesterId: String) async throws -> AppStoreConnect_Swift_SDK.SandboxTestersClearPurchaseHistoryRequestV2Response {
        let testersRelation = SandboxTestersClearPurchaseHistoryRequestV2CreateRequest.Data.Relationships.SandboxTesters(
            data: [.init(type: .sandboxTesters, id: sandboxTesterId)]
        )
        let createRequest = SandboxTestersClearPurchaseHistoryRequestV2CreateRequest(
            data: .init(
                type: .sandboxTestersClearPurchaseHistoryRequest,
                relationships: .init(sandboxTesters: testersRelation)
            )
        )
        let request = APIEndpoint.v2.sandboxTestersClearPurchaseHistoryRequest.post(createRequest)
        return try await self.provider.request(request)
    }
    
    private struct UserRoleUpdateRequest: Encodable {
        struct Data: Encodable {
            struct Attributes: Encodable {
                let roles: [String]
            }
            let type = "users"
            let id: String
            let attributes: Attributes
        }
        let data: Data
    }
    
    /// Update user roles
    public func updateUserRole(userId: String, roles: [String]) async throws -> AppStoreConnect_Swift_SDK.UserResponse {
        let body = UserRoleUpdateRequest(data: .init(id: userId, attributes: .init(roles: roles)))
        let request = Request<AppStoreConnect_Swift_SDK.UserResponse>(
            path: "v1/users/\(userId)",
            method: "PATCH",
            body: body,
            id: "users-patch"
        )
        return try await self.provider.request(request)
    }
    
    private struct UserInvitationCreateRequestLocal: Encodable {
        struct Data: Encodable {
            struct Attributes: Encodable {
                let email: String
                let firstName: String
                let lastName: String
                let roles: [String]
                let allAppsVisible: Bool?
                let provisioningAllowed: Bool?
            }
            let type = "userInvitations"
            let attributes: Attributes
        }
        let data: Data
    }
    
    /// Invite a new team user
    public func inviteTeamUser(email: String, firstName: String, lastName: String, roles: [String]) async throws -> AppStoreConnect_Swift_SDK.UserInvitationResponse {
        let body = UserInvitationCreateRequestLocal(
            data: .init(attributes: .init(
                email: email,
                firstName: firstName,
                lastName: lastName,
                roles: roles,
                allAppsVisible: true,
                provisioningAllowed: true
            ))
        )
        let request = Request<AppStoreConnect_Swift_SDK.UserInvitationResponse>(
            path: "v1/userInvitations",
            method: "POST",
            body: body,
            id: "userInvitations-post"
        )
        return try await self.provider.request(request)
    }

    // MARK: - Phase 4: Certificates, Devices, Profiles
    
    /// List certificates
    public func listCertificates() async throws -> AppStoreConnect_Swift_SDK.CertificatesResponse {
        let request = APIEndpoint.v1.certificates.get()
        return try await self.provider.request(request)
    }
    
    /// List devices
    public func listDevices() async throws -> AppStoreConnect_Swift_SDK.DevicesResponse {
        let request = APIEndpoint.v1.devices.get()
        return try await self.provider.request(request)
    }
    
    private struct DeviceCreateRequestLocal: Encodable {
        struct Data: Encodable {
            struct Attributes: Encodable {
                let name: String
                let platform: String
                let udid: String
            }
            let type = "devices"
            let attributes: Attributes
        }
        let data: Data
    }
    
    /// Register a new provisioning device
    public func registerDevice(name: String, platform: String, udid: String) async throws -> AppStoreConnect_Swift_SDK.DeviceResponse {
        let body = DeviceCreateRequestLocal(data: .init(attributes: .init(name: name, platform: platform, udid: udid)))
        let request = Request<AppStoreConnect_Swift_SDK.DeviceResponse>(
            path: "v1/devices",
            method: "POST",
            body: body,
            id: "devices-post"
        )
        return try await self.provider.request(request)
    }
    
    /// List provisioning profiles
    public func listProvisioningProfiles() async throws -> AppStoreConnect_Swift_SDK.ProfilesResponse {
        let request = APIEndpoint.v1.profiles.get()
        return try await self.provider.request(request)
    }

    // MARK: - Phase 5: Reports, In-App Purchases, and Deletion
    
    /// Helper to decompress gzip Data using system's gunzip utility
    private func decompressGzip(data: Data) throws -> String {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory
        let tempInputURL = tempDir.appendingPathComponent(UUID().uuidString + ".gz")
        
        try data.write(to: tempInputURL)
        
        defer {
            try? fileManager.removeItem(at: tempInputURL)
        }
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/gunzip")
        process.arguments = ["-c", tempInputURL.path]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        try process.run()
        process.waitUntilExit()
        
        let decompressedData = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let resultString = String(data: decompressedData, encoding: .utf8) else {
            throw NSError(domain: "ASCClient", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to decode decompressed data to UTF-8 string"])
        }
        
        return resultString
    }
    
    /// Download Sales and Trends Reports (and decompress automatically)
    public func downloadSalesReports(
        vendorNumber: String,
        reportType: String,
        subType: String,
        frequency: String,
        date: String?,
        version: String?
    ) async throws -> String {
        guard let rType = AppStoreConnect_Swift_SDK.APIEndpoint.V1.SalesReports.GetParameters.FilterReportType(rawValue: reportType),
              let rSubType = AppStoreConnect_Swift_SDK.APIEndpoint.V1.SalesReports.GetParameters.FilterReportSubType(rawValue: subType),
              let rFreq = AppStoreConnect_Swift_SDK.APIEndpoint.V1.SalesReports.GetParameters.FilterFrequency(rawValue: frequency) else {
            throw NSError(domain: "ASCClient", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid reportType, subType, or frequency value."])
        }
        
        let parameters = AppStoreConnect_Swift_SDK.APIEndpoint.V1.SalesReports.GetParameters(
            filterVendorNumber: [vendorNumber],
            filterReportType: [rType],
            filterReportSubType: [rSubType],
            filterFrequency: [rFreq],
            filterReportDate: date != nil ? [date!] : nil,
            filterVersion: version != nil ? [version!] : nil
        )
        
        let request = APIEndpoint.v1.salesReports.get(parameters: parameters)
        let gzipData = try await self.provider.request(request)
        return try decompressGzip(data: gzipData)
    }
    
    /// Download Finance Reports (and decompress automatically)
    public func downloadFinanceReports(
        vendorNumber: String,
        reportType: String,
        regionCode: String,
        date: String
    ) async throws -> String {
        guard let rType = AppStoreConnect_Swift_SDK.APIEndpoint.V1.FinanceReports.GetParameters.FilterReportType(rawValue: reportType) else {
            throw NSError(domain: "ASCClient", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid reportType value."])
        }
        
        let parameters = AppStoreConnect_Swift_SDK.APIEndpoint.V1.FinanceReports.GetParameters(
            filterVendorNumber: [vendorNumber],
            filterReportType: [rType],
            filterRegionCode: [regionCode],
            filterReportDate: [date]
        )
        
        let request = APIEndpoint.v1.financeReports.get(parameters: parameters)
        let gzipData = try await self.provider.request(request)
        return try decompressGzip(data: gzipData)
    }
    
    /// List In-App Purchases (V2) for a specific app
    public func listInAppPurchases(appId: String) async throws -> AppStoreConnect_Swift_SDK.InAppPurchasesV2Response {
        let request = APIEndpoint.v1.apps.id(appId).inAppPurchasesV2.get()
        return try await self.provider.request(request)
    }
    
    private struct InAppPurchaseCreateRequestLocal: Encodable {
        struct Data: Encodable {
            struct Attributes: Encodable {
                let name: String
                let productId: String
                let inAppPurchaseType: String
            }
            struct Relationships: Encodable {
                struct App: Encodable {
                    struct AppData: Encodable {
                        let type = "apps"
                        let id: String
                    }
                    let data: AppData
                }
                let app: App
            }
            let type = "inAppPurchases"
            let attributes: Attributes
            let relationships: Relationships
        }
        let data: Data
    }
    
    /// Create a new In-App Purchase (V2)
    public func createInAppPurchase(appId: String, name: String, productId: String, type: String) async throws -> AppStoreConnect_Swift_SDK.InAppPurchaseV2Response {
        let body = InAppPurchaseCreateRequestLocal(
            data: .init(
                attributes: .init(name: name, productId: productId, inAppPurchaseType: type),
                relationships: .init(app: .init(data: .init(id: appId)))
            )
        )
        let request = Request<AppStoreConnect_Swift_SDK.InAppPurchaseV2Response>(
            path: "v2/inAppPurchases",
            method: "POST",
            body: body,
            id: "inAppPurchasesV2-post"
        )
        return try await self.provider.request(request)
    }
    
    /// Delete a TestFlight Beta Group
    public func deleteBetaGroup(betaGroupId: String) async throws {
        let request = APIEndpoint.v1.betaGroups.id(betaGroupId).delete
        try await self.provider.request(request)
    }
    
    /// Revoke a user invitation
    public func deleteUserInvitation(invitationId: String) async throws {
        let request = APIEndpoint.v1.userInvitations.id(invitationId).delete
        try await self.provider.request(request)
    }
    
    /// Delete developer reply to a customer review
    public func deleteCustomerReviewReply(replyId: String) async throws {
        let request = APIEndpoint.v1.customerReviewResponses.id(replyId).delete
        try await self.provider.request(request)
    }

    // MARK: - Phase 6: Bundle IDs and In-App Purchase Localizations
    
    /// List registered Bundle IDs
    public func listBundleIds() async throws -> AppStoreConnect_Swift_SDK.BundleIDsResponse {
        let request = APIEndpoint.v1.bundleIDs.get()
        return try await self.provider.request(request)
    }
    
    private struct BundleIDCreateRequestLocal: Encodable {
        struct Data: Encodable {
            struct Attributes: Encodable {
                let name: String
                let platform: String
                let identifier: String
            }
            let type = "bundleIds"
            let attributes: Attributes
        }
        let data: Data
    }
    
    /// Register a new Bundle ID
    public func registerBundleId(name: String, platform: String, identifier: String) async throws -> AppStoreConnect_Swift_SDK.BundleIDResponse {
        let body = BundleIDCreateRequestLocal(data: .init(attributes: .init(name: name, platform: platform, identifier: identifier)))
        let request = Request<AppStoreConnect_Swift_SDK.BundleIDResponse>(
            path: "v1/bundleIds",
            method: "POST",
            body: body,
            id: "bundleIds-post"
        )
        return try await self.provider.request(request)
    }
    
    /// List versions of a specific In-App Purchase
    public func listInAppPurchaseVersions(iapId: String) async throws -> AppStoreConnect_Swift_SDK.InAppPurchaseVersionsResponse {
        let request = APIEndpoint.v2.inAppPurchases.id(iapId).versions.get()
        return try await self.provider.request(request)
    }
    
    private struct InAppPurchaseLocalizationV2CreateRequestLocal: Encodable {
        struct Data: Encodable {
            struct Attributes: Encodable {
                let name: String
                let locale: String
                let description: String?
            }
            struct Relationships: Encodable {
                struct Version: Encodable {
                    struct VersionData: Encodable {
                        let type = "inAppPurchaseVersions"
                        let id: String
                    }
                    let data: VersionData
                }
                let version: Version
            }
            let type = "inAppPurchaseLocalizations"
            let attributes: Attributes
            let relationships: Relationships
        }
        let data: Data
    }
    
    /// Create a localization description for an In-App Purchase version
    public func createInAppPurchaseLocalization(
        iapVersionId: String,
        name: String,
        locale: String,
        description: String?
    ) async throws -> AppStoreConnect_Swift_SDK.InAppPurchaseLocalizationV2Response {
        let body = InAppPurchaseLocalizationV2CreateRequestLocal(
            data: .init(
                attributes: .init(name: name, locale: locale, description: description),
                relationships: .init(version: .init(data: .init(id: iapVersionId)))
            )
        )
        let request = Request<AppStoreConnect_Swift_SDK.InAppPurchaseLocalizationV2Response>(
            path: "v2/inAppPurchaseLocalizations",
            method: "POST",
            body: body,
            id: "inAppPurchaseLocalizationsV2-post"
        )
        return try await self.provider.request(request)
    }
    
    private struct InAppPurchaseLocalizationV2UpdateRequestLocal: Encodable {
        struct Data: Encodable {
            struct Attributes: Encodable {
                let name: String?
                let description: String?
            }
            let type = "inAppPurchaseLocalizations"
            let id: String
            let attributes: Attributes
        }
        let data: Data
    }
    
    /// Update an existing In-App Purchase localization (V2)
    public func updateInAppPurchaseLocalization(
        localizationId: String,
        name: String?,
        description: String?
    ) async throws -> AppStoreConnect_Swift_SDK.InAppPurchaseLocalizationV2Response {
        let body = InAppPurchaseLocalizationV2UpdateRequestLocal(
            data: .init(id: localizationId, attributes: .init(name: name, description: description))
        )
        let request = Request<AppStoreConnect_Swift_SDK.InAppPurchaseLocalizationV2Response>(
            path: "v2/inAppPurchaseLocalizations/\(localizationId)",
            method: "PATCH",
            body: body,
            id: "inAppPurchaseLocalizationsV2-patch"
        )
        return try await self.provider.request(request)
    }

    // MARK: - Phase 7: Auto-Renewable Subscription Groups and Items
    
    /// List subscription groups for an app
    public func listSubscriptionGroups(appId: String) async throws -> AppStoreConnect_Swift_SDK.SubscriptionGroupsResponse {
        let request = APIEndpoint.v1.apps.id(appId).subscriptionGroups.get()
        return try await self.provider.request(request)
    }
    
    private struct SubscriptionGroupCreateRequestLocal: Encodable {
        struct Data: Encodable {
            struct Attributes: Encodable {
                let referenceName: String
            }
            struct Relationships: Encodable {
                struct App: Encodable {
                    struct AppData: Encodable {
                        let type = "apps"
                        let id: String
                    }
                    let data: AppData
                }
                let app: App
            }
            let type = "subscriptionGroups"
            let attributes: Attributes
            let relationships: Relationships
        }
        let data: Data
    }
    
    /// Create a new subscription group
    public func createSubscriptionGroup(appId: String, referenceName: String) async throws -> AppStoreConnect_Swift_SDK.SubscriptionGroupResponse {
        let body = SubscriptionGroupCreateRequestLocal(
            data: .init(
                attributes: .init(referenceName: referenceName),
                relationships: .init(app: .init(data: .init(id: appId)))
            )
        )
        let request = Request<AppStoreConnect_Swift_SDK.SubscriptionGroupResponse>(
            path: "v1/subscriptionGroups",
            method: "POST",
            body: body,
            id: "subscriptionGroups-post"
        )
        return try await self.provider.request(request)
    }
    
    /// List subscription items in a specific subscription group
    public func listSubscriptionsInGroup(groupId: String) async throws -> AppStoreConnect_Swift_SDK.SubscriptionsResponse {
        let request = APIEndpoint.v1.subscriptionGroups.id(groupId).subscriptions.get()
        return try await self.provider.request(request)
    }
    
    private struct SubscriptionCreateRequestLocal: Encodable {
        struct Data: Encodable {
            struct Attributes: Encodable {
                let name: String
                let productId: String
                let subscriptionPeriod: String?
                let groupLevel: Int?
            }
            struct Relationships: Encodable {
                struct Group: Encodable {
                    struct GroupData: Encodable {
                        let type = "subscriptionGroups"
                        let id: String
                    }
                    let data: GroupData
                }
                let group: Group
            }
            let type = "subscriptions"
            let attributes: Attributes
            let relationships: Relationships
        }
        let data: Data
    }
    
    /// Create a new auto-renewable subscription item in a group
    public func createSubscription(
        groupId: String,
        name: String,
        productId: String,
        period: String?,
        groupLevel: Int?
    ) async throws -> AppStoreConnect_Swift_SDK.SubscriptionResponse {
        let body = SubscriptionCreateRequestLocal(
            data: .init(
                attributes: .init(name: name, productId: productId, subscriptionPeriod: period, groupLevel: groupLevel),
                relationships: .init(group: .init(data: .init(id: groupId)))
            )
        )
        let request = Request<AppStoreConnect_Swift_SDK.SubscriptionResponse>(
            path: "v1/subscriptions",
            method: "POST",
            body: body,
            id: "subscriptions-post"
        )
        return try await self.provider.request(request)
    }

    // MARK: - Phase 8: Subscription Localizations
    
    /// List localizations for a specific auto-renewable subscription
    public func listSubscriptionLocalizations(subscriptionId: String) async throws -> AppStoreConnect_Swift_SDK.SubscriptionLocalizationsResponse {
        let request = APIEndpoint.v1.subscriptions.id(subscriptionId).subscriptionLocalizations.get()
        return try await self.provider.request(request)
    }
    
    private struct SubscriptionLocalizationCreateRequestLocal: Encodable {
        struct Data: Encodable {
            struct Attributes: Encodable {
                let name: String
                let locale: String
                let description: String?
            }
            struct Relationships: Encodable {
                struct Subscription: Encodable {
                    struct SubscriptionData: Encodable {
                        let type = "subscriptions"
                        let id: String
                    }
                    let data: SubscriptionData
                }
                let subscription: Subscription
            }
            let type = "subscriptionLocalizations"
            let attributes: Attributes
            let relationships: Relationships
        }
        let data: Data
    }
    
    /// Create a localization description for a subscription item
    public func createSubscriptionLocalization(
        subscriptionId: String,
        name: String,
        locale: String,
        description: String?
    ) async throws -> AppStoreConnect_Swift_SDK.SubscriptionLocalizationResponse {
        let body = SubscriptionLocalizationCreateRequestLocal(
            data: .init(
                attributes: .init(name: name, locale: locale, description: description),
                relationships: .init(subscription: .init(data: .init(id: subscriptionId)))
            )
        )
        let request = Request<AppStoreConnect_Swift_SDK.SubscriptionLocalizationResponse>(
            path: "v1/subscriptionLocalizations",
            method: "POST",
            body: body,
            id: "subscriptionLocalizations-post"
        )
        return try await self.provider.request(request)
    }
    
    private struct SubscriptionLocalizationUpdateRequestLocal: Encodable {
        struct Data: Encodable {
            struct Attributes: Encodable {
                let name: String?
                let description: String?
            }
            let type = "subscriptionLocalizations"
            let id: String
            let attributes: Attributes
        }
        let data: Data
    }
    
    /// Update an existing subscription localization
    public func updateSubscriptionLocalization(
        localizationId: String,
        name: String?,
        description: String?
    ) async throws -> AppStoreConnect_Swift_SDK.SubscriptionLocalizationResponse {
        let body = SubscriptionLocalizationUpdateRequestLocal(
            data: .init(id: localizationId, attributes: .init(name: name, description: description))
        )
        let request = Request<AppStoreConnect_Swift_SDK.SubscriptionLocalizationResponse>(
            path: "v1/subscriptionLocalizations/\(localizationId)",
            method: "PATCH",
            body: body,
            id: "subscriptionLocalizations-patch"
        )
        return try await self.provider.request(request)
    }
}
