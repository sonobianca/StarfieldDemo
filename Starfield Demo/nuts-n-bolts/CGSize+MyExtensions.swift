//
//  CGSize+MyExtensions.swift
//  nuts-n-bolts
//
//  Created by Blaise Bernier on 2016-12-14.
//  Copyright © 2016 Badger Studios. All rights reserved.
//

import SpriteKit

extension CGSize {
   init(square: CGFloat) {
      self.width = square
      self.height = square
   }
}
