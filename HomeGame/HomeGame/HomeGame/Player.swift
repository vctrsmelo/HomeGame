//
//  Player.swift
//  HomeGame
//
//  Created by Laura Corssac on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit
import GameplayKit




enum positionEnum {
    case left
    case right
}



class Player: GKEntity {
    
    
    //let nodeTest = SKSpriteNode.init(color: .red, size: CGSize(width: 50, height: 50))
    
    var stateMachine: GKStateMachine!
    
     var mainPlayerSprite:SKSpriteNode!
    
    let spriteScale: CGFloat = 0.3
    
    var isAboveWater = true
    
    var walkTextures:[SKTexture] = []
    var jumpTextures:[SKTexture] = []
    var runTextures:[SKTexture] = []
    
    //var test:SKTextureAtlas!
    
    var positionToWalk = CGPoint(x: 30, y: 0)
    var positionToJump = CGPoint(x: 120, y: 220)
    
    let initialPositionInScene = CGPoint(x:10, y:200)

    let jumpTextureNumber = 60
    let walkTextureNumber = 8
    var jumpFinished = 1
    
    var actionCompleted = true
    
    var finishEndGameAnimation = false
    
    var bird:SKNode!

    var animationEnded = 1
    
    var totalTimePassedEndGameAnimation = 0.0
    
    var endGameAnimationCompleted = true
    
    //var runEnded =  1
    
    override init() {
        super.init()
        
        self.initializeTextureForSpriteNode()
        self.initializeJumpTextures()
        self.initializeWalkTextures()
        self.initializeRunTextures()
        
        let playerStopped = StoppedState(with: self)
        let playerMoving = MovingState(with: self)
        let playerJumping = JumpingState(with: self)
        
        let playerWinner = PlayerWonState(with: self)
        let playerLoser = PlayerLostState(with: self)

        self.initializePlayerPhysicsBody()
        
        let jumpComp = JumpComponent()
        let moveComp = MovementComponent()
        let stopComp = StopComponent()
        let spriteComponent = PlayerComponent(color: SKColor.blue, size: CGSize(width: 50, height: 50))
        self.addComponent(spriteComponent)
        self.addComponent(moveComp)
        self.addComponent(jumpComp)
        self.addComponent(stopComp)
       
        self.stateMachine = GKStateMachine(states: [playerMoving, playerJumping, playerStopped, playerLoser, playerWinner])
        self.stateMachine.enter(StoppedState.self)
        
        
        
   
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeState( stateClass: AnyClass) {
        
        self.stateMachine.enter(stateClass)


    }

    func walk(positionDirection: positionEnum, duration: Double){
        
        let shouldRunDuration = 0.194
        var isRunning = false
        
        if duration <= shouldRunDuration{
            isRunning = true
        }
        
        if (animationEnded == 1 && jumpFinished == 1){
            
            if positionDirection == .left {
                
                self.mainPlayerSprite.xScale = -spriteScale
                if positionToWalk.x != 0 {
                    positionToWalk.x = -30
                }
                
            }
            else{
                self.mainPlayerSprite.xScale = abs( self.mainPlayerSprite.xScale)
                positionToWalk.x = abs(positionToWalk.x)
                
            }
            
            animationEnded = 0
            let animateSprite = isRunning ? SKAction.animate(with: self.runTextures, timePerFrame: duration/Double(runTextures.count)) : SKAction.animate(with: self.walkTextures, timePerFrame: duration/Double(walkTextures.count))
            let moveByHalfXUp = SKAction.moveBy(x: positionToWalk.x, y: positionToWalk.y, duration: duration)
            
            
            let walkAction = SKAction.sequence([moveByHalfXUp])
            
            var animationWithWalkAction = Array<SKAction>()
            
            
                animationWithWalkAction.append(animateSprite)
                animationWithWalkAction.append(walkAction)
            
            self.actionCompleted = false
            
            self.mainPlayerSprite.run(SKAction.group(animationWithWalkAction), completion: {() -> Void in
                
                
                
                
                self.mainPlayerSprite.zPosition = 0
                self.actionCompleted = true
                self.animationEnded =  1
            })
        
            
                
        }
        
    }
   

    
    
    
    
    
    
    
    
    func jump(positionDirection: positionEnum){

        
        
        if (jumpFinished == 1){
          if positionDirection == .left{
                self.mainPlayerSprite.xScale = -spriteScale
                if positionToJump.x != 0 {
                    positionToJump.x = -120
                }
                
            }
            else{
                self.mainPlayerSprite.xScale = abs (self.mainPlayerSprite.xScale)
                positionToJump.x = abs (positionToJump.x)
            }
            
        jumpFinished = 0
        
        let animateSprite = SKAction.animate(with: self.jumpTextures, timePerFrame: 0.2)
          
            let moveByHalfXUp = SKAction.applyForce(CGVector(dx: self.positionToJump.x, dy: self.positionToJump.y), at: self.mainPlayerSprite.position, duration: 0.2)
            let moveByHalfXDown = SKAction.applyForce(CGVector(dx: self.positionToJump.x, dy: self.positionToJump.y), at: self.mainPlayerSprite.position, duration: 0.2)
            
            
        /*
        let moveByHalfXUp = SKAction.moveBy(x: positionToJump.x/2, y: positionToJump.y, duration: 0.4)
        let moveByHalfXDown = SKAction.moveBy(x: positionToJump.x/2, y: -positionToJump.y, duration: 0.4)
        */
 
 
        //self.mainPlayerSprite.physicsBody?.affectedByGravity = false
        
        let walkAction = SKAction.sequence([moveByHalfXUp, moveByHalfXDown])
        
        var animationWithJumpAction = Array<SKAction>()
        
        animationWithJumpAction.append(animateSprite)
        animationWithJumpAction.append(walkAction)
        
        let jumpFullActionGroup = SKAction.group(animationWithJumpAction)
        
        self.actionCompleted = false
        self.mainPlayerSprite.run(jumpFullActionGroup, completion:{
            self.stateMachine.enter(StoppedState.self)
            self.jumpFinished = 1
            //self.mainPlayerSprite.physicsBody?.affectedByGravity = true
        })
            
            
        }
        
        
    }
    
    
    /*
    func run(positionDirection: positionEnum){
        
        
        
        if (runEnded == 1 && jumpFinished == 1){
            
            
            if positionDirection == .left {
                self.mainPlayerSprite.xScale = -0.2
                if positionToWalk.x != 0 {
                    positionToWalk.x = -40
                }
                
                
            }
            else{
                self.mainPlayerSprite.xScale = abs ( self.mainPlayerSprite.xScale)
                positionToWalk.x = abs (self.positionToWalk.x)

            }
            
            
            self.runEnded = 0
        
            let animateSprite = SKAction.animate(with: self.walkTextures, timePerFrame: 0.1)
            let moveByHalfXUp = SKAction.moveBy(x: positionToWalk.x, y: positionToWalk.y, duration: 0.2)
            let moveByHalfXDown = SKAction.moveBy(x: positionToWalk.x, y: -positionToWalk.y, duration: 0.2)
            
            
            let walkAction = SKAction.sequence([moveByHalfXUp, moveByHalfXDown])
            
            var animationWithWalkAction = Array<SKAction>()
            
            animationWithWalkAction.append(animateSprite)
            animationWithWalkAction.append(walkAction)
            
            let walkFullActionGroup = SKAction.group(animationWithWalkAction)
            
            self.actionCompleted = false
                self.mainPlayerSprite.run(walkFullActionGroup, completion:{
                    
                    self.runEnded = 1
                    
                })
            
            self.mainPlayerSprite.run(walkFullActionGroup, completion: {() -> Void in
                
                self.actionCompleted = true
            })

        
        }
        
    }
 */
    
    func initializeTextureForSpriteNode(){
          
        
        mainPlayerSprite = SKSpriteNode(texture: SKTexture(imageNamed: "Walking_1"))
        
        mainPlayerSprite.position = CGPoint(x: 7367, y: -79.992 + 50)
        
        mainPlayerSprite.zPosition = 0
        
        self.initializePlayerPhysicsBody()
    }
    
    func initializeJumpTextures(){
        
        for i in 1...4{
            
            
            self.jumpTextures.append(SKTexture(imageNamed: "Jumping_\(i)"))
            
        }
        
        self.jumpTextures.append(SKTexture(imageNamed: "Walking_1"))
        
    }
    
    
    func initializeWalkTextures(){
        
        for i in 2...7{
            
            self.walkTextures.append(SKTexture(imageNamed: "Walking_\(i)"))
            
        }
        
    }
    
    func initializeRunTextures(){
        
        for i in 1...4{
            
            self.runTextures.append(SKTexture(imageNamed: "Running_\(i)"))
            
        }
        
    }

    
    
    func checkTextureForInitialFrame()->Bool{
        
        if ((String(describing: self.mainPlayerSprite.texture).range(of: "7")) == nil){
            
            //print(self.mainPlayerSprite.texture)
            
            self.mainPlayerSprite.removeAllActions()
            
            self.mainPlayerSprite.texture = SKTexture.init(imageNamed: "Walking_1")
            
            //self.player.setPlayerFrameToInitialState()
            return false
            
        }
    
        return true

    }
    
    
    func initializePlayerPhysicsBody(){
        
        mainPlayerSprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.mainPlayerSprite.size.width, height: self.mainPlayerSprite.size.height-15))
        
        mainPlayerSprite.physicsBody?.affectedByGravity = true
        
        mainPlayerSprite.physicsBody?.allowsRotation = false
        
        mainPlayerSprite.physicsBody?.pinned = false
        
        mainPlayerSprite.physicsBody?.isDynamic = true
        
        mainPlayerSprite.physicsBody?.categoryBitMask = (1|2|3)
        
        mainPlayerSprite.physicsBody?.friction = 10.0
        
        mainPlayerSprite.setScale(spriteScale)
        
        mainPlayerSprite.name="Player"
  
    }
    
    func resetPlayerPosition(){

        let resetPos = SKAction.move(to: self.initialPositionInScene, duration: 0.1)
        self.mainPlayerSprite.run(resetPos,completion: {() -> Void in
            
            self.isAboveWater = true
            
        })
        
    }
    
    
    
    
    func performEndGameAnimation(){
        
        
        if(self.endGameAnimationCompleted && !finishEndGameAnimation){
            
            
            let animateSprite = SKAction.animate(with: self.walkTextures, timePerFrame: 0.6/Double(walkTextures.count))
            let moveByHalfXUp = SKAction.moveBy(x: positionToWalk.x, y: positionToWalk.y, duration: 0.6)
            
            
            let walkAction = SKAction.sequence([moveByHalfXUp])
            
            var animationWithWalkAction = Array<SKAction>()
            
            
            animationWithWalkAction.append(animateSprite)
            animationWithWalkAction.append(walkAction)
            
            self.endGameAnimationCompleted = false
            
            let repeatWalkForever = (SKAction.group(animationWithWalkAction))
            
            self.mainPlayerSprite.run(repeatWalkForever, completion: {() -> Void in
                
                self.endGameAnimationCompleted = true
                self.totalTimePassedEndGameAnimation+=0.6
                
                if(self.totalTimePassedEndGameAnimation > 4.8){
                    
                    self.mainPlayerSprite.removeAllActions()
                    
                    self.finishEndGameAnimation = true
                    
                    self.mainPlayerSprite.texture = SKTexture.init(imageNamed: "Walking_1")
                }
                
            })
            
            
            
        }
        

        
        
        
    }
    
    
    func stopMainPlayerSpriteAnimation(){
        
        self.mainPlayerSprite.removeAllActions()
        
    }
    override func update(deltaTime seconds: TimeInterval) {
        
        self.stateMachine.update(deltaTime: seconds )
        
    }
    
    func changePhysicsBody(){
        
        self.mainPlayerSprite.physicsBody = SKPhysicsBody.init(texture: SKTexture.init(imageNamed: "Walking_1"), size: self.mainPlayerSprite.size)
        
    }
    
}
