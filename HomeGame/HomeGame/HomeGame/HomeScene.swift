//
//  HomeScene.swift
//  HomeGame
//
//  Created by Douglas Gehring on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit
import GameplayKit

class HomeScene: SKScene {

    var background:SKSpriteNode!
    var worldNode: SKSpriteNode!
    var levelButtons:[LevelButtonNode]! = []
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Set the scale mode to scale to fill the window
        self.scaleMode = .aspectFill
        
        if(initHomeSceneAttributes()){
            print("Init Sucess!")
            
            self.addChild(self.background)
            self.addChild(self.worldNode)
            for levelButton in self.levelButtons {
                addChild(levelButton)
            }
        }
    }
    
    
    func initHomeSceneAttributes()->Bool{
        self.initBackground()
        self.initWorldNode()
        self.initLevelButtons()
        
        return true
    }
    
    func initBackground(){
        
        /* Initialize background with a texture */
        self.background = SKSpriteNode(texture: SKTexture(imageNamed: "worldbackground"), size: CGSize(width: (self.view?.bounds.maxX)!, height: (self.view?.bounds.maxY)!))
        self.background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.background.zPosition = CGFloat(-100)
    }
    
    func initWorldNode(){
        
        /* Initialize world node with the earth image to place the global warming
         * hotspots
         */
        self.worldNode = SKSpriteNode(texture: SKTexture(imageNamed: "world"), color: UIColor.white, size: CGSize(width: 300, height: 300))
        self.worldNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.worldNode.zPosition = CGFloat(-90)
    }

    func initLevelButtons(){
        
        /* Get the childs from the .sks file using the name identifiers and aloc
         * the nodes according to its locations
         */
        
        self.levelButtons.append(LevelButtonNode(pos: CGPoint(x: 0, y: 0)))
        
        for levelButton in levelButtons {
            levelButton.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            levelButton.zPosition = CGFloat(0)
        }
    }
    
    func didSelectLevel(){
        
    }
        
}
