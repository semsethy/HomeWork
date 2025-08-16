//
//  HWHomeViewModel.swift
//  HomeWork
//
//  Created by JoshipTy on 2/8/25.
//

import Foundation
import Combine
import UIKit

// MARK: - Transaction Type Enum
/// Represents the types of transactions available in the app.
///
/// Each case corresponds to a transaction category supported by the bank,
/// along with its associated icon resource name.
enum TransType: String, Equatable, Decodable {
    case cubc = "CUBC"
    case mobile = "Mobile"
    case pmf = "PMF"
    case creditCard = "CreditCard"
    
    /// Icon asset name associated with the transaction type.
    var icon: String {
        switch self {
        case .cubc: return "button00ElementScrollTree"
        case .mobile: return "button00ElementScrollMobile"
        case .pmf: return "button00ElementScrollBuilding"
        case .creditCard: return "button00ElementScrollCreditCard"
        }
    }
}

// MARK: - Account List Type Enum
/// Defines categories of bank accounts supported by the system.
enum AccountListType {
    case savings, fixed, digital
}

// MARK: - API Response Model for Account Balances
/// Represents the grouped account list response from the API.
struct AccountListResult: Decodable {
    let savingsList: [AccountItem]?
    let fixedDepositList: [AccountItem]?
    let digitalList: [AccountItem]?

    /// Returns the corresponding list based on the requested account type.
    func list(for type: AccountListType) -> [AccountItem] {
        switch type {
        case .savings: return savingsList ?? []
        case .fixed: return fixedDepositList ?? []
        case .digital: return digitalList ?? []
        }
    }
}

// MARK: - ViewModel for Home Screen
/// Manages the state, data fetching, and business logic for the Home screen.
///
/// This view model:
/// - Loads banners and preloads images before showing the slider.
/// - Fetches favorite transactions and maps them to display models.
/// - Calculates total balances in USD and KHR across multiple account types.
class HWHomeViewModel: ObservableObject {
    
    // MARK: - Published Properties (UI Binding)
    
    /// List of banner metadata retrieved from API.
    @Published var banners: [BannerList] = []
    
    /// Preloaded banner images for the slider.
    ///
    /// These are fully downloaded before being displayed to avoid delays during sliding.
    @Published var bannerImages: [UIImage] = []

    /// Current index of the banner being displayed in the slider.
    @Published var currentBannerIndex: Int = 0
    
    /// Raw favorite transaction items fetched from API.
    @Published var favoriteItems: [HWFavoriteItem] = []
    
    /// Favorite items mapped to display models containing icons and names.
    @Published var displayItems: [FavoriteDisplayItem] = []
    
    /// Aggregated total balance in USD.
    @Published var totalUSD: Decimal = 0.0
    
    /// Aggregated total balance in KHR.
    @Published var totalKHR: Decimal = 0.0
    
    /// Flag indicating whether to call refresh-specific endpoints.
    @Published var isRefresh: Bool = false
    
    /// Loading state for the favorites section.
    @Published var isLoadingFavorite = false
    
    /// Loading state for the banners section.
    @Published var isLoadingBanners = false
    
    /// Loading state for the account balance section.
    @Published var isLoadingBalance = false
    
    @Published var alertMessage: String?
    
    @Published var isShowingAlert: Bool = false

    /// Stores active Combine subscriptions for cancellation.
    private var cancellables = Set<AnyCancellable>()
    
    /// Indicates if the favorite list is empty.
    var isFavoriteEmpty: Bool {
        return displayItems.isEmpty
    }
    
    @MainActor
    private func showAlert(message: String) {
        self.alertMessage = message
        self.isShowingAlert = true
    }

    // MARK: - Public Methods
    
    /// Fetches the favorite transaction list from the API.
    ///
    /// - Uses `isRefresh` flag to decide which endpoint to call.
    /// - Updates `favoriteItems` and `displayItems` accordingly.
    @MainActor
    func fetchFavoriteList() async {
        self.isLoadingFavorite = true
        defer { self.isLoadingFavorite = false }
        let endpoint = isRefresh ? HWEndpointModel.nonEmptyFavoriteList : HWEndpointModel.emptyFavoriteList
        await self.fetchFavorite(from: endpoint)
    }
    
    /// Fetches all account balances and calculates total amounts in USD and KHR.
    ///
    /// - Uses a `TaskGroup` to run all account type requests in parallel.
    /// - Updates `totalUSD` and `totalKHR` after aggregation.
    @MainActor
    func fetchSumAccountsCurrency() async throws {
        self.isLoadingBalance = true
        defer { self.isLoadingBalance = false }
        
        // Launch all requests in parallel
        async let khrSavings = fetchBalanceResult(endpoint: isRefresh ? .refreshKhrSavings : .khrSavings, listType: .savings)
        async let usdSavings = fetchBalanceResult(endpoint: isRefresh ? .refreshUsdSavings : .usdSavings, listType: .savings)
        async let khrFixedDeposits = fetchBalanceResult(endpoint: isRefresh ? .refreshKhrFixedDeposits : .khrFixedDeposits, listType: .fixed)
        async let usdFixedDeposits = fetchBalanceResult(endpoint: isRefresh ? .refreshUsdFixedDeposits : .usdFixedDeposits, listType: .fixed)
        async let khrDigitalAccounts = fetchBalanceResult(endpoint: isRefresh ? .refreshKhrDigitalAccounts : .khrDigitalAccounts, listType: .digital)
        async let usdDigitalAccounts = fetchBalanceResult(endpoint: isRefresh ? .refreshUsdDigitalAccounts : .usdDigitalAccounts, listType: .digital)
        
        let results = try await [khrSavings, usdSavings, khrFixedDeposits, usdFixedDeposits, khrDigitalAccounts, usdDigitalAccounts]
        
        // Sum totals
        self.totalUSD = results.reduce(0) { $0 + $1.usd }
        self.totalKHR = results.reduce(0) { $0 + $1.khr }
    }
    
    /// Downloads an image from a given URL string.
    ///
    /// - Parameter urlString: The image URL.
    /// - Returns: A `UIImage` if successful, otherwise `nil`.
    private func downloadImage(from url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw URLError(.badServerResponse)
        }
        return image
    }
}

// MARK: - API Requests
extension HWHomeViewModel {

    /// Fetches banner list from API and preloads all images.
    ///
    /// This method ensures that:
    /// 1. All image URLs are retrieved from the API.
    /// 2. Every image is downloaded in parallel before being assigned to `bannerImages`.
    /// 3. The slider is displayed only when all images are ready.
    
    @MainActor
    func fetchBanners() {
        isLoadingBanners = true
        Task { [weak self] in
            guard let self else { return }
            defer { self.isLoadingBanners = false }

            do {
                // If you have an async wrapper, call that instead of Combine:
                let response: HWAPIBaseModel<BannerResult> = try await HWNetworkManager.shared.fetchRequest(endpoint: HWEndpointModel.banners, model: BannerResult.self)

                let urls = response.result.bannerList.compactMap { URL(string: $0.linkURL) }

                let images: [UIImage] = try await withThrowingTaskGroup(of: UIImage?.self) { group in
                    for url in urls {
                        group.addTask { try? await self.downloadImage(from: url) }
                    }

                    var collected: [UIImage] = []
                    for try await img in group {
                        if let img { collected.append(img) }
                    }
                    return collected
                }

                self.bannerImages = images
            } catch {
                self.showAlert(message: "Failed to load banners or images. Please try again.")
                self.bannerImages = []
            }
        }
    }
    
    @MainActor
    func fetchFavorite(from endpoint: HWEndpointModel) async {
        Task { [weak self] in
            guard let self else { return }
            do {
                let response: HWAPIBaseModel<HWFavoriteResult> = try await HWNetworkManager.shared.fetchRequest(
                    endpoint: endpoint,
                    httpMethod: .get,
                    model: HWFavoriteResult.self
                )
                
                self.favoriteItems = response.result.favoriteList
                self.displayItems = response.result.favoriteList.compactMap { item in
                    guard let type = TransType(rawValue: item.transType) else { return nil }
                    return FavoriteDisplayItem(type: type, nickname: item.nickname)
                }
            } catch {
                self.showAlert(message: "Failed to load favorites. Please try again.")
                self.favoriteItems = []
                self.displayItems = []
            }
        }
    }

    private func fetchBalanceResult(
        endpoint: HWEndpointModel,
        listType: AccountListType
    ) async throws -> (usd: Decimal, khr: Decimal) {
        do {
            let response: HWAPIBaseModel<AccountListResult> = try await HWNetworkManager.shared.fetchRequest(
                endpoint: endpoint,
                httpMethod: .get,
                model: AccountListResult.self
            )
            
            var usdSum = Decimal(0)
            var khrSum = Decimal(0)
            let list = response.result.list(for: listType)
            for item in list {
                switch item.curr.uppercased() {
                case "USD": usdSum += Decimal(item.balance)
                case "KHR": khrSum += Decimal(item.balance)
                default: break
                }
            }

            return (usdSum, khrSum)
        } catch {
            await self.showAlert(message: "Failed to load account balance. Please try again.")
            return (0.0, 0.0)
        }
    }

}

