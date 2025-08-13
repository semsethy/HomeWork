//
//  MCMessageCode.swift
//  HomeWork
//
//  Created by Sem Sethy on 12/8/25.
//


import Foundation

enum HWMessageCode: String, CaseIterable {
    case success = "0000"
    // 強更
    case forceUpdate = "M-1105"
    // 系統維護
    case systemMaintenance = "M-9299"
    // Account lock
    case accountLock = "CPVS-03-0012"
    // Nickname 重複
    case nicknameDuplicate = "CPVS-06-0001"
    // Phone Number 重複
    case phoneNumberDuplicate = "CPVS-06-0002"
    // Pin error
    case pin = "CPVS-06-0003"
    // 帳密錯誤
    case accountFailLogin = "M-2100"
    // 帳密錯誤(非登入)
    case accountFailLoginNotLogin = "M-2106"
    // User不存在
    case userNotExist = "M-0001"
    // 註冊資料取T24不符
    case t24DataMismatch = "M-0102"
    // 高風險
    case highRisk = "M-0103"
    // 該用戶已註冊
    case userAlreadyRegistered = "M-0106"
    // Owner帳號停用 
    case ownerAccountDeactivate = "M-2102"
    // Cashier帳號停用
    case cashierAccountDeactivate = "M-2105"
    // Owner帳號鎖定
    case ownerAccountLock = "M-2108"
    // Cashier帳號鎖定
    case cashierAccountLock = "M-2109"
    // Owner狀態為密碼已鎖定(連續錯誤4次)(登入時)
    case ownerAccountMimaLocked = "M-2103"
    // Cashier狀態為密碼已鎖定(連續錯誤4次)(登入時)
    case cashierAccountMimaLocked = "M-2104"
    // OTP發送次數已達限制
    case otpSendLimitReached = "M-2110"
    // 綁機失敗
    case bindingDeviceFailed = "M-1102"
    // OTP單次錯誤
    case otpSingleError = "OTP-SM15"
    // OTP單次錯誤達上限(目前錯誤次數達上限4次)
    case otpSingleErrorLimit = "OTP-SM25"
    // OTP發送失敗
    case otpServerTimeout = "OTP-SM30"
    // pinWillLocked
    case pinWillLocked = "M-0006"
    // pinFail
    case pinFail = "M-2101"
    // pinLock
    case pinLocked = "M-0007"
    // deep link 失效
    case deepLinkInvalid = "M-1201"
    
    case cashierNotLinkBranch = "M-0104"
    
    case accountLockedByCPVS = "CPVS-0012"
    
    case accountLockedByCPVS1 = "CPVS-0010"
    /// Invalid session.
    case invalidSession = "M-9103"
    
    case deepLinkFailureToCashierRegistration = "M-2107"
    
    case mobileNumberExists = "M-0101"
    
    case nicknameExists = "M-0100"
    
    case notBindDeviceForUser = "M-1104"
}
