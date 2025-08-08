//
//  HWAPIBaseModel.swift
//  HomeWork
//
//  Created by JoshipTy on 4/8/25.
//

import Foundation

struct HWAPIBaseModel<T: Decodable>: Decodable {
    let msgCode: String
    let msgContent: String
    let result: T
}

