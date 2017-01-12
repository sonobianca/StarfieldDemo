//
//  CGVector+MyExtensions.swift
//  nuts-n-bolts
//
//  Created by Blaise Bernier on 2016-12-19.
//  Copyright © 2016 Badger Studios. All rights reserved.
//

import CoreGraphics

// MARK: - CGVector Extension

extension CGVector {
   
   public func quadrant() -> myCGQuadrant {
      return myCGQuadrant(vector: self)
   }
   
   public func direction() -> myCGDirection {
      return myCGDirection(vector: self)
   }
   
   public func opposite() -> CGVector {
      return self * -1
   }
   
}

// MARK: - CGFloat signage / signage or 0

enum mySign: CGFloat {
   case minus = -1.0
   case plus = 1.0
   
   init(_ cgfloat: CGFloat) {
      self = cgfloat < 0 ? .minus : .plus
   }
}

enum mySignOrZero: CGFloat {
   case minus = -1.0
   case plus = 1.0
   case zero = 0
   
   init(_ cgfloat: CGFloat) {
      self = cgfloat < 0 ? .minus : cgfloat == 0 ? .zero : .plus
   }
}

// MARK: - Unity circle quadrant

public enum myCGQuadrant: Int {
   case I = 1
   case II = 2
   case III = 3
   case IV = 4
   case none = 0
   
   init (angle: CGFloat) {
      let sineSign = mySign(sin(angle))
      let cosineSign = mySign(cos(angle))
      
      switch (sineSign, cosineSign) {
      case (.plus, .plus):
         self = .I
      case (.plus, .minus):
         self = .II
      case (.minus, .minus):
         self = .III
      case(.minus, .plus):
         self = .IV
      }
   }
   
   init(vector: CGVector) {
      if vector.length() == 0 {
         self = .none
         return
      }
      
      let angle = vector.angle
      let sineSign = mySign(sin(angle))
      let cosineSign = mySign(cos(angle))
      
      switch (sineSign, cosineSign) {
      case (.plus, .plus):
         self = .I
      case (.plus, .minus):
         self = .II
      case (.minus, .minus):
         self = .III
      case(.minus, .plus):
         self = .IV
      }
   }
}

// MARK: - Direction of a vector
// North is top of the screen

public enum myCGDirection: Int {
   case E = 1
   case NE = 2
   case N = 3
   case NW = 4
   case W = 5
   case SW = 6
   case S = 7
   case SE = 8
   case none = 0
   
   init(vector: CGVector) {
      let xSign = mySignOrZero(vector.dx)
      let ySign = mySignOrZero(vector.dy)
      
      switch (xSign, ySign) {
      case (.zero, .zero):
         self = .none
      case(.plus, .zero):
         self = .E
      case (.plus, .plus):
         self = .NE
      case (.zero, .plus):
         self = .N
      case (.minus, .plus):
         self = .NW
      case (.minus, .zero):
         self = .W
      case (.minus, .minus):
         self = .SW
      case (.zero, .minus):
         self = .S
      case (.plus, .minus):
         self = .SE
      }
   }
   
   func opposite() -> myCGDirection {
      if self == .none { return self }
      
      let value = self.rawValue
      
      if value > 4 {
         return myCGDirection(rawValue: value - 4)!
      } else {
         return myCGDirection(rawValue: value + 4)!
      }
   }
}
