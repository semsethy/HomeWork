//
//  HWHomeViewModel.swift
//  HomeWork
//
//  Created by JoshipTy on 2/8/25.
//

import Foundation
import Combine

enum TransType: String, Equatable, Decodable {
    
    case cubc = "CUBC"
    case mobile = "Mobile"
    case pmf = "PMF"
    case creditCard = "CreditCard"
    
    var icon: String {
        switch self {
        case .cubc: return "button00ElementScrollTree"
        case .mobile: return "button00ElementScrollMobile"
        case .pmf: return "button00ElementScrollBuilding"
        case .creditCard: return "button00ElementScrollCreditCard"
        }
    }
}

enum AccountListType {
    case savings, fixed, digital
}

struct AccountListResult: Decodable {
    
    let savingsList: [AccountItem]?
    let fixedDepositList: [AccountItem]?
    let digitalList: [AccountItem]?

    func list(for type: AccountListType) -> [AccountItem] {
        switch type {
        case .savings: return savingsList ?? []
        case .fixed: return fixedDepositList ?? []
        case .digital: return digitalList ?? []
        }
    }
}

class HWHomeViewModel: ObservableObject {
    
    @Published var banners: [BannerList] = []
    
    @Published var currentBannerIndex: Int = 0
    
    @Published var favoriteItems: [HWFavoriteItem] = []
    
    @Published var displayItems: [FavoriteDisplayItem] = []
    
    @Published var totalUSD: Double = 0.0
    
    @Published var totalKHR: Double = 0.0
    
    @Published var useRefreshData: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    var isFavoriteEmpty: Bool {
        return displayItems.isEmpty
    }

    // Add loading flags
    @Published var isLoadingFavorite = true
    @Published var isLoadingBanners = true
    @Published var isLoadingBalance = true
    
    // fetch favorite list
    @MainActor
    func fetchFavoriteList() async {
        isLoadingFavorite = true
        let endpoint = useRefreshData ? HWEndpointModel.nonEmptyFavoriteList : HWEndpointModel.emptyFavoriteList
        await fetchFavorite(from: endpoint)
    }
    
    // MARK: - Fetch and Sum All Account Balances
    @MainActor
    func fetchSumAccountsCurrency() async {
        self.isLoadingBalance = true
        let endpoints: [(HWEndpointModel, AccountListType)] = [
            (useRefreshData ? .refreshKhrSavings : .khrSavings, .savings),
            (useRefreshData ? .refreshUsdSavings : .usdSavings, .savings),
            (useRefreshData ? .refreshKhrFixedDeposits : .khrFixedDeposits, .fixed),
            (useRefreshData ? .refreshUsdFixedDeposits : .usdFixedDeposits, .fixed),
            (useRefreshData ? .refreshKhrDigitalAccounts : .khrDigitalAccounts, .digital),
            (useRefreshData ? .refreshUsdDigitalAccounts : .usdDigitalAccounts, .digital)
        ]

        var allUSD: Double = 0.0
        var allKHR: Double = 0.0

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

        DispatchQueue.main.async {
            self.totalUSD = allUSD
            self.totalKHR = allKHR
        }
    }
    
}

//MARK: - API
extension HWHomeViewModel {
    // MARK: - Fetch Banners
    @MainActor
    func fetchBanners() async {
        self.isLoadingBanners = true
        HWNetworkManager.shared.fetchRequest(
            endpoint: HWEndpointModel.banners,
            httpMethod: .get,
            model: BannerResult.self
        )
        .receive(on: DispatchQueue.main)
        .sink { completion in
            if case .failure(let error) = completion {
                print("Error fetching banners:", error)
            }
        } receiveValue: { response in
            self.banners = response.result.bannerList
        }
        .store(in: &cancellables)
    }

    func fetchFavorite(from endpoint: HWEndpointModel) async {
        HWNetworkManager.shared.fetchRequest(
            endpoint: endpoint,
            httpMethod: .get,
            model: HWFavoriteResult.self
        )
        .receive(on: DispatchQueue.main)
        .sink { completion in
            if case .failure(let error) = completion {
                print("Error fetching favorites:", error)
            }
        } receiveValue: { response in
            self.favoriteItems = response.result.favoriteList
            self.displayItems = response.result.favoriteList.compactMap { item in
                guard let type = TransType(rawValue: item.transType) else { return nil }
                return FavoriteDisplayItem(type: type, nickname: item.nickname)
            }
        }
        .store(in: &cancellables)
    }

    private func fetchBalanceResult(endpoint: HWEndpointModel, listType: AccountListType) async -> (usd: Double, khr: Double) {
        await withCheckedContinuation { continuation in
            HWNetworkManager.shared.fetchRequest(
                endpoint: endpoint,
                httpMethod: .get,
                model: AccountListResult.self
            )
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
            .store(in: &self.cancellables)
        }
    }
}
