//
//  InteractiveCameraNode.swift
//
//  Created by Blaise Bernier on 2016-12-20.
//  Copyright © 2016 Badger Studios. All rights reserved.
//
//  USAGE:
//  let interactiveCamera = InteractiveCameraNode()
//  myScene.camera = interactiveCamera
//  interactiveCamera.positionResponders.append(SomeClosure) // Has to be a "(oldValue: CGPoint, newValue: CGPoint) -> Void" closure
//
//  That's all: as soon as the camera moves, the responder closure will be called.  You can set "enableInteraction" to false
//  to turn off the interaction without deassigning the closures.

import SpriteKit

/**
 Interactive Camera Node for SpriteKit
 
 **UNDER DEVELOPEMENT**
 
 Offers more interaction with the camera node.  Adds responder collections for the following properties changes:
 - `position`
*/

class InteractiveCameraNode: SKCameraNode {
   // MARK: - Properties
   var enableInteraction = true
   var positionResponders = [(CGPoint, CGPoint) -> Void]()
   

   /// Calls every closure in the `positionResponders` array
   override var position: CGPoint {
      didSet {
         if enableInteraction {
            for responder in positionResponders {
               responder(oldValue, position)
            }
         }
      }
   }
}
