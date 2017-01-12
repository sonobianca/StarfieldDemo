//
//  CGPoint+MyExtensions.swift
//  nuts-n-bolts
//
//  Created by Blaise Bernier on 2016-11-24.
//  Copyright © 2016 Badger Studios. All rights reserved.
//

import SpriteKit

extension CGPoint: Hashable {
   
   public static func center() -> CGPoint {
      return CGPoint(x: 0.5, y: 0.5)
   }
   
   func distanceTo(rect: CGRect) -> CGFloat {
      let dx = max(rect.minX - self.x, 0, self.x - rect.maxX)
      let dy = max(rect.minY - self.y, 0, self.y - rect.maxY)
      
      return CGFloat(sqrt(dx*dx + dy*dy))
   }
   
   public var hashValue: Int {
      var seed = UInt(0)
      hash_combine(seed: &seed, value: UInt(bitPattern: x.hashValue))
      hash_combine(seed: &seed, value: UInt(bitPattern: x.hashValue))
      return Int(bitPattern: seed)
   }
}
