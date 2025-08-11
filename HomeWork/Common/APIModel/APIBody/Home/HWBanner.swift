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

