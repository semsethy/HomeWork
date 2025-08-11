//
//  HWHomeViewModel.swift
//  HomeWork
//
//  Created by JoshipTy on 2/8/25.
//

import Foundation
import Combine

// MARK: - Transaction Type Enum
/// Represents the types of transactions available in the app.
enum TransType: String, Equatable, Decodable {
    case cubc = "CUBC"
    case mobile = "Mobile"
    case pmf = "PMF"
    case creditCard = "CreditCard"
    
    /// Corresponding icon asset name for each transaction type.
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
/// Defines different types of bank accounts.
enum AccountListType {
    case savings, fixed, digital
}

// MARK: - API Response Model for Account Balances
/// Represents the grouped result of various account lists returned by the API.
struct AccountListResult: Decodable {
    let savingsList: [AccountItem]?
    let fixedDepositList: [AccountItem]?
    let digitalList: [AccountItem]?

    /// Returns the account list based on the requested account type.
    func list(for type: AccountListType) -> [AccountItem] {
        switch type {
        case .savings: return savingsList ?? []
        case .fixed: return fixedDepositList ?? []
        case .digital: return digitalList ?? []
        }
    }
}

// MARK: - ViewModel for Home Screen
/// Manages the state and business logic of the Home screen.
class HWHomeViewModel: ObservableObject {
    
    // MARK: - Published Properties (UI Binding)
    
    /// List of banners shown in the image slider.
    @Published var banners: [BannerList] = []
    
    /// Index of the currently displayed banner.
    @Published var currentBannerIndex: Int = 0
    
    /// Raw favorite items received from API.
    @Published var favoriteItems: [HWFavoriteItem] = []
    
    /// Display model for favorite items (mapped with icons).
    @Published var displayItems: [FavoriteDisplayItem] = []
    
    /// Total amount in USD.
    @Published var totalUSD: Double = 0.0
    
    /// Total amount in KHR.
    @Published var totalKHR: Double = 0.0
    
    /// Flag indicating whether to use refreshed data from API.
    @Published var isRefresh: Bool = false
    
    /// Loading indicators for each section.
    @Published var isLoadingFavorite = true
    @Published var isLoadingBanners = true
    @Published var isLoadingBalance = true

    /// Combine subscriptions storage.
    private var cancellables = Set<AnyCancellable>()
    
    /// Whether the favorite list is empty (used for UI).
    var isFavoriteEmpty: Bool {
        return displayItems.isEmpty
    }

    // MARK: - Public Methods
    /// Fetches the favorite list from API and updates display items.
    @MainActor //ensures that published values are updated on the main thread.
    func fetchFavoriteList() async {
        isLoadingFavorite = true
        let endpoint = isRefresh ? HWEndpointModel.nonEmptyFavoriteList : HWEndpointModel.emptyFavoriteList
        await fetchFavorite(from: endpoint)
    }
    
    /// Fetches and calculates the total balance in USD and KHR across all accounts.
    @MainActor //ensures that published values are updated on the main thread.
    func fetchSumAccountsCurrency() async {
        isLoadingBalance = true

        let endpoints: [(HWEndpointModel, AccountListType)] = [
            (isRefresh ? .refreshKhrSavings : .khrSavings, .savings),
            (isRefresh ? .refreshUsdSavings : .usdSavings, .savings),
            (isRefresh ? .refreshKhrFixedDeposits : .khrFixedDeposits, .fixed),
            (isRefresh ? .refreshUsdFixedDeposits : .usdFixedDeposits, .fixed),
            (isRefresh ? .refreshKhrDigitalAccounts : .khrDigitalAccounts, .digital),
            (isRefresh ? .refreshUsdDigitalAccounts : .usdDigitalAccounts, .digital)
        ]

        var allUSD: Double = 0.0
        var allKHR: Double = 0.0

        // Run all fetches in parallel using TaskGroup
        await withTaskGroup(of: (usd: Double, khr: Double).self) { group in
            for (endpoint, type) in endpoints {
                group.addTask {
                    await self.fetchBalanceResult(endpoint: endpoint, listType: type)
                }
            }

            for await result in group {
                allUSD += result.usd
                allKHR += result.khr
            }
        }

        // Update UI on main thread
        DispatchQueue.main.async {
            self.totalUSD = allUSD
            self.totalKHR = allKHR
        }
    }
}

// MARK: - API Requests
extension HWHomeViewModel {

    /// Fetches banner images for the slider from API.
    @MainActor //ensures that published values are updated on the main thread.
    func fetchBanners() async {
        isLoadingBanners = true

        let publisher = HWNetworkManager.shared.fetchRequest(
            endpoint: HWEndpointModel.banners,
            httpMethod: .get,
            model: BannerResult.self
        )

        let cancellable = publisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Error fetching banners:", error)
                }
            } receiveValue: { [weak self] response in
                self?.banners = response.result.bannerList
            }
        HWNetworkManager.shared.addCancellable(cancellable: cancellable)
    }

    /// Fetches favorite list data and maps to display model.
    func fetchFavorite(from endpoint: HWEndpointModel) async {
        let publisher = HWNetworkManager.shared.fetchRequest(
            endpoint: endpoint,
            httpMethod: .get,
            model: HWFavoriteResult.self
        )

        let cancellable = publisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Error fetching favorites:", error)
                }
            } receiveValue: { [weak self] response in
                self?.favoriteItems = response.result.favoriteList
                self?.displayItems = response.result.favoriteList.compactMap { item in
                    guard let type = TransType(rawValue: item.transType) else { return nil }
                    return FavoriteDisplayItem(type: type, nickname: item.nickname)
                }
            }
        HWNetworkManager.shared.addCancellable(cancellable: cancellable)
    }

    /// Fetches account balances from API and calculates sum in USD and KHR.
    private func fetchBalanceResult(endpoint: HWEndpointModel, listType: AccountListType) async -> (usd: Double, khr: Double) {
        await withCheckedContinuation { continuation in
            let publisher = HWNetworkManager.shared.fetchRequest(
                endpoint: endpoint,
                httpMethod: .get,
                model: AccountListResult.self
            )

            let cancellable = publisher
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print("Error fetching \(endpoint.url):", error)
                        continuation.resume(returning: (0.0, 0.0))
                    }
                } receiveValue: { response in
                    let list = response.result.list(for: listType)
                    let usdSum = list.filter { $0.curr.uppercased() == "USD" }.reduce(0.0) { $0 + $1.balance }
                    let khrSum = list.filter { $0.curr.uppercased() == "KHR" }.reduce(0.0) { $0 + $1.balance }
                    continuation.resume(returning: (usdSum, khrSum))
                }
            HWNetworkManager.shared.addCancellable(cancellable: cancellable)
        }
    }
}
