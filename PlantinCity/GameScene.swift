//
//  GameScene.swift
//  PlantinCity
//
//  Created by Z Angrazy Jatt on 2019-12-05.
//  Copyright © 2019 Z Angrazy Jatt. All rights reserved.
//
import Foundation
import SpriteKit
import GameplayKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation

class GameScene: SKScene, CLLocationManagerDelegate {
    
    var airQualityLable : SKLabelNode?
    var dataAirQuality:String?
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
     let API_KEY = "acfc24f10275cfffef7f40e6dd2e9b2ceca6f27a"
    var lati = 28.7041
    var longi = 77.1025
    var activityIndicator: NVActivityIndicatorView!
    let locationManager = CLLocationManager()
//let apiURL = "https://api.waqi.info/feed/geo:28.7041;77.1025/?token=acfc24f10275cfffef7f40e6dd2e9b2ceca6f27a"
    
    private var lastUpdateTime : TimeInterval = 0
    private var spinnyNode : SKShapeNode?
    
    override func sceneDidLoad() {
        self.airQualityLable = self.scene?.childNode(withName: "airqualityLabel") as? SKLabelNode
        print("Hello from game Scene")
    
        self.lastUpdateTime = 0
        
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
        locationManager.requestWhenInUseAuthorization()
        if(CLLocationManager.locationServicesEnabled()){
                   locationManager.delegate = self
                   locationManager.desiredAccuracy = kCLLocationAccuracyBest
                   locationManager.startUpdatingLocation()
               }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lati = location.coordinate.latitude
        longi = location.coordinate.longitude
        Alamofire.request("https://api.waqi.info/feed/geo:28.7041;77.1025/?token=acfc24f10275cfffef7f40e6dd2e9b2ceca6f27a").responseJSON {
            response in
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                let jsonQuality = jsonResponse["data"]
          self.airQualityLable?.text = jsonQuality["aqi"].stringValue
               print("weather data printing")
                
               // let suffix = iconName.suffix(1)
                
            }
        }
        self.locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print(error.localizedDescription)
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
