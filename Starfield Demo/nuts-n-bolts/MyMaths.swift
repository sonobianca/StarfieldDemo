//
//  MyMaths.swift
//  nuts-n-bolts
//
//  Created by Blaise Bernier on 2016-12-21.
//  Copyright © 2016 Badger Studios. All rights reserved.
//

import Foundation

func hash_combine(seed: inout UInt, value: UInt) {
   let tmp = value &+ 0x9e3779b9 &+ (seed << 6) &+ (seed >> 2)
   seed ^= tmp
}
