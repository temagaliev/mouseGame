//
//  BitMaskCategory.swift
//  Mouse racing
//
//  Created by Артем Галиев on 15.02.2020.
//  Copyright © 2020 Артем Галиев. All rights reserved.
//

import Foundation

struct BitMaskCategory {
    static let none: UInt32 = 0x0 << 0
    static let mouseCategory: UInt32 = 0x1 << 0
    static let trapCategory: UInt32 = 0x1 << 1
    static let cheeseCategory: UInt32 = 0x1 << 2
}
