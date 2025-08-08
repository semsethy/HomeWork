//
//  HWNotification.swift
//  HomeWork
//
//  Created by JoshipTy on 4/8/25.
//

import Foundation


// MARK: - Result
struct HWNotificationResult: Codable {
    let messages: [HWNotificationMessage]

    enum CodingKeys: String, CodingKey {
        case messages
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.messages = try container.decodeIfPresent([HWNotificationMessage].self, forKey: .messages) ?? []
    }
}


// MARK: - Message
struct HWNotificationMessage: Codable {
    var id: String { title + updateDateTime + message }
    let status: Bool
    let updateDateTime: String
    let title: String
    let message: String
    
}

enum HWNotificationTitle: String, Codable {
    case accountCreated = "Account Created"
    case accountTransaction = "Account transaction"
}

struct HWPushHistoryRequest: Encodable {
 
}

struct HWPushHistoryResponse: Decodable {
    let messages: [HWPushMessage]
}

struct HWPushMessage: Decodable {
    /// 消息ID
    let msgId: String?
    
    /// 消息類型 (T: 交易型，可能後續會擴充其他類型)
    let type: String
    
    /// 消息標題
    let title: String
    
    /// 消息內容
    let content: String
    
    /// 推送日期時間 (Unix timestamp)
    let pushDateTime: Int
    
    // 轉換 時間戳為 Date
    var pushDate: Date {
        return Date(timeIntervalSince1970: Double(self.pushDateTime) / 1000.0)
    }
    
    // 格式化日期時間
    var formattedDateTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return dateFormatter.string(from: self.pushDate)
    }
}

extension HWPushMessage: Identifiable {
    var id: String {
        return UUID().uuidString
    }
}
