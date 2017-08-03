//
//  TurtleScene.swift
//  HomeGame
//
//  Created by Douglas Gehring on 03/08/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

class TurtleScene: SKScene {
    
    
    var backGround  = SKSpriteNode()
    var backButton = SKSpriteNode()
    var instaButton = SKSpriteNode()
    var twitterButton = SKSpriteNode()
    
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
      
        print(view.frame.size)
        
        backGround = SKSpriteNode.init(imageNamed: "turtleScreen")
        addChild(backGround)
        backGround.zPosition -= 2
        
        
        instaButton = SKSpriteNode.init(texture: SKTexture.init(imageNamed: "button_insta"))
        twitterButton = SKSpriteNode.init(texture: SKTexture.init(imageNamed: "button_twitter"))
        backButton = SKSpriteNode.init(texture: SKTexture.init(imageNamed: "button_back"))
        
        
        
        
        
        self.twitterButton.position.x =  (self.view?.bounds.width)! / 2 - 33
        
        self.twitterButton.position.y = (self.view?.bounds.height)! / 2 - 32
        
        self.instaButton.position.y = self.twitterButton.position.y
        
        self.instaButton.position.x = self.twitterButton.position.x - (15 + twitterButton.frame.size.width)
        
        self.backButton.position.y = self.twitterButton.position.y
        
        self.backButton.position.x = -self.twitterButton.position.x
        
        
        
        
        
        addChild(instaButton)
        addChild(twitterButton)
        addChild(backButton)
        
        //backGround.scale(to: self.frame.size)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if instaButton.contains((touches.first?.location(in: self))!){
            let url = URL(string: "https://www.instagram.com/homegameios/")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        }
            
        else if twitterButton.contains((touches.first?.location(in: self))!){
            
            let url = URL(string: "https://twitter.com/HomeGameIOS/")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        }
     
        else if backButton.contains((touches.first?.location(in: self))!){
            
            if let home = SKScene(fileNamed: "MainScene"){
                home.scaleMode = .aspectFill
                GameViewController.sharedView.presentScene(home)
            }
            
            
        }
        
        
    }
    
    
}
