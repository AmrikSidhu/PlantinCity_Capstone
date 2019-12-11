//
//  GameSceneStart.swift
//  PlantinCity
//
//  Created by Z Angrazy Jatt on 2019-12-07.
//  Copyright © 2019 Z Angrazy Jatt. All rights reserved.
//

import UIKit
import Foundation
import SpriteKit
import GameplayKit

class GameSceneStart: SKScene {
    
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var StrartGmaeButton:SKSpriteNode!
    var startGamenow:String = ""
    var arrowTouched:String = ""
    var touch:UITouch!
    var mouseX:CGFloat! = 100
     var mouseY:CGFloat! = 100
    var arrowButtonTouched = false
      var arrowButtonsRect:CGRect!
    
    private var lastUpdateTime : TimeInterval = 0
    
    override func sceneDidLoad() {
        
        //Setting up the Game Background
        self.backgroundColor = SKColor.black;
        let background = SKSpriteNode(imageNamed: "bgwelcome")
        background.size = self.size
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -1
        addChild(background)
        
         // MARK: ADDING BUTTONS ************************
        
    self.StrartGmaeButton = SKSpriteNode(imageNamed: "startbutton")
    self.StrartGmaeButton.size = CGSize(width: self.size.width/3, height: self.size.height/10)
    self.StrartGmaeButton.position = CGPoint(x: 10, y: 0)
    addChild(self.StrartGmaeButton)
        
        
        
    self.lastUpdateTime = 0
        
       
        // MARK: DIDLOAD PRINTS ************************
        
        print("screen: \(self.size.width), \(self.size.height)")
        print("Hello from game Scene")
        
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
        
        if (self.StrartGmaeButton.contains(touch.location(in: self))){
            
            if let levelTwoScene = SKScene(fileNamed: "GameSceneAddTree")
               {
                scene?.scaleMode = .aspectFit
                self.view?.presentScene(levelTwoScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
            self.view?.presentScene(levelTwoScene)
                
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
