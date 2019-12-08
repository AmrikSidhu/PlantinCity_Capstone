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
    var cashLabel : SKLabelNode?
    var dataAirQuality:String?
    var cash:Int = 100
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var addTreeButton:SKSpriteNode!
    var touch:UITouch!
       var mouseX:CGFloat! = 100
       var mouseY:CGFloat! = 100
    
     let API_KEY = "acfc24f10275cfffef7f40e6dd2e9b2ceca6f27a"
    var lati = 28.7041
    var longi = 77.1025
    var activityIndicator: NVActivityIndicatorView!
    let locationManager = CLLocationManager()
//let apiURL = "https://api.waqi.info/feed/geo:28.7041;77.1025/?token=acfc24f10275cfffef7f40e6dd2e9b2ceca6f27a"
    
    private var lastUpdateTime : TimeInterval = 0
    
    // MARK: scene Did Load **************
    override func sceneDidLoad() {
        
        
        self.airQualityLable = self.scene?.childNode(withName: "airqualityLabel") as? SKLabelNode
        self.cashLabel = self.scene?.childNode(withName: "cashLabel") as? SKLabelNode
        print("Hello from game Scene")
        self.cashLabel?.text = "$\(self.cash)"
        
        self.addTreeButton = SKSpriteNode(imageNamed: "addtree")
        self.addTreeButton.size = CGSize(width: self.size.width/8, height: self.size.height/22)
        self.addTreeButton.position = CGPoint(x: 160, y: 360)
        addChild(self.addTreeButton)
        
        
        
        self.lastUpdateTime = 0
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
          self.airQualityLable?.text = "Delhi: \(jsonQuality["aqi"].stringValue)"
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
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    // MARK: buttons
   
    // MARK: touch begin
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view?.isMultipleTouchEnabled = true
        self.touch = touches.first!
        self.mouseX = touch.location(in: self).x
        self.mouseY = touch.location(in: self).y
        
        if (self.addTreeButton.contains(touch.location(in: self))){
            
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
}
