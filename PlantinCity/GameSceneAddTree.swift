//
//  GameSceneAddTree.swift
//  PlantinCity
//
//  Created by Z Angrazy Jatt on 2019-12-07.
//  Copyright © 2019 Z Angrazy Jatt. All rights reserved.
//
import UIKit
import Foundation
import SpriteKit
import GameplayKit

class GameSceneAddTree: SKScene {
        
        
        var entities = [GKEntity]()
        var graphs = [String : GKGraph]()
        
        var backtoMain:SKSpriteNode!
    var tree100:SKSpriteNode!
     var tree50:SKSpriteNode!
    var tree3:SKSpriteNode!
        var touch:UITouch!
        var mouseX:CGFloat! = 100
         var mouseY:CGFloat! = 100
          var arrowButtonsRect:CGRect!
    var cashMoney = ""
    var intCash = 0
    var cashafeter = 0
        
        private var lastUpdateTime : TimeInterval = 0
        
        override func sceneDidLoad() {
            
             // MARK: ADDING BUTTONS and Trees ************************
            
        self.backtoMain = SKSpriteNode(imageNamed: "backtomain")
        self.backtoMain.size = CGSize(width: 60, height: 60)
        self.backtoMain.position = CGPoint(x: -135, y: 369)
        addChild(self.backtoMain)
            
          // 100% (tree)
        self.tree100 = SKSpriteNode(imageNamed: "hundredpercent")
        self.tree100.size = CGSize(width: 100, height: 210)
        self.tree100.position = CGPoint(x: -110, y: 120)
        addChild(self.tree100)
            
        // 50% (tree)
               self.tree50 = SKSpriteNode(imageNamed: "fiftypercent")
               self.tree50.size = CGSize(width: 70, height: 150)
               self.tree50.position = CGPoint(x: 30, y:100)
               addChild(self.tree50)
            
            // 3% (tree)
            self.tree3 = SKSpriteNode(imageNamed: "threepercent")
            self.tree3.size = CGSize(width: 50, height: 100)
            self.tree3.position = CGPoint(x: 140, y:80)
            addChild(self.tree3)
            
            
            
        self.lastUpdateTime = 0
            
           
            // MARK: DIDLOAD PRINTS ************************
            
            print("screen: \(self.size.width), \(self.size.height)")
            print("Hello from game Scene")
            
            
            if let cashfromuser = UserDefaults.standard.string(forKey: "cash")
             {
                self.cashMoney = cashfromuser
                print("Cash recieved: \(cashfromuser)")
                self.intCash = Int(self.cashMoney)!
            }
            
        }
        
        
        
        
        func touchDown(atPoint pos : CGPoint) {
            
        }
        
        func touchMoved(toPoint pos : CGPoint) {
            
           
        }
        
        func touchUp(atPoint pos : CGPoint) {
            
        }
        
        //MARK: BUTTONS ****************************


        
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            
            self.view?.isMultipleTouchEnabled = true
            self.touch = touches.first!
            self.mouseX = touch.location(in: self).x
            self.mouseY = touch.location(in: self).y
            
            if (self.backtoMain.contains(touch.location(in: self))){
                
                if let levelTwoScene = SKScene(fileNamed: "GameSceneMain")
                   {
                    scene?.scaleMode = .aspectFit
                    self.view?.presentScene(levelTwoScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
                self.view?.presentScene(levelTwoScene)
                    
                   }
                
            }

            
            if (self.tree100.contains(touch.location(in: self))){
                
                
                    self.cashafeter = self.intCash - 100
                           
                           if let levelTwoScene = SKScene(fileNamed: "GameSceneMain")
                              {
                               scene?.scaleMode = .aspectFit
                               self.view?.presentScene(levelTwoScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
                           self.view?.presentScene(levelTwoScene)
                            let treeSelected = "hundredpercent"
                            UserDefaults.standard.set(treeSelected, forKey: "tree100")
                                let reset = "1"
                                UserDefaults.standard.set(reset, forKey: "reset")
                                
                                let cashAf = "\(self.cashafeter)"
                                UserDefaults.standard.set(cashAf, forKey: "cashafter")
                                
                              }
                
                           
                       }
            
            if (self.tree50.contains(touch.location(in: self))){
                
                self.cashafeter = self.intCash - 50
                
                if let levelTwoScene = SKScene(fileNamed: "GameSceneMain")
                   {
                    scene?.scaleMode = .aspectFit
                    self.view?.presentScene(levelTwoScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
                self.view?.presentScene(levelTwoScene)
                 let treeSelected = "fiftypercent"
                 UserDefaults.standard.set(treeSelected, forKey: "tree50")
                    let reset = "1"
                    UserDefaults.standard.set(reset, forKey: "reset")
                    let cashAf = "\(self.cashafeter)"
                                                   UserDefaults.standard.set(cashAf, forKey: "cashafter")
                    
                   }
                
            }
            if (self.tree3.contains(touch.location(in: self))){
                
                self.cashafeter = self.intCash - 20
                           
                           if let levelTwoScene = SKScene(fileNamed: "GameSceneMain")
                              {
                               scene?.scaleMode = .aspectFit
                               self.view?.presentScene(levelTwoScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
                           self.view?.presentScene(levelTwoScene)
                            let treeSelected = "threepercent"
                            UserDefaults.standard.set(treeSelected, forKey: "tree3")
                                let reset = "1"
                                UserDefaults.standard.set(reset, forKey: "reset")
                                let cashAf = "\(self.cashafeter)"
                                                               UserDefaults.standard.set(cashAf, forKey: "cashafter")
                               
                              }
                           
                       }
            
            guard let mousePosition = touches.first?.location(in: self) else {
                return
            }
            print(mousePosition)
            
        }
        
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        }
        
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            
        }
        
        
        override func update(_ currentTime: TimeInterval) {
            // Initialize _lastUpdateTime if it has not already been
            if (self.lastUpdateTime == 0) {
                self.lastUpdateTime = currentTime
            }
            
            // Calculate time since last update
            let dt = currentTime - self.lastUpdateTime
            
            // Update entities
            for entity in self.entities {
                entity.update(deltaTime: dt)
            }
            
            self.lastUpdateTime = currentTime
        }
        
    }
