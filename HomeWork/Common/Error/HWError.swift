//
//  HWError.swift
//  HomeWork
//
//  Created by JoshipTy on 4/8/25.
//

import Foundation

enum HWError: Error {
    
    case encodingFailed
    
    case decodingFailed(Error)
    
    case serverError
    
    case unknown(Error)
    
}
