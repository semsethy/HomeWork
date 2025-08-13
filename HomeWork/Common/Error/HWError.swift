//
//  HWError.swift
//  HomeWork
//
//  Created by JoshipTy on 4/8/25.
//

import Foundation

/// Defines the MCError enum for handling various error types.
/// 定義 MCError 列舉，用於處理各種錯誤類型。
enum HWError: Error {
    
    /// Defines reasons for permission errors.
    /// 定義權限錯誤的原因。
    enum HWPermissionErrorReason {
        /// User canceled the operation.
        /// 使用者自己取消。
        case userCancel
        /// System canceled the operation (including system lock).
        /// 系統取消(含系統鎖住)。
        case systemCancel
        /// Other failure occurred.
        /// 其他狀況發生。
        case otherFail
        /// Operation not supported.
        /// 不支援。
        case notSupported
    }
    
    /// Defines reasons for network connection errors.
    /// 定義網路連線錯誤的原因。
    enum HWNetworkConnectionErrorReason {
        /// No internet connection.
        /// 無連線。
        case notConnectedToInternet
        /// Connection timed out.
        /// 連線逾時。
        case timedOut
        /// Other error occurred.
        /// 其他錯誤發生。
        case other(error : Error)
        /// HTTP error code.
        /// HTTP 錯誤代碼。
        case httpCode(code: String)
        /// SSL pinning failed.
        /// SSL Pinning 驗證失敗。
        case sslPinningFail
    }
    
    /// Defines reasons for network decoding errors.
    /// 定義網路解碼錯誤的原因。
    enum HWNetworkDecodeErrorReason {
        /// Decoding failed.
        /// 解碼失敗。
        case decode(error : Error)
        /// Failed to convert to UTF-8.
        /// 無法轉換為 UTF-8。
        case toUTF8Fail
        /// The private key does not support RSA decryption with OAEP SHA-256.
        /// 私鑰不支援使用 OAEP SHA-256 進行 RSA 解密。
        case privateKeyNotSupportRSA
        /// Data is empty.
        /// 資料為空。
        case emptyData
        /// AES key length is invalid.
        /// AES 密鑰長度無效。
        case aesKeyLength
        /// AES decryption failed.
        /// AES 解密失敗。
        case aesDecryptFail
        /// Invalid nonce.
        /// 無效的 Nonce。
        case invalidNonce
        
        /// Returns the description for the decoding error.
        /// 返回解碼錯誤的描述。
        var description: String {
            switch self {
            case .decode(_):
                return "(A-3001)"
            case .toUTF8Fail:
                return "(A-9997)"
            case .privateKeyNotSupportRSA:
                return "(A-9997)"
            case .emptyData:
                return "(A-9997)"
            case .aesKeyLength:
                return "(A-9997)"
            case .aesDecryptFail:
                return "(A-9997)"
            case .invalidNonce:
                return "(A-9997)"
            }
        }
    }
    
    /// Defines reasons for network encoding errors.
    /// 定義網路編碼錯誤的原因。
    enum HWNetworkEncodeErrorReason {
        /// Encoding failed.
        /// 編碼失敗。
        case encode(error : Error)
        /// Failed to convert to UTF-8.
        /// 無法轉換為 UTF-8。
        case toUTF8Fail
    }
    
    /// An error occurred while constructing a request.
    /// 構建請求時發生錯誤。
    case permissionFailed(reason: HWPermissionErrorReason)
    
    /// Network connection failed.
    /// 網路連線失敗。
    case networkConnectionFailed(reason: HWNetworkConnectionErrorReason)
    
    /// Network decoding failed.
    /// 網路解碼失敗。
    case networkDecodeFailed(reason: HWNetworkDecodeErrorReason)
    
    /// Network encoding failed.
    /// 網路編碼失敗。
    case networkEncodeFailed(reason: HWNetworkEncodeErrorReason)
    
    /// Decoding error model.
    /// 解碼錯誤模型。
    case deCodeErrorModel(model: HWAPIErrorModel)
    
    /// Session timed out.
    /// 會話逾時。
    case sessionTimeOut(model: HWAPIErrorModel)
    
    /// System maintenance announcement.
    /// 系統維護公告。
    case systemMaintenance(model: HWAPIErrorModel)
}

extension HWError {
    
    /// Validates whether the error is valid.
    /// 驗證錯誤是否有效。
    func isValidateError() -> Bool {
        switch self {
        case .permissionFailed:
            return false
        case .networkConnectionFailed:
            return false
        case .networkDecodeFailed:
            return false
        case .deCodeErrorModel(model: let model):
            return model.msgCode == "M-9908" && model.validateError != nil
        case .networkEncodeFailed:
            return false
        case .sessionTimeOut:
            return false
        case .systemMaintenance:
            return false
        }
    }
    
    /// Retrieves validation error details.
    /// 獲取驗證錯誤的詳細信息。
    func getValidateError()-> [String: String] {
        switch self {
        case .deCodeErrorModel(model: let model):
            return model.validateError ?? [:]
        default:
            break
        }
        return [:]
    }
}
