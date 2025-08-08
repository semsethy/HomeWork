//
//  HWFavoriteResponse.swift
//  HomeWork
//
//  Created by JoshipTy on 4/8/25.
//

import Foundation

// MARK: - Result
struct HWFavoriteResult: Codable {
    let favoriteList: [HWFavoriteItem]

    enum CodingKeys: String, CodingKey {
        case favoriteList
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.favoriteList = try container.decodeIfPresent([HWFavoriteItem].self, forKey: .favoriteList) ?? []
    }
}

// MARK: - HWFavoriteItem
struct HWFavoriteItem: Codable {
    let nickname: String
    let transType: String
}

struct FavoriteDisplayItem: Identifiable {
    let id = UUID()
    let type: TransType
    let nickname: String
}
