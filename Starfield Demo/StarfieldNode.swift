//
//  StarfieldNode.swift
//
//  Created by Blaise Bernier on 2016-12-15.
//  Copyright © 2016 Badger Studios. All rights reserved.
//
//  MADE TO WORK WITH InteractiveCameraNode.swift
//

import SpriteKit
import GameplayKit


/** A node to generate a scrolling starfield effect

 - Requires:
   - SKTUtils from Ray Wenderlich (http://github.com/raywenderlich/SKTUtils)
   - 'nuts-n-bolts' from Blaise Bernier (http://github.com/sonoblaise/nuts-n-bolts)
 
 # Usage:
 ## Creation :
 
         let starfield = StarfieldNode(rect: CGRect(x: 0, y: 0, width: 100, height: 100), layers: 4,stars: 150)
 
   *OR* something like
 
         let starArray = [sfStarNode(color: .white, size: CGSize(width: 1, height: 1)),
                          sfStarNode(color: .red, size: CGSize(width: 1, height: 1)),
                          sfStarNode(color: .lightGray, size: CGSize(width: 1, height: 1))]
 
         let starfield = StarfieldNode(rect: CGRect(x: 0, y: 0, width: 100, height: 100),
                                       layers: 4,
                                       stars: 150,
                                       models: starArray)
 
 ## Manual movement :
 
         starfield.direction = CGVector(angle: valueInRadians)
         starfield.velocity = CGFloat(6.0)
 
   *THEN* inside your scene's update() function
 
         starfield.update(deltaTime: deltaTimeInterval)
 
   Your only obligation is to provide the deltaTime yourself.
 
 ## Synchronize with InteractiveCameraNode
 
   StarfieldNode is built with an integrated responder function that works hand in hand with the InteractiveCameraNode
   class.  To add camera interaction you only need to add that function to the camera's responder array:
 
         interactiveCamera.positionResponders.append(followCameraPosition)
 
   Make sure you **DO NOT** call the update(deltaTime) function when using this feature.  This will definitely result in
   weird unexpected behavior.
 
   You can use the *cameraRatio* property to adjust the scrolling speed of the starfield when it is driven by the camera
 */
class StarfieldNode: SKNode {
   // Private declaration
   private var starfieldExtents: CGRect
   private let layers: Int
   private let maximumStars: Int
   
   /// Holds all the different models for the stars
   private var models = [sfStarNode]()
   
   /// Holds all the actual stars
   private var stars = [sfStarNode]()
   
   // Properties
   var direction = CGVector.zero
   var velocity = CGFloat(0.0)
   var cameraRatio = CGFloat(10.0)
   
   // MARK: - init()...
   
   /** Starfield initializer
    
    - Parameters:
      - rect: Area to be covered with a starfield, relative to the node's position
      - layers: Number of layers of stars to populate
      - stars: Number of stars to generate
    
      - models: *optional* Array of sfStarNodes that will be picked from when generating the starfield.
                           If ommited, a default array made of untextured nodes will be provided.
    
   */
   init(rect: CGRect, layers: Int, stars: Int, models: [sfStarNode]? = nil) {
      
      self.starfieldExtents = rect
      self.layers = layers
      self.maximumStars = stars
      
      if let models = models {
         self.models = models
      } else {
         // Create a default array of star models here
         self.models.append(sfStarNode(color: .white, size: CGSize(width: 1, height: 1)))
         self.models.append(sfStarNode(color: .white, size: CGSize(width: 1.5, height: 1.5)))
         self.models.append(sfStarNode(color: .cyan, size: CGSize(width: 2, height: 2)))
         self.models.append(sfStarNode(color: .lightGray, size: CGSize(width: 1, height: 1)))
         self.models.append(sfStarNode(color: .red,size: CGSize(width: 1, height: 1)))
      }
      super.init()
      
      generateStars()
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   /// Generates the starfield with a GKRandomSource
   func generateStars() {
      let randomStars = GKRandomSource()
      
      for _ in 0...maximumStars {
         let newX = (CGFloat(randomStars.nextUniform()) * starfieldExtents.width) + starfieldExtents.minX
         let newY = (CGFloat(randomStars.nextUniform()) * starfieldExtents.height) + starfieldExtents.minY
         let newPoint = CGPoint(x: newX, y: newY)
         let model = randomStars.nextInt(upperBound: models.count)
         let newLayer = randomStars.nextInt(upperBound: layers) + 1
         let newZPosition = newLayer
         let newAlpha = CGFloat(layers - newLayer) / CGFloat(layers)
         
         let newStar = models[model].copy() as! sfStarNode
         newStar.position = newPoint
         newStar.layer = newLayer
         newStar.zPosition = CGFloat(newZPosition)
         newStar.alpha = (newAlpha / 2.0) + 0.5
         self.stars.append(newStar)
         self.addChild(newStar)
      }
   }
   
   /** 
    Move the stars and check if they are out of bound.  If they are, check if they are
    moving away from the starfield boundaries.  If they are, move them to the other side of the rect.
    
    - Parameters:
      - deltaTime: Interval between calls
   */
   func update(deltaTime: TimeInterval) {
      let vector = direction * velocity
      
      for star in stars {
         let lastPosition = star.position
         star.moveStar(by: vector, deltaTime: CGFloat(deltaTime))
         if !starfieldExtents.contains(star.position) {
            let oldDistance = lastPosition.distanceTo(rect: starfieldExtents)
            let newDistance = star.position.distanceTo(rect: starfieldExtents)
            if newDistance > oldDistance {
               star.position *= -1
            }
         }
      }
   }
   
   /**
    The function that will be added as a responder closure in the InteractiveCameraNode
    
    - Parameters:
      - oldValue: Camera's position before the movement
      - newValue: Camera's current position
   */
   func followCameraPosition(oldValue: CGPoint, newValue: CGPoint) {
      let vector = CGVector(point: oldValue - newValue) * cameraRatio
      
      for star in stars {
         let lastPosition = star.position
         star.moveStar(by: vector, deltaTime: nil)
         
         if !starfieldExtents.contains(star.position) {
            let oldDistance = lastPosition.distanceTo(rect: starfieldExtents)
            let newDistance = star.position.distanceTo(rect: starfieldExtents)
            if newDistance > oldDistance {
               star.position *= -1
            }
         }
      }
   }
}

/**
 Star nodes generated by the starfield
 
 Use this class to create your model sprites for the starfield
*/
class sfStarNode: SKSpriteNode {
   
   var layer = 1
   
   /// Move the star according to a movement vector (angle+velocity) and a deltaTime
   func moveStar(by vector: CGVector, deltaTime: CGFloat?) {
      if vector.length() == 0 { return }
      
      var moveBy = vector * (1.0 / CGFloat(layer))
      if let dt = deltaTime {
         moveBy *= dt
      }
      
      self.position += moveBy
   }
}
