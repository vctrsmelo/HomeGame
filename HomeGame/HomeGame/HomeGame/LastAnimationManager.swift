//
//  LastAnimationManager.swift
//  HomeGame
//
//  Created by Douglas Gehring on 26/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit

class LastAnimationManager{
    
    
    var animationMainNode:SKSpriteNode!
    
    var fullAnimationFrames:[SKTexture] = []
    var headShakingAnimationFrames:[SKTexture] = []
    
    var previewAnimationEnded = true
    var lastAnimationEnded = false
    
    var totalTimeAnimationIsPerformed = 0
    
    init() {
        
        self.initAnimationSprite()
        self.initPhysicsBody()
        self.initFullAnimationTextures()
        self.initShakingHeadAnimationSprite()
        
    }
    
    private func initAnimationSprite(){
        
        self.animationMainNode = SKSpriteNode(texture: SKTexture(imageNamed: "f1"))
    
        
    }
    
    private func initFullAnimationTextures(){
        
        // executed only once
        
        for i in 1...11{
            
            self.fullAnimationFrames.append(SKTexture(imageNamed: "f\(i)"))
            
        }
    }
    
    private func initShakingHeadAnimationSprite(){
        
        
        // executed repeated times
        
        for i in 8...11{
            
            self.headShakingAnimationFrames.append(SKTexture(imageNamed: "f\(i)"))
        }
        
    }
    
    private func initPhysicsBody(){
        
        self.animationMainNode.physicsBody = SKPhysicsBody.init(texture: self.animationMainNode.texture!, size: CGSize.init(width: self.animationMainNode.size.width, height: self.animationMainNode.size.height-20) )
        
        self.animationMainNode.physicsBody?.affectedByGravity = true
        self.animationMainNode.physicsBody?.pinned = false
        self.animationMainNode.physicsBody?.allowsRotation = false
        self.animationMainNode.physicsBody?.isDynamic = true
        self.animationMainNode.setScale(0.3)
        self.animationMainNode.xScale = 0.2
        
    }
    
    func prepareMainNodeForAnimation(px:CGFloat, py:CGFloat){
        
        
        self.animationMainNode.position.x = px-20
        self.animationMainNode.position.y = py
        
    }
    
    func performOneTimeOnlyEndAnimation(){
        
        
        let animationAction = SKAction.animate(with: self.fullAnimationFrames, timePerFrame: 2.7 / Double(self.fullAnimationFrames.count))
        
        animationAction.timingMode = SKActionTimingMode.easeInEaseOut

        
        self.animationMainNode.run(animationAction)
        
    }
    
    
    func performShakingHeadAnimation(){
        
        
        if(previewAnimationEnded && !lastAnimationEnded){
      
            let animationAction = SKAction.animate(with: self.headShakingAnimationFrames, timePerFrame: 0.7/Double(self.headShakingAnimationFrames.count))
            
            self.previewAnimationEnded = false
            
            animationAction.timingMode = SKActionTimingMode.easeInEaseOut
            
            self.animationMainNode.run(animationAction, completion: {() -> Void in
                
                
                self.previewAnimationEnded = true
                
                self.totalTimeAnimationIsPerformed+=1
                
                if(self.totalTimeAnimationIsPerformed>=8){
                    
                    self.animationMainNode.removeAllActions()
                    self.lastAnimationEnded = true
                }
                
                
            })

            
            
        }
        
        
    }
    
    func allTheGameAnimationsAreFinished()->Bool{
        
        return self.lastAnimationEnded
        
    }
    

}
