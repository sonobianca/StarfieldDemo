//
//  GameScene.swift
//  StarFieldDemo
//
//  Created by Blaise Bernier on 2017-01-11.
//  Copyright © 2017 Badger Studios. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
   
   let starfield = StarfieldNode(rect: CGRect(origin: CGPoint(x: -400, y: -400),
                                              size: CGSize(width: 800,
                                                           height: 800)),
                                 layers: 3,
                                 stars: 200)
   let cameraNode = InteractiveCameraNode()
   
   var lastTime = TimeInterval(0)
   var deltaTime = TimeInterval(0)
   
   override func didMove(to view: SKView) {
      addChild(cameraNode)
      camera = cameraNode
      cameraNode.positionResponders.append(starfield.followCameraPosition)
      cameraNode.addChild(starfield)
      
      //starfield.direction = CGVector(angle: π+(π/3))
      //starfield.velocity = 10
   }
   
   override func update(_ currentTime: TimeInterval) {
      // Called before each frame is rendered
      if lastTime > 0 {
         deltaTime = currentTime - lastTime
      } else {
         deltaTime = 0
      }
      lastTime = currentTime
      
      cameraNode.position += CGVector(angle: -π/5) * 20.0 * CGFloat(deltaTime)
      //starfield.update(deltaTime: deltaTime)
   }
}
