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
    
    let positionToWalk = CGPoint(x: 20, y: 0)
    let positionToJump = CGPoint(x: 80, y:60 )
    
    let jumpTextureNumber = 60
    let walkTextureNumber = 8
    
    var actionCompleted = true
    

    
    
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
        
        
        
        let jumpComp = JumpComponent()
        let moveComp = MovementComponent()
        let spriteComponent = PlayerComponent(color: SKColor.blue, size: CGSize(width: 50, height: 50))
        self.addComponent(spriteComponent)
        self.addComponent(moveComp)
        self.addComponent(jumpComp)
        
        
        
        
        
        
       
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
        
        print("Caminhar")
        
        
        
        if(actionCompleted){
            
            
            let animateSprite = SKAction.animate(with: self.walkTextures, timePerFrame: 0.1)
            let moveByHalfXUp = SKAction.moveBy(x: positionToWalk.x/2, y: positionToWalk.y, duration: 0.4)
            let moveByHalfXDown = SKAction.moveBy(x: positionToWalk.x/2, y: -positionToWalk.y, duration: 0.4)
            
            
            let walkAction = SKAction.sequence([moveByHalfXUp, moveByHalfXDown])
            
            var animationWithWalkAction = Array<SKAction>()
            
            animationWithWalkAction.append(animateSprite)
            animationWithWalkAction.append(walkAction)
            
            let walkFullActionGroup = SKAction.group(animationWithWalkAction)
            
            self.actionCompleted = false
            
            self.mainPlayerSprite.run(walkFullActionGroup, completion: {() -> Void in
                
                self.actionCompleted = true
            })
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    func jump(){
        
        let animateSprite = SKAction.animate(with: self.jumpTextures, timePerFrame: 0.1)
        let moveByHalfXUp = SKAction.moveBy(x: positionToJump.x/2, y: positionToJump.y, duration: 0.6)
        let moveByHalfXDown = SKAction.moveBy(x: positionToJump.x/2, y: -positionToJump.y, duration: 0.6)
        
        self.mainPlayerSprite.physicsBody?.affectedByGravity = false
        
        let walkAction = SKAction.sequence([moveByHalfXUp, moveByHalfXDown])
        
        var animationWithJumpAction = Array<SKAction>()
        
        animationWithJumpAction.append(animateSprite)
        animationWithJumpAction.append(walkAction)
        
        let jumpFullActionGroup = SKAction.group(animationWithJumpAction)
        
        self.actionCompleted = false
        
        
        self.mainPlayerSprite.run(jumpFullActionGroup, completion: {() -> Void in
            
            self.actionCompleted = true
            
            self.mainPlayerSprite.physicsBody?.affectedByGravity = true
        })

        
        
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
        
        self.actionCompleted = false
        
        self.mainPlayerSprite.run(walkFullActionGroup, completion: {() -> Void in
            
            self.actionCompleted = true
        })

        
        
        
        
    }
    
    
    func initializeTextureForSpriteNode(){
        
        mainPlayerSprite = SKSpriteNode(texture: SKTexture(imageNamed: "stop"))
        
        mainPlayerSprite.position = CGPoint(x: -100, y: 100)
        
        self.initializePlayerPhysicsBody()
    }
    
    func initializeJumpTextures(){
        
        
        self.jumpTextures.append(SKTexture(imageNamed: "stop"))
        
        for i in 1...10{
            
            
            self.jumpTextures.append(SKTexture(imageNamed: "player_jump_\(i)"))
            
        }
        
         self.jumpTextures.append(SKTexture(imageNamed: "stop"))
        
    }
    
    
    func initializeWalkTextures(){
        
        
        self.walkTextures.append(SKTexture(imageNamed: "stop"))
        
        for i in 1...7{
            
            self.walkTextures.append(SKTexture(imageNamed: "player_run_\(i)"))
            
        }
        
        self.jumpTextures.append(SKTexture(imageNamed: "stop"))
        
        
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
    
    
    func initializePlayerPhysicsBody(){
        
        mainPlayerSprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "stop"), size: CGSize(width: self.mainPlayerSprite.size.width, height: self.mainPlayerSprite.size.height))
        
        mainPlayerSprite.physicsBody?.affectedByGravity = true
        
        mainPlayerSprite.physicsBody?.allowsRotation = false
        
        mainPlayerSprite.physicsBody?.pinned = false
        
        mainPlayerSprite.physicsBody?.isDynamic = true
        
        mainPlayerSprite.physicsBody?.categoryBitMask = 1
  
    }
    
    func resetPlayerPosition(){
        
        self.mainPlayerSprite.run(SKAction.move(to: CGPoint(x:10, y:200), duration: 0.1))
     
        
        
    }
    
    
    func stopMainPlayerSpriteAnimation(){
        
        self.mainPlayerSprite.removeAllActions()
        
    }
    override func update(deltaTime seconds: TimeInterval) {
        self.stateMachine.update(deltaTime: seconds )
    }
    
}
