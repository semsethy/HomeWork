//
//  HWBannerResponse.swift
//  HomeWork
//
//  Created by JoshipTy on 4/8/25.
//


import Foundation

// MARK: - Result
struct BannerResult: Codable {
    let bannerList: [BannerList]
}

// MARK: - BannerList
struct BannerList: Codable {
    let adSeqNo: Int
    let linkURL: String

    enum CodingKeys: String, CodingKey {
        case adSeqNo
        case linkURL = "linkUrl"
    }
}


// MARK: - Models
struct AccountItem: Codable {
    let account: String
    let curr: String // USD or KHR
    let balance: Double
}

struct SavingsResult: Codable {
    let savingsList: [AccountItem]
}

struct FixedDepositResult: Codable {
    let fixedDepositList: [AccountItem]
}

struct DigitalAccountResult: Codable {
    let digitalAccountList: [AccountItem]
}



struct DigitalListResult: Decodable {
    let digitalList: [AccountItem]
}
