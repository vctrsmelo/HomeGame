//
//  BearMother.swift
//  HomeGame
//
//  Created by Douglas Gehring on 26/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit
import GameplayKit

class BearMother{

    
    var mainMotherSprite:SKSpriteNode!
    var endGameAnimationCompleted = true
    var sonAndMotherMatchedPosition = false
    var totalTimePassedEndGameAnimation = 0.0
    
    var positionToWalk = CGPoint(x: 30, y: 0)
    
    var walkTextures:[SKTexture] = []
    
    var moveHeadTextures:[SKTexture] = []
    
    init() {
        
        self.mainMotherSprite = SKSpriteNode(texture: SKTexture(imageNamed: "Stop_Mother"))
       
        self.initMotherMoveHeadTextures()
        self.initMotherWalkTextures()
        self.initMotherSpritePhysicalBody()
      
        
        
    }
    
    private func initMotherMoveHeadTextures(){
        
        for i in 1...9{
            
            self.moveHeadTextures.append(SKTexture.init(imageNamed: "m_\(i)"))
            
        }
        
        
    }
    
    private func initMotherWalkTextures(){
        
        for i in 1...6{
            
        
            self.walkTextures.append(SKTexture(imageNamed: "Walking_\(i)_Mother"))
                
        }
        
        
    }
    
    func animateMotherToSonDirection(){
        
        if(endGameAnimationCompleted && !sonAndMotherMatchedPosition){
            
            
            let animateSprite = SKAction.animate(with: self.walkTextures, timePerFrame: 0.6/Double(walkTextures.count))
            let moveByHalfXUp = SKAction.moveBy(x: -positionToWalk.x, y: positionToWalk.y, duration: 0.6)
            
            
            let walkAction = SKAction.sequence([moveByHalfXUp])
            
            var animationWithWalkAction = Array<SKAction>()
            
            
            animationWithWalkAction.append(animateSprite)
            animationWithWalkAction.append(walkAction)
            
            self.endGameAnimationCompleted = false
            
            let repeatWalkForever = (SKAction.group(animationWithWalkAction))
            
            self.mainMotherSprite.run(repeatWalkForever, completion: {() -> Void in
                
                self.endGameAnimationCompleted = true
                
                self.totalTimePassedEndGameAnimation+=0.6
                
                if(self.totalTimePassedEndGameAnimation > 3.0){
                    
                    self.mainMotherSprite.removeAllActions()
                    
                    self.sonAndMotherMatchedPosition = true
                    
                    self.mainMotherSprite.texture = SKTexture.init(imageNamed: "Stop_Mother")
                    
                }
                
            })
            

            
            
        }
        
        
    }
    
    
    private func headMovementAnimation(){
        
        
         let animateSprite = SKAction.animate(with: self.moveHeadTextures, timePerFrame: 0.9/Double(walkTextures.count))
    
        
        self.mainMotherSprite.run(SKAction.repeatForever(animateSprite))
        
        
        
    }
    
    private func initMotherSpritePhysicalBody(){
        
        
            mainMotherSprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.mainMotherSprite.size.width, height: self.mainMotherSprite.size.height-15))
            
            mainMotherSprite.physicsBody?.affectedByGravity = true
            
            mainMotherSprite.physicsBody?.allowsRotation = false
            
            mainMotherSprite.physicsBody?.pinned = false
            
            mainMotherSprite.physicsBody?.isDynamic = true
            
            mainMotherSprite.physicsBody?.contactTestBitMask = (15)
            
            mainMotherSprite.physicsBody?.friction = 10.0
        
            mainMotherSprite.setScale(0.3)

            mainMotherSprite.xScale *= -(1)
        
            mainMotherSprite.name="Mother"
            
        
        
    }
    
    func changePhysicsBody(){
        
        let mother_texture  = SKTexture.init(imageNamed: "Stop_Fliped_Mother")
      
        self.mainMotherSprite.zPosition = 0
        
        self.mainMotherSprite.physicsBody = SKPhysicsBody.init(texture: mother_texture, size: CGSize.init(width: self.mainMotherSprite.size.width, height: self.mainMotherSprite.size.height - 10))
        
    }
    
    
}
