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
    
    var isAboveWater = true
    
    var walkTextures:[SKTexture] = []
    var jumpTextures:[SKTexture] = []
    
    var test:SKTextureAtlas!
    
    var positionToWalk = CGPoint(x: 30, y: 0)
    var positionToJump = CGPoint(x: 250, y: 80)
    
    let initialPositionInScene = CGPoint(x:10, y:200)
    
    let jumpTextureNumber = 60
    let walkTextureNumber = 8
    var jumpFinished = 1
    
    var actionCompleted = true
    
    
    var bird:SKNode!

    var animationEnded = 1
    
    //var runEnded =  1
    
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
        
        //if (String(describing: self.mainPlayerSprite.texture).range(of: "player_run_7") == nil){
        if (animationEnded == 1 && jumpFinished == 1){
            
            
            if positionDirection == .left {
                
                self.mainPlayerSprite.xScale = -0.1
                if positionToWalk.x != 0 {
                    positionToWalk.x = -70
                }
                
            }
            else{
                self.mainPlayerSprite.xScale = abs( self.mainPlayerSprite.xScale)
               // if positionToWalk.x != 0  {
                //    positionToWalk.x = 40
               // }
                positionToWalk.x = abs(positionToWalk.x)
                
            }
            
            animationEnded = 0
           
            
            
            //walk duration = 0.4
            //run duration = 0.2
            
           // print("Duratioooonnn" + String (duration))
            
                let frameRate =  20// fps
                let animateSprite = SKAction.animate(with: self.walkTextures, timePerFrame: 0.07)
                let moveByHalfXUp = SKAction.moveBy(x: positionToWalk.x, y: positionToWalk.y, duration: 0.42)
                
                
                let walkAction = SKAction.sequence([moveByHalfXUp])
                
                var animationWithWalkAction = Array<SKAction>()
                
                animationWithWalkAction.append(animateSprite)
                animationWithWalkAction.append(walkAction)
            
                animateSprite.timingMode = SKActionTimingMode.easeInEaseOut
            
                let walkFullActionGroup = SKAction.group(animationWithWalkAction)
                
                self.actionCompleted = false
                
                self.mainPlayerSprite.run(walkFullActionGroup, completion: {() -> Void in
                    
                    self.actionCompleted = true
                    self.animationEnded =  1
                })
                
            //}
            
                
        }
        
    }
   

    
    
    
    
    
    
    
    
    func jump(positionDirection: positionEnum){

        if (jumpFinished == 1){
          if positionDirection == .left{
                self.mainPlayerSprite.xScale = -0.1
                if positionToJump.x != 0 {
                    positionToJump.x = -250
                }
                
            }
            else{
                self.mainPlayerSprite.xScale = abs (self.mainPlayerSprite.xScale)
                positionToJump.x = abs (positionToJump.x)
            }
            
        jumpFinished = 0
        
        let animateSprite = SKAction.animate(with: self.jumpTextures, timePerFrame: 0.2)
        let moveByHalfXUp = SKAction.moveBy(x: positionToJump.x/2, y: positionToJump.y, duration: 0.4)
        let moveByHalfXDown = SKAction.moveBy(x: positionToJump.x/2, y: -positionToJump.y, duration: 0.4)
        
        self.mainPlayerSprite.physicsBody?.affectedByGravity = false
        
        let walkAction = SKAction.sequence([moveByHalfXUp, moveByHalfXDown])
        
        var animationWithJumpAction = Array<SKAction>()
        
        animationWithJumpAction.append(animateSprite)
        animationWithJumpAction.append(walkAction)
        
        let jumpFullActionGroup = SKAction.group(animationWithJumpAction)
        
        self.actionCompleted = false
        self.mainPlayerSprite.run(jumpFullActionGroup, completion:{
            self.stateMachine.enter(StoppedState.self)
            self.jumpFinished = 1
            self.mainPlayerSprite.physicsBody?.affectedByGravity = true
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
          
        
        mainPlayerSprite = SKSpriteNode(texture: SKTexture(imageNamed: "1"))
        
        mainPlayerSprite.position = CGPoint(x: -220, y: -79.992 + 50)
        
        self.initializePlayerPhysicsBody()
    }
    
    func initializeJumpTextures(){
        
        
        //self.jumpTextures.append(SKTexture(imageNamed: "1"))
        
        for i in 1...4{
            
            
            self.jumpTextures.append(SKTexture(imageNamed: "pi\(i)"))
            
        }
        
         self.jumpTextures.append(SKTexture(imageNamed: "1"))
        
    }
    
    
    func initializeWalkTextures(){
        
        
        
        
        // self.test = SKTextureAtlas(named: "WalkingSprites")
        
        
        for i in 2...7{
            
            self.walkTextures.append(SKTexture(imageNamed: "\(i)"))
            
        }
        
      
        
        
    }

    
    
    func checkTextureForInitialFrame()->Bool{
        
        print(self.mainPlayerSprite.texture)
        
        if ((String(describing: self.mainPlayerSprite.texture).range(of: "7")) == nil){
            
            //print(self.mainPlayerSprite.texture)
            
            self.mainPlayerSprite.removeAllActions()
            
            self.mainPlayerSprite.texture = SKTexture.init(imageNamed: "1")
            
            //self.player.setPlayerFrameToInitialState()
            return false
            
        }
        else{
           // let texture
            return true
            
            
        }
        
        return true
    }
    
    
    func initializePlayerPhysicsBody(){
        
        mainPlayerSprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "1"), size: CGSize(width: self.mainPlayerSprite.size.width, height: self.mainPlayerSprite.size.height))
        
        mainPlayerSprite.physicsBody?.affectedByGravity = true
        
        mainPlayerSprite.physicsBody?.allowsRotation = false
        
        mainPlayerSprite.physicsBody?.pinned = false
        
        mainPlayerSprite.physicsBody?.isDynamic = true
        
        mainPlayerSprite.physicsBody?.categoryBitMask = (1|2|3)
        
        mainPlayerSprite.setScale(0.1)
        
        mainPlayerSprite.name="Player"
  
    }
    
    func resetPlayerPosition(){

        let resetPos = SKAction.move(to: self.initialPositionInScene, duration: 0.1)
        self.mainPlayerSprite.run(resetPos,completion: {() -> Void in
            
            self.isAboveWater = true
            
        })
        
    }
    
    
    func stopMainPlayerSpriteAnimation(){
        
        self.mainPlayerSprite.removeAllActions()
        
    }
    override func update(deltaTime seconds: TimeInterval) {
        
        
        print(mainPlayerSprite.texture)
        self.stateMachine.update(deltaTime: seconds )
        
    }
    
}
