//
//  GameScene.swift
//  PlantinCity
//
//  Created by Z Angrazy Jatt on 2019-12-05.
//  Copyright © 2019 Z Angrazy Jatt. All rights reserved.
//

import SpriteKit
import GameplayKit
import Firebase

class GameScene: SKScene {
    
    var airQualityLable : SKLabelNode?
    var dataAirQuality:String?
    var ref = DatabaseReference()
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
     let API_KEY = "acfc24f10275cfffef7f40e6dd2e9b2ceca6f27a"
    let apiURL = "https://api.waqi.info/map/bounds/?latlng=39.379436,116.091230,40.235643,116.784382&token=acfc24f10275cfffef7f40e6dd2e9b2ceca6f27a"
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func sceneDidLoad() {
        self.airQualityLable = self.scene?.childNode(withName: "airqualityLabel") as? SKLabelNode
        print("Hello from game Scene")
        ref = Database.database().reference()
        //self.ref.child("airquality").childByAutoId().setValue(6623)
        self.ref.child("airquality/airquality").setValue(6623000)
        self.lastUpdateTime = 0
        // adding Air Poluton Label
        
        ref = Database.database().reference().child("airquality")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let snap = snapshot.value as? [String : AnyObject] {
               if let result = snap["airquality"] as? String {
                self.airQualityLable = self.scene?.childNode(withName: "airqualityLabel") as? SKLabelNode
                //self.dataAirQuality = result
                self.airQualityLable?.text = result
                
               }
                else{
                    self.airQualityLable?.text = "something went wrong"
                }
               }
            
            })
//        self.airQualityLable = self.scene?.childNode(withName: "airqualityLabel") as? SKLabelNode
        //self.airQualityLable?.text = self.dataAirQuality
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
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
    
    func getAirQuality()  {
        // to do
    }
}
