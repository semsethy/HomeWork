//
//  HWLog.swift
//  HomeWork
//
//  Created by JoshipTy on 3/8/25.
//

import Foundation
import OSLog

class HWLog {
    
    /// Debug-level log
    /// 調試級別日誌
    class public func debugPrint(_ object: Any) {
        #if DEV
        Logger().debug("\(String(describing: object))")
        #endif
    }
    /// Info-level log
    /// 信息級別日誌
    class public func infoPrint(_ object: Any) {
        #if DEV
        Logger().info("\(String(describing: object))")
        #endif
    }

}
