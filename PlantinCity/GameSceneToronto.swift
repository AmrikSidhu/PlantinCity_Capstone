//
//  GameSceneToronto.swift
//  PlantinCity
//
//  Created by Z Angrazy Jatt on 2019-12-09.
//  Copyright © 2019 Z Angrazy Jatt. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation

class GameSceneToronto: SKScene, CLLocationManagerDelegate {
    
    var airQualityLable : SKLabelNode?
    var cashLabel : SKLabelNode?
    var torontoLabel: SKLabelNode?
    var dataAirQuality:String?
    var torontoCash = 1000
    var backToToronto:SKSpriteNode!
    var cash:Int = 150
    var treeHight =  180
    var treeWidth = 0
    var airQualityValue:Int = 0
    var treeSelecedIS100=""
    var treeSelecedIS50=""
    var treeSelecedIS3=""
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var addTreeButton:SKSpriteNode!
    var waterMeButton:SKSpriteNode!
    var moveToToronto:SKSpriteNode!
    var touch:UITouch!
    var mouseX:CGFloat! = 100
    var mouseY:CGFloat! = 100
    var tree100:[SKSpriteNode] = []
    var tree50:[SKSpriteNode] = []
    var tree3:[SKSpriteNode] = []
    var count100ActiveToronto = 0
    var count50AvtiveToronto = 0
    var count3ActiveToronto = 0
    var count100 = 1
    var count50 = 1
    var count3 = 1
    var boardLable:SKLabelNode?
    var boardText = "Plant in City"
    var cashInString = ""
    var citySwitch = true
    var apiUrl = ""
    
     let API_KEY = "acfc24f10275cfffef7f40e6dd2e9b2ceca6f27a"
    var lati = 44.0592
    var longi = 79.4613
    var activityIndicator: NVActivityIndicatorView!
    let locationManager = CLLocationManager()
    
    private var lastUpdateTime : TimeInterval = 0
    
    // MARK: scene Did Load **************
    override func sceneDidLoad() {
        
        
        //Setting up the Game Background
        self.backgroundColor = SKColor.black;
        let background = SKSpriteNode(imageNamed: "bgToronto")
        background.size = self.size
        background.position = CGPoint(x: -150, y: -250)
        background.zPosition = -1
        addChild(background)
        
        self.airQualityLable = self.scene?.childNode(withName: "airqualityLabel") as? SKLabelNode
        self.cashLabel = self.scene?.childNode(withName: "cashLabel") as? SKLabelNode
        
        self.torontoLabel = self.scene?.childNode(withName: "torontoLabel") as? SKLabelNode
        self.cashLabel?.text = "Account: $\(self.cash)"
        
        self.boardLable = self.scene?.childNode(withName: "boardLabel") as? SKLabelNode

        self.boardLable?.text = "\(self.boardText)"
        
        
        
        
        self.addTreeButton = SKSpriteNode(imageNamed: "addtree")
        self.addTreeButton.size = CGSize(width: self.size.width/8, height: self.size.height/22)
        self.addTreeButton.position = CGPoint(x: 160, y: 360)
        self.addTreeButton.removeFromParent()
        
        self.waterMeButton = SKSpriteNode(imageNamed: "waterme")
        self.waterMeButton.size = CGSize(width: 150, height: 169)
        self.waterMeButton.position = CGPoint(x: -130, y: -40)
        self.waterMeButton.removeFromParent()
        
        self.backToToronto = SKSpriteNode(imageNamed: "done")
        self.backToToronto.size = CGSize(width: 100, height: 60)
        self.backToToronto.position = CGPoint(x: -135, y: 369)
        addChild(self.backToToronto)
        
        
        
        self.lastUpdateTime = 0
        locationManager.requestWhenInUseAuthorization()
        if(CLLocationManager.locationServicesEnabled()){
                   locationManager.delegate = self
                   locationManager.desiredAccuracy = kCLLocationAccuracyBest
                   locationManager.startUpdatingLocation()
               }
        // planting tree all trees afer selecting
         if let treeSel100 = UserDefaults.standard.string(forKey: "tree100")
         {
            if let cashafter = UserDefaults.standard.string(forKey: "cashafter")
                    {
            print(treeSel100)
            self.treeSelecedIS100 = treeSel100
            self.count100ActiveToronto = self.count100ActiveToronto + 1
        
                        
                        self.cashInString = cashafter
                        self.cash = Int(self.cashInString)!
                        self.cashLabel?.text = "Account: $\(self.cash)"
                        print("Counter_afterBuyingTree100: \(self.cash)")
        }
        }
    
        
        if let treeSel50 = UserDefaults.standard.string(forKey: "tree50")
        {
            if let cashafter = UserDefaults.standard.string(forKey: "cashafter")
            {
            print(treeSel50)
            self.treeSelecedIS50 = treeSel50
            self.count50AvtiveToronto = self.count50AvtiveToronto + 1
                
                self.cashInString = cashafter
                                       self.cash = Int(self.cashInString)!
                                       self.cashLabel?.text = "Account: $\(self.cash)"
                                       print("Counter_afterBuyingTree100: \(self.cash)")
        }
        }
        if let treeSel3 = UserDefaults.standard.string(forKey: "tree3")
        {
            if let cashafter = UserDefaults.standard.string(forKey: "cashafter")
                       {
            print(treeSel3)
            self.treeSelecedIS3 = treeSel3
            self.count3ActiveToronto = self.count3ActiveToronto + 1
                        
                        self.cashInString = cashafter
                        self.cash = Int(self.cashInString)!
                        self.cashLabel?.text = "Account: $\(self.cash)"
                        print("Counter_afterBuyingTree100: \(self.cash)")
        }
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if(self.citySwitch == true)
        {
        lati = 44.0592
            longi = 79.4613
            self.apiUrl = "https://api.waqi.info/feed/geo:\(self.lati);\(self.longi)/?token=acfc24f10275cfffef7f40e6dd2e9b2ceca6f27a"
            
        }
    
        Alamofire.request("\(self.apiUrl)").responseJSON {
            response in
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                let jsonQuality = jsonResponse["data"]
                self.airQualityValue = (jsonQuality["aqi"].int!)
          self.airQualityLable?.text = "Air Pollution: \(jsonQuality["aqi"].stringValue)"
               print("weather data printing")
                print(self.airQualityValue)
                
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

    func spawnTree100()
    {
        
        let newTree100  = SKSpriteNode(imageNamed: "\(self.treeSelecedIS100)")
        newTree100.size = CGSize(width: 100, height: self.treeHight)
        let randomXPos = Int.random(in: -150 ... -100)
        let randomYPos = Int.random(in: -300 ... -280)
        newTree100.position = CGPoint(x: randomXPos, y: randomYPos)
        newTree100.removeFromParent()
        
        self.tree100.append(newTree100)
        
    }
    
//    func spawnTree100watering()
//    {
//
//        let newTree100  = SKSpriteNode(imageNamed: "\(self.treeSelecedIS100)")
//        newTree100.size = CGSize(width: 100, height: self.treeHight)
//        let randomXPos = Int.random(in: -150 ... -100)
//        let randomYPos = Int.random(in: -300 ... -280)
//        newTree100.position = CGPoint(x: randomXPos, y: randomYPos)
//        //addChild(newTree100)
//
//        //self.tree100.append(newTree100)
//
//    }
    
    
    func spawnTree50()
     {
         
         let newTree50  = SKSpriteNode(imageNamed: "\(self.treeSelecedIS50)")
        newTree50.size = CGSize(width: 80, height: 160)
         let randomXPos = Int.random(in: -50 ... 100)
         let randomYPos = Int.random(in: -300 ... -280)
         newTree50.position = CGPoint(x: randomXPos, y: randomYPos)
        newTree50.removeFromParent()
         
         self.tree50.append(newTree50)
         
     }
    
    func spawnTree3()
        {
            
            let newTree3  = SKSpriteNode(imageNamed: "\(self.treeSelecedIS3)")
           newTree3.size = CGSize(width: 50, height: 130)
            let randomXPos = Int.random(in: 130 ... 170)
            let randomYPos = Int.random(in: -300 ... -280)
            newTree3.position = CGPoint(x: randomXPos, y: randomYPos)
            newTree3.removeFromParent()
            
            self.tree50.append(newTree3)
            
        }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }

   
    // MARK: touch begin
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view?.isMultipleTouchEnabled = true
        self.touch = touches.first!
        self.mouseX = touch.location(in: self).x
        self.mouseY = touch.location(in: self).y
        if(self.cash >= 150)
        {
        if (self.addTreeButton.contains(touch.location(in: self))){
            
            if let levelTwoScene = SKScene(fileNamed: "GameSceneAddTreeToronto")
               {
                scene?.scaleMode = .aspectFit
                self.view?.presentScene(levelTwoScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
            self.view?.presentScene(levelTwoScene)
                
                let cashIs = "\(self.cash)"
                UserDefaults.standard.set(cashIs, forKey: "cash")
                
               }
            
        }
            
        }
        else
        {
            self.boardLable?.text = "you don't have enough money yet!"
        }
        
        // MARK: reset button *****************
        
        if (self.waterMeButton.contains(touch.location(in: self))){
            self.treeHight = self.treeHight + 10
            self.cash = self.cash + 50
            print("cashe after watering: \(self.cash)")
            self.cashLabel?.text = "Account: $\(self.cash)"
            self.airQualityValue = self.airQualityValue - 1
            self.airQualityLable?.text = "Air Pollution:\(self.airQualityValue)"
            
            //self.spawnTree100watering()
                   
                   print("waterme Button Clicked!")
                      
                  }
        
        if (self.backToToronto.contains(touch.location(in: self))){
            
            if let levelTwoScene = SKScene(fileNamed: "GameSceneStart")
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
        if(self.count100ActiveToronto == 1)
        {
        if(count100 >= 1)
        {
        self.spawnTree100()
            count100 = count100 - 1
        }
        }
        if(self.count50AvtiveToronto == 1)
        {
        if(count50 >= 1)
               {
               self.spawnTree50()
                   count50 = count50 - 1
               }
        }
        if(self.count3ActiveToronto == 1)
        {
        if(count3 >= 1)
               {
               self.spawnTree3()
                   count3 = count3 - 1
               }
        }
    }
}
