//
//  HWAccountBalance.swift
//  HomeWork
//
//  Created by JoshipTy on 10/8/25.
//

import Foundation

// MARK: - Models
struct AccountItem: Codable {
    let account: String
    let curr: String // USD or KHR
    let balance: Double
}

//struct SavingsResult: Codable {
//    let savingsList: [AccountItem]
//}
//
//struct FixedDepositResult: Codable {
//    let fixedDepositList: [AccountItem]
//}
//
//struct DigitalAccountResult: Codable {
//    let digitalAccountList: [AccountItem]
//}
//
//struct DigitalListResult: Decodable {
//    let digitalList: [AccountItem]
//}
