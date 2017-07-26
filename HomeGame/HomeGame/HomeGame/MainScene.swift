//
//  MainScene.swift
//  HomeGame
//
//  Created by Bharbara Cechin on 25/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainScene: SKScene {
    
    var background: SKSpriteNode!
    var sea:        SKSpriteNode!
    var iceberg:    SKSpriteNode!
    var stone:      SKSpriteNode!
    var playbtn:    SKSpriteNode!
    var creditsbtn: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Set the scale mode to scale to fill the window
        self.scaleMode = .aspectFill
        
        // Set self.size to be viewcontroller.view.size?
        
        if(initMainSceneAttributes()){
            print("Init Sucess!")
            
            self.addChild(self.background)
            self.addChild(self.sea)
            self.addChild(self.iceberg)
            self.addChild(self.stone)
            self.addChild(self.playbtn)
            self.addChild(self.creditsbtn)
        }
    }
    
    func initMainSceneAttributes() -> Bool {
        initBackground()
        initMiddleground()
        initPlayBtn()
        initCreditsBtn()
        
        return true
    }
    
    func initBackground() {
        /* Initialize background with texture */
        let backgroundTexture = SKTexture(imageNamed: "Prancheta 2")

        let viewWidth = self.view?.bounds.width
        let viewHeight = self.view?.bounds.height
        let backgroundSize = CGSize(width: viewWidth!, height: viewHeight!)
        
        self.background = SKSpriteNode(texture: backgroundTexture, size: backgroundSize)
        
        self.background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.background.zPosition = CGFloat(-100)
    }
    
    func initMiddleground() {
        /* Initialize middleground with texture*/
        // init SEA
        let seaTexture = SKTexture(imageNamed: "Prancheta 5")
        
        let viewWidth = self.view?.bounds.width
        let viewHeight = self.view?.bounds.height
        let seaSize = CGSize(width: viewWidth!, height: (viewHeight!)/4.5)
        
        self.sea = SKSpriteNode(texture: seaTexture, size: seaSize)
        
        self.sea.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        
        let seaPosX = self.background.frame.midX
        let seaPosY = self.background.frame.minY
        self.sea.position = CGPoint(x: seaPosX, y: seaPosY)
        
        self.sea.zPosition = CGFloat(-90)
        
//        // init ICEBERG
        let icebergTexture = SKTexture(imageNamed: "iceberg")
        
        let icebergSize = CGSize(width: (viewWidth!)/4.6, height: (viewHeight!)/1.9)
        
        self.iceberg = SKSpriteNode(texture: icebergTexture, size: icebergSize)
        
        self.iceberg.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        
        let icebergPosX = self.background.frame.maxX
        let icebergPosY = self.background.frame.minY
        self.iceberg.position = CGPoint(x: icebergPosX, y: icebergPosY)
        
        self.iceberg.zPosition = CGFloat(-80)
        
//        // init STONE
        let stoneTexture = SKTexture(imageNamed: "Stone_Front")
        
        let stoneSize = CGSize(width: (viewWidth!)/4, height: (viewHeight!)/6.8)
        
        self.stone = SKSpriteNode(texture: stoneTexture, size: stoneSize)
        
        self.stone.anchorPoint = CGPoint(x: -0.05, y: 0.0)
        
        let stonePosX = self.background.frame.minX
        let stonePosY = self.background.frame.minY
        self.stone.position = CGPoint(x: stonePosX, y: stonePosY)
        
        self.stone.zPosition = CGFloat(-80)
    }
    
    func initPlayBtn() {
        /* Initialize play button */
        let playBtnTexture = SKTexture(imageNamed: "Button_play")
        let playBtnSize = CGSize(width: 150, height: 60)
        
        self.playbtn = SKSpriteNode(texture: playBtnTexture, size: playBtnSize)
        
        self.playbtn.anchorPoint = CGPoint(x: 1.01, y: -0.2)
        
        let playbtnPosX = background.frame.midX
        let playbtnPosY = background.frame.minY
        self.playbtn.position = CGPoint(x: playbtnPosX, y: playbtnPosY)

        self.playbtn.zPosition = CGFloat(100)
    }
    
    func initCreditsBtn() {
        /* Initialize credits button */
        let creditsBtnTexture = SKTexture(imageNamed: "Button_credits")
        let creditsBtnSize = CGSize(width: 150, height: 60)
        
        self.creditsbtn = SKSpriteNode(texture: creditsBtnTexture, size: creditsBtnSize)
        
        self.creditsbtn.anchorPoint = CGPoint(x: -0.01, y: -0.2)
        
        let creditsbtnPosX = background.frame.midX
        let creditsbtnPosY = background.frame.minY
        self.creditsbtn.position = CGPoint(x: creditsbtnPosX, y: creditsbtnPosY)

        self.creditsbtn.zPosition = CGFloat(100)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // teste se apertou em playbtn ou creditsbtn
        let gamescene = SKScene(fileNamed: "Level1Scene")
        let creditsScene = SKScene(fileNamed: "NewCreditsScene")
        
        if self.playbtn.contains((touches.first?.location(in: self))!){
            self.view?.presentScene(gamescene)
        }
        else if self.creditsbtn.contains((touches.first?.location(in: self))!){
            self.view?.presentScene(creditsScene!, transition: SKTransition.fade(with: .white, duration: 1.5))
        }
    }
}
