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
    var torontoLabel: SKLabelNode?
    var dataAirQuality:String?
    var torontoCash = 1000
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
    var waterMeButton1:SKSpriteNode!
    var waterMeButton2:SKSpriteNode!
    var waterMeButton3:SKSpriteNode!
    var moveToToronto:SKSpriteNode!
    var touch:UITouch!
    var mouseX:CGFloat! = 100
    var mouseY:CGFloat! = 100
    var tree100:[SKSpriteNode] = []
    var tree50:[SKSpriteNode] = []
    var tree3:[SKSpriteNode] = []
    var count100Active = 0
    var count50Avtive = 0
    var count3Active = 0
    var count100 = 1
    var count50 = 1
    var count3 = 1
    var boardLable:SKLabelNode?
    var boardText = "Plant in City"
    var cashInString = ""
    var citySwitch = false
    var apiUrl = ""
    var newTree100:SKSpriteNode!
    var newTree50:SKSpriteNode!
    var newTree3:SKSpriteNode!
    var SecondsRemaining = 60
    var updateCount = 0
    var TimeLabel:SKLabelNode!
    var minutes = 0
    var day = 1
    var dayLabel:SKLabelNode!
    var airSwichafter10Second = 0
    
    var waterImageName = "waterme"
    
    
     let API_KEY = "acfc24f10275cfffef7f40e6dd2e9b2ceca6f27a"
    var lati = 28.7041
    var longi = 77.1025
    var activityIndicator: NVActivityIndicatorView!
    let locationManager = CLLocationManager()
    
    private var lastUpdateTime : TimeInterval = 0
    
    // MARK: scene Did Load **************
    override func sceneDidLoad() {
        
        
        //Setting up the Game Background
        self.backgroundColor = SKColor.black;
        let background = SKSpriteNode(imageNamed: "bg")
        background.size = self.size
        background.position = CGPoint(x: -150, y: -250)
        background.zPosition = -1
        addChild(background)
        
        self.airQualityLable = self.scene?.childNode(withName: "airqualityLabel") as? SKLabelNode
        self.cashLabel = self.scene?.childNode(withName: "cashLabel") as? SKLabelNode
        
        self.torontoLabel = self.scene?.childNode(withName: "torontoLabel") as? SKLabelNode
        self.TimeLabel = self.scene?.childNode(withName: "timeLabel") as? SKLabelNode
        self.dayLabel = self.scene?.childNode(withName: "dayLabel") as? SKLabelNode
        
        self.cashLabel?.text = "Account: $\(self.cash)"
        
        self.boardLable = self.scene?.childNode(withName: "boardLabel") as? SKLabelNode

        self.boardLable?.text = "\(self.boardText)"
        
        
        
        
        self.addTreeButton = SKSpriteNode(imageNamed: "addtree")
        self.addTreeButton.size = CGSize(width: self.size.width/8, height: self.size.height/22)
        self.addTreeButton.position = CGPoint(x: 160, y: 360)
        addChild(self.addTreeButton)
        
        self.moveToToronto = SKSpriteNode(imageNamed: "toronto")
        self.moveToToronto.size = CGSize(width:200, height: 99)
        self.moveToToronto.position = CGPoint(x: -160, y: 360)
        addChild(self.moveToToronto)
        
        //MARK: watering buttons
        
        self.waterMeButton1 = SKSpriteNode(imageNamed: self.waterImageName)
        self.waterMeButton1.size = CGSize(width: 50, height: 54)
        self.waterMeButton1.position = CGPoint(x: -140, y: -410)
        addChild(self.waterMeButton1)
        
        self.waterMeButton2 = SKSpriteNode(imageNamed: self.waterImageName)
        self.waterMeButton2.size = CGSize(width: 50, height: 54)
        self.waterMeButton2.position = CGPoint(x: 10, y: -410)
        addChild(self.waterMeButton2)
        
        self.waterMeButton3 = SKSpriteNode(imageNamed: self.waterImageName)
        self.waterMeButton3.size = CGSize(width: 50, height: 54)
        self.waterMeButton3.position = CGPoint(x: 150, y: -410)
        addChild(self.waterMeButton3)
        
        
        
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
            self.count100Active = self.count100Active + 1
        
                        
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
            self.count50Avtive = self.count50Avtive + 1
                
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
            self.count3Active = self.count3Active + 1
                        
                        self.cashInString = cashafter
                        self.cash = Int(self.cashInString)!
                        self.cashLabel?.text = "Account: $\(self.cash)"
                        print("Counter_afterBuyingTree100: \(self.cash)")
        }
        }
       // self.timerCall()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       // let location = locations[0]
        if(self.citySwitch == false)
        {
            lati = 28.7041
            longi = 77.1025
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
        
        self.newTree100  = SKSpriteNode(imageNamed: "\(self.treeSelecedIS100)")
        self.newTree100.size = CGSize(width: 100, height: self.treeHight)
        let randomXPos = Int.random(in: -150 ... -100)
        let randomYPos = Int.random(in: -300 ... -280)
        self.newTree100.position = CGPoint(x: randomXPos, y: randomYPos)
        addChild(self.newTree100)
        
        self.tree100.append(self.newTree100)
        
    }
    
    
    
    func spawnTree50()
     {
         
        self.newTree50  = SKSpriteNode(imageNamed: "\(self.treeSelecedIS50)")
        self.newTree50.size = CGSize(width: 80, height: 160)
         let randomXPos = Int.random(in: -50 ... 100)
         let randomYPos = Int.random(in: -300 ... -280)
        self.newTree50.position = CGPoint(x: randomXPos, y: randomYPos)
        addChild(self.newTree50)
         
        self.tree50.append(self.newTree50)
         
     }
    
    func spawnTree3()
        {
            
            self.newTree3  = SKSpriteNode(imageNamed: "\(self.treeSelecedIS3)")
           self.newTree3.size = CGSize(width: 50, height: 130)
            let randomXPos = Int.random(in: 130 ... 170)
            let randomYPos = Int.random(in: -300 ... -280)
            self.newTree3.position = CGPoint(x: randomXPos, y: randomYPos)
            addChild(self.newTree3)
            
            self.tree3.append(self.newTree3)
            
        }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    func timerCall()
    {
        self.updateCount = self.updateCount + 1
                       if (self.updateCount%60 == 0)&&(self.SecondsRemaining > 0) {
                           self.SecondsRemaining = self.SecondsRemaining - 1
                           print("Seconds: \(self.SecondsRemaining)")
                           self.TimeLabel.text = "\(self.SecondsRemaining)"
                        
                           
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
            
            if let levelTwoScene = SKScene(fileNamed: "GameSceneAddTree")
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
        
        if (self.moveToToronto.contains(touch.location(in: self))){
            if(self.cash >= self.torontoCash)
            {
                
                if let levelTwoScene = SKScene(fileNamed: "GameSceneToronto")
                              {
                               scene?.scaleMode = .aspectFit
                               self.view?.presentScene(levelTwoScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
                           self.view?.presentScene(levelTwoScene)
                               
                              }
                
            }
            else
            {
                self.torontoLabel?.text = "$1000 required!"
            }
    
            print("Toronto Button Clicked!")
               
           }
        
        if (self.waterMeButton1.contains(touch.location(in: self))){
            //self.treeHight = self.treeHight + 10
            
            //tree One
             self.newTree100.size.height = self.newTree100.size.height + 2
            self.newTree100.position.y = self.newTree100.position.y + 1
            self.newTree100.size.width = self.newTree100.size.width + 1
            self.newTree100.position.x = self.newTree100.position.x + 0
            self.cash = self.cash + 50
            print("cashe after watering: \(self.cash)")
            self.cashLabel?.text = "Account: $\(self.cash)"
            self.airQualityValue = self.airQualityValue - 3
            self.airQualityLable?.text = "Air Pollution:\(self.airQualityValue)"
                   
                   print("Tree100 bing increased, Button Clicked!")
                      
                  }
        
        if (self.waterMeButton2.contains(touch.location(in: self))){
                   //self.treeHight = self.treeHight + 10
                   
                   //tree One
                    self.newTree50.size.height = self.newTree50.size.height + 2
                   self.newTree50.position.y = self.newTree50.position.y + 1
                   self.newTree50.size.width = self.newTree50.size.width + 1
                   self.newTree50.position.x = self.newTree50.position.x + 0
                   self.cash = self.cash + 20
                   print("cashe after watering: \(self.cash)")
                   self.cashLabel?.text = "Account: $\(self.cash)"
                   self.airQualityValue = self.airQualityValue - 2
                   self.airQualityLable?.text = "Air Pollution:\(self.airQualityValue)"
                          
                          print("Tree50 bing increased, Button Clicked!")
                             
                         }
        
    if (self.waterMeButton3.contains(touch.location(in: self))){
                      //self.treeHight = self.treeHight + 10
                      
                      //tree One
                       self.newTree3.size.height = self.newTree3.size.height + 2
                      self.newTree3.position.y = self.newTree3.position.y + 1
                      self.newTree3.size.width = self.newTree3.size.width + 1
                      self.newTree3.position.x = self.newTree3.position.x + 0
                      self.cash = self.cash + 10
                      print("cashe after watering: \(self.cash)")
                      self.cashLabel?.text = "Account: $\(self.cash)"
                      self.airQualityValue = self.airQualityValue - 1
                      self.airQualityLable?.text = "Air Pollution:\(self.airQualityValue)"
                             
                             print("Tree3 bing increased, Button Clicked!")
                                
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
        if(self.count100Active == 1)
        {
        if(count100 >= 1)
        {
        self.spawnTree100()
            count100 = count100 - 1
        }
        }
        if(self.count50Avtive == 1)
        {
        if(count50 >= 1)
               {
               self.spawnTree50()
                   count50 = count50 - 1
               }
        }
        if(self.count3Active == 1)
        {
        if(count3 >= 1)
               {
               self.spawnTree3()
                   count3 = count3 - 1
               }
        }
        
        self.timerCall()
        if(self.SecondsRemaining == 0)
        {
            self.SecondsRemaining = 60
            self.minutes = self.minutes + 1
            print("Minutes:\(self.minutes)")
        }
        if(self.minutes == 2)
        {
            self.day = self.day + 1
            self.dayLabel.text = ("Day: \(self.day)")
            print("Day: \(self.day)")
            self.minutes = self.minutes - 2
            
        }
        if(self.SecondsRemaining == 10)
        {
            self.airSwichafter10Second = self.airSwichafter10Second + 1
            self.SecondsRemaining = 9
           
        }
        if(self.airSwichafter10Second == 1)
        {
            self.airQualityValue = self.airQualityValue + 10
            self.airQualityLable?.text = "Air Pollution:\(self.airQualityValue)"
            self.airSwichafter10Second = self.airSwichafter10Second - 1
        }
        if(self.airQualityValue >= 800)
        {
            self.boardLable?.text = "Dangerous: Air Pollution Serious"
        }
        if(self.airQualityValue > 500 && self.airQualityValue < 800)
        {
            self.boardLable?.text = "Do palnting in your city to decerese Air Pollution!"
        }
        
        if(self.airQualityValue < 100)
        {
            self.boardLable?.text = "Air Quality is Okay now!"
        }
        if(self.airQualityValue > 100 && self.airQualityValue < 500)
               {
                   self.boardLable?.text = "Air Quality is Moderate."
               }
        
        
         
    }
}
