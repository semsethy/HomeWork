//
//  MCAPIErrorModel.swift
//  HomeWork
//
//  Created by Sem Sethy on 12/8/25.
//


import Foundation

/// Defines the API error model for parsing error information in API responses.
/// 定義 API 錯誤模型，用於解析 API 回應中的錯誤資訊。
struct HWAPIErrorModel: Decodable {
    /// Error title.
    /// 錯誤標題。
    var msgTitle: String?
    
    /// Error code.
    /// 錯誤代碼。
    var msgCode: String
    
    /// Error description.
    /// 錯誤敘述。
    var msgContent: String?
    
    /// Number of password errors.
    /// 密碼錯誤次數。
    var errorCount: Int?
    
    /// Field validation errors.
    /// 欄位檢核錯誤。
    var validateError: [String: String]?
    
    /// Displayed error description.
    /// 顯示用錯誤敘述。
    var displayedMsgContent: String {
        return "\(self.msgContent ?? "")(\(self.msgCode))"
    }
}
