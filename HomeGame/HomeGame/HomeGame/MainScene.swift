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
            self.addChild(self.playbtn)
            self.addChild(self.creditsbtn)
        }
    }
    
    func initMainSceneAttributes() -> Bool {
        initBackground()
        initPlayBtn()
        initCreditsBtn()
        
        return true
    }
    
    func initBackground() {
        /* Initialize background with a texture */
        let backgroundTexture = SKTexture(imageNamed: "worldbackground")
        let viewWidth = self.view?.bounds.width
        let viewHeight = self.view?.bounds.height
        let backgroundSize = CGSize(width: viewWidth!, height: viewHeight!)
        self.background = SKSpriteNode(texture: backgroundTexture, size: backgroundSize)
        
        self.background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.background.zPosition = CGFloat(-100)
    }
    
    func initPlayBtn() {
        /* Initialize play button */
        let playBtnTexture = SKTexture(imageNamed: "photo")
        let playBtnSize = CGSize(width: 200, height: 100)
        
        self.playbtn = SKSpriteNode(texture: playBtnTexture, size: playBtnSize)
        
        self.playbtn.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        
        let playbtnPosX = background.frame.minX
        let playbtnPosY = background.frame.minY
        self.playbtn.position = CGPoint(x: playbtnPosX, y: playbtnPosY)

        self.playbtn.zPosition = CGFloat(100)
    }
    
    func initCreditsBtn() {
        /* Initialize credits button */
        let creditsBtnTexture = SKTexture(imageNamed: "photo")
        let creditsBtnSize = CGSize(width: 200, height: 100)
        
        self.creditsbtn = SKSpriteNode(texture: creditsBtnTexture, size: creditsBtnSize)
        
        self.creditsbtn.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        
        let creditsbtnPosX = background.frame.maxX
        let creditsbtnPosY = background.frame.minY
        self.creditsbtn.position = CGPoint(x: creditsbtnPosX, y: creditsbtnPosY)

        self.creditsbtn.zPosition = CGFloat(100)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // teste se apertou em playbtn ou creditsbtn
        let gamescene = SKScene(fileNamed: "Level1Scene")
        let creditsScene = SKScene(fileNamed: "CreditsScene")
        
        if self.playbtn.contains((touches.first?.location(in: self))!){
            self.view?.presentScene(gamescene)
        }
        else if self.creditsbtn.contains((touches.first?.location(in: self))!){
            self.view?.presentScene(creditsScene)
        }
    }
}
