//
//  Player.swift
//  HomeGame
//
//  Created by Laura Corssac on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit
import GameplayKit

class Player: GKEntity {
    
    
    let nodeTest = SKSpriteNode.init(color: .red, size: CGSize(width: 50, height: 50))
    
    var stateMachine: GKStateMachine!
    
     var mainPlayerSprite:SKSpriteNode!
    
    var walkTextures:[SKTexture] = []
    var jumpTextures:[SKTexture] = []
    
    let positionToWalk = CGPoint(x: 40, y: 5)
    let positionToJump = CGPoint(x: 80, y: 10)
    
    let jumpTextureNumber = 10
    let walkTextureNumber = 8
    


    
    override init() {
        super.init()
        
        
       
        
        self.initializeTextureForSpriteNode()
        self.initializeJumpTextures()
        self.initializeWalkTextures()
        
        let playerStopped = StoppedState(with: self)
        let playerMoving = MovingState(with: self)
        let playerJumping = JumpingState(with: self)
        
        let playerWinner = PlayerWonState(with: self)
        let playerLoser = PlayerLostState(with: self)
        
        
        
        let spriteComponent = PlayerComponent(color: SKColor.blue, size: CGSize(width: 50, height: 50))
        self.addComponent(spriteComponent)
        
       
        self.stateMachine = GKStateMachine(states: [playerMoving, playerJumping, playerStopped, playerLoser, playerWinner])
        self.stateMachine.enter(StoppedState.self)
        
        
        
   
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeState( stateClass: AnyClass) {
        
        self.stateMachine.enter(stateClass)


    }

    func walk(){
        
        let animateSprite = SKAction.animate(with: self.walkTextures, timePerFrame: 0.1)
        let moveByHalfXUp = SKAction.moveBy(x: positionToWalk.x/2, y: positionToWalk.y, duration: 0.4)
        let moveByHalfXDown = SKAction.moveBy(x: positionToWalk.x/2, y: -positionToWalk.y, duration: 0.4)
        
        
        let walkAction = SKAction.sequence([moveByHalfXUp, moveByHalfXDown])
        
        var animationWithWalkAction = Array<SKAction>()
        
        animationWithWalkAction.append(animateSprite)
        animationWithWalkAction.append(walkAction)
        
        let walkFullActionGroup = SKAction.group(animationWithWalkAction)
        
        self.mainPlayerSprite.run(SKAction.repeatForever(walkFullActionGroup))
        
    }
    
    func jump(){
        
        let animateSprite = SKAction.animate(with: self.jumpTextures, timePerFrame: 0.1)
        let moveByHalfXUp = SKAction.moveBy(x: positionToJump.x/2, y: positionToJump.y, duration: 0.6)
        let moveByHalfXDown = SKAction.moveBy(x: positionToJump.x/2, y: -positionToJump.y, duration: 0.6)
        
        
        let walkAction = SKAction.sequence([moveByHalfXUp, moveByHalfXDown])
        
        var animationWithJumpAction = Array<SKAction>()
        
        animationWithJumpAction.append(animateSprite)
        animationWithJumpAction.append(walkAction)
        
        let jumpFullActionGroup = SKAction.group(animationWithJumpAction)
        
        self.mainPlayerSprite.run(SKAction.repeatForever(jumpFullActionGroup))
        
        
    }
    
    
    func run(){
        
        
        let animateSprite = SKAction.animate(with: self.walkTextures, timePerFrame: 0.05)
        let moveByHalfXUp = SKAction.moveBy(x: positionToWalk.x, y: positionToWalk.y, duration: 0.4)
        let moveByHalfXDown = SKAction.moveBy(x: positionToWalk.x, y: -positionToWalk.y, duration: 0.4)
        
        
        let walkAction = SKAction.sequence([moveByHalfXUp, moveByHalfXDown])
        
        var animationWithWalkAction = Array<SKAction>()
        
        animationWithWalkAction.append(animateSprite)
        animationWithWalkAction.append(walkAction)
        
        let walkFullActionGroup = SKAction.group(animationWithWalkAction)
        
        self.mainPlayerSprite.run(SKAction.repeatForever(walkFullActionGroup))
        
        
        
        
    }
    
    
    func initializeTextureForSpriteNode(){
        
        mainPlayerSprite = SKSpriteNode(texture: SKTexture(imageNamed: "stop"))
        
        mainPlayerSprite.position = CGPoint(x: 10, y: 100)
        
        
    }
    
    func initializeJumpTextures(){
        
        
        self.jumpTextures.append(SKTexture(imageNamed: "stop"))
        
        for i in 1...10{
            
            
            self.jumpTextures.append(SKTexture(imageNamed: "player_jump_\(i)"))
            
        }
        
    }
    
    
    func initializeWalkTextures(){
        
        
        self.walkTextures.append(SKTexture(imageNamed: "stop"))
        
        for i in 1...7{
            
            self.walkTextures.append(SKTexture(imageNamed: "player_run_\(i)"))
            
        }
        
        
    }

    
    
    func checkTextureForInitialFrame()->Bool{
        
        if String(describing: self.mainPlayerSprite.texture).range(of: "stop") != nil{
            
            self.mainPlayerSprite.removeAllActions()
            //self.player.setPlayerFrameToInitialState()
            return false
            
        }
        else{
            
            return true
            
            
        }
    }
    
    
}
