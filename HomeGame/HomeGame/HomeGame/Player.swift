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
    
    // MARK: WALK AND RUN SOUNDS
    let runSound = SKAudioNode()
    let walkSound = SKAudioNode()
    var movingSound = SKAudioNode()
    
    var stateMachine: GKStateMachine!
    
    var mainPlayerSprite:SKSpriteNode!
    
    let spriteScale: CGFloat = 0.3
    
    var isAboveWater = true
    
    var walkTextures:[SKTexture] = []
    var jumpTextures:[SKTexture] = []
    var runTextures:[SKTexture] = []
    
    //var test:SKTextureAtlas!
    
    var positionToWalk = CGPoint(x: 30, y: 0)
    var positionToJump = CGPoint(x: 120, y: 280)
    
    
    
    let initialPositionInScene = CGPoint(x:-210, y:-69)

    let jumpTextureNumber = 60
    let walkTextureNumber = 8
    var jumpFinished = 1
    
    var actionCompleted = true
    
    var finishEndGameAnimation = false
    
    var bird:SKNode!

    var animationEnded = 1
    
    var totalTimePassedEndGameAnimation = 0.0
    
    var endGameAnimationCompleted = true
    
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
            
            // MARK: MOVINGSOUND
//            print("\nwill enter if")
            if isRunning {
                let sound = SKAudioNode(fileNamed: "run.mp3")
                movingSound = sound
            }
            else {
                let sound = SKAudioNode(fileNamed: "walkstop().mp3")
                movingSound = sound
            }

            // MARK: PLAYER MOVING SOUND
            let playerScene = self.mainPlayerSprite.parent
            
            playerScene?.addChild(self.movingSound)

            
            let walkAction = SKAction.sequence([moveByHalfXUp])
            
            var animationWithWalkAction = Array<SKAction>()
            
            
                animationWithWalkAction.append(animateSprite)
                animationWithWalkAction.append(walkAction)
            
            self.actionCompleted = false
            
            self.mainPlayerSprite.run(SKAction.group(animationWithWalkAction), completion: {() -> Void in
                
                self.mainPlayerSprite.zPosition = 0
                self.actionCompleted = true
                self.animationEnded =  1
                
                // MARK: PLAYER MOVING SOUND STOP
                self.movingSound.run(SKAction.stop())

            })
     
        }
        
    }
    
    func jump(positionDirection: positionEnum){

        
        
        if (jumpFinished == 1){
          if positionDirection == .left{
                self.mainPlayerSprite.xScale = -spriteScale
                //if positionToJump.x != 0 {
                  //  positionToJump.x = -120
                //}
                
            }
            else{
                self.mainPlayerSprite.xScale = abs (self.mainPlayerSprite.xScale)
                //positionToJump.x = abs (positionToJump.x)
            }
            
        jumpFinished = 0
        
        let animateSprite = SKAction.animate(with: self.jumpTextures, timePerFrame: 0.2)
          
        let moveByHalfXUp = SKAction.applyForce(CGVector(dx: self.positionToJump.x, dy: self.positionToJump.y), at: self.mainPlayerSprite.position, duration: 0.2)
        let moveByHalfXDown = SKAction.applyForce(CGVector(dx: self.positionToJump.x, dy: self.positionToJump.y), at: self.mainPlayerSprite.position, duration: 0.2)
            
        let walkAction = SKAction.sequence([moveByHalfXUp, moveByHalfXDown])
        
        var animationWithJumpAction = Array<SKAction>()
        
        animationWithJumpAction.append(animateSprite)
        animationWithJumpAction.append(walkAction)
        
        let jumpFullActionGroup = SKAction.group(animationWithJumpAction)
        
        self.actionCompleted = false
        self.mainPlayerSprite.run(jumpFullActionGroup, completion:{
            self.stateMachine.enter(StoppedState.self)
            self.jumpFinished = 1
            
        })
            
            
        }
        
        
    }
    
    func initializeTextureForSpriteNode(){
          
        
        mainPlayerSprite = SKSpriteNode(texture: SKTexture(imageNamed: "Walking_1"))
        
        mainPlayerSprite.position = initialPositionInScene //CGPoint(x: 7367, y: -79.992 + 50)
        
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
    
        if(self.mainPlayerSprite.position.y < -130 && !(self.stateMachine.currentState is PlayerLostState)){
            
            self.stateMachine.enter(PlayerLostState.self)
            
        }
        
    }
    
    func changePhysicsBody(){
        
        self.mainPlayerSprite.physicsBody = SKPhysicsBody.init(texture: SKTexture.init(imageNamed: "Walking_1"), size: CGSize.init(width: self.mainPlayerSprite.size.width, height: self.mainPlayerSprite.size.height-10))
        
    }
    
}
