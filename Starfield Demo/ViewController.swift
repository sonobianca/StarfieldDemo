//
//  ViewController.swift
//  StarFieldDemo
//
//  Created by Blaise Bernier on 2017-01-11.
//  Copyright © 2017 Badger Studios. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {
   
   @IBOutlet var skView: SKView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      if let view = self.skView {
         // Load the SKScene from 'GameScene.sks'
         let scene = GameScene(size: view.frame.size)
         scene.backgroundColor = .black
         // Set the scale mode to scale to fit the window
         scene.scaleMode = .aspectFit
         scene.anchorPoint = CGPoint.center()
         
         // Present the scene
         view.presentScene(scene)
         
         view.ignoresSiblingOrder = true
         
         view.showsFPS = true
         view.showsNodeCount = true
      }
   }
}

