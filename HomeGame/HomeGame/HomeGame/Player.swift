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
    
    var nodo: SKShapeNode!
    var nodo2: SKShapeNode!
    
    var stateMachine: GKStateMachine!
    
    var mainPlayerSprite:SKSpriteNode!
    
    let spriteScale: CGFloat = 0.3
    
    var isAboveWater = true
    
    var walkTextures:[SKTexture] = []
    var jumpTextures:[SKTexture] = []
    var runTextures:[SKTexture] = []
    
    //var test:SKTextureAtlas!
    
    var positionToWalk = CGPoint(x: 30, y: 0)
    var positionToJump = CGPoint(x: 120, y: 200)
    
    
    
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
        //self.initializePlayerPhysicsBody()
        self.initializeJumpTextures()
        self.initializeWalkTextures()
        self.initializeRunTextures()
        
        let playerStopped = StoppedState(with: self)
        let playerMoving = MovingState(with: self)
        let playerJumping = JumpingState(with: self)
        
        let playerWinner = PlayerWonState(with: self)
        let playerLoser = PlayerLostState(with: self)

        
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
        
        mainPlayerSprite.setScale(spriteScale)
        
       // let scalePhysics =  SKAction.scale(to: spriteScale, duration: 5)
       // mainPlayerSprite.run(scalePhysics)
    
        //let physicsBody2 = SKPhysicsBody(rectangleOf: CGSize(width: self.mainPlayerSprite.size.width, height: self.mainPlayerSprite.size.height-15), center: CGPoint.init(x: mainPlayerSprite.anchorPoint.x - 10, y: mainPlayerSprite.anchorPoint.y))
        
        let rect = CGRect.init(x: -194, y: -70, width: 23, height: 20)
        let rect2 = CGRect.init(x:initialPositionInScene.x-35, y:initialPositionInScene.y-20, width: 81.6000061035156 - 30, height: 46.5 - 7)
        
        
        let bottomLeft = rect.origin;
        let bottomRight = CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y);
        
        let topRight = CGPoint(x: rect.origin.x + rect.size.width, y:
                                           rect.origin.y + rect.size.height);
        
        let bottomLeft2 = rect2.origin;
        let bottomRight2 = CGPoint(x: rect2.origin.x + rect2.size.width, y: rect2.origin.y);
        let topLeft2 = CGPoint(x: rect2.origin.x, y: rect2.origin.y + rect2.size.height);
        
        let cena = Level1Scene()
        
        let path = UIBezierPath()
        

        path.move(to: cena.convert(bottomLeft2, to: mainPlayerSprite))
        //path.addLine(to: bottomRight)
        //path.addLine(to: topRight)
        path.addLine(to: cena.convert(topLeft2, to: mainPlayerSprite))
        path.addLine(to: cena.convert(topRight, to: mainPlayerSprite))
        path.addLine(to: cena.convert(bottomRight, to: mainPlayerSprite))//(to: bottomRight)
        path.addLine(to: cena.convert(bottomLeft, to: mainPlayerSprite))//(to: bottomLeft)
        path.addLine(to: cena.convert(bottomRight2, to: mainPlayerSprite))//bottomRight2)
        path.addLine(to: cena.convert(bottomLeft2, to: mainPlayerSprite))//(to: bottomLeft2)
       // path.stroke()
        //mainPlayerSprite.setScale(spriteScale)

       
       // let physicsBody = SKPhysicsBody.init(edgeLoopFrom: path.cgPath)
       // let physics3 = SKPhysicsBody.init(texture: mainPlayerSprite.texture!, alphaThreshold: 0.5, size: mainPlayerSprite.size)
        
        //let physicsBody5 = SKPhysicsBody(circleOfRadius: min(mainPlayerSprite.size.height, mainPlayerSprite.size.width)*0.55)
        
        let physics3 = SKPhysicsBody.init(texture: mainPlayerSprite.texture!, size: CGSize.init(width: self.mainPlayerSprite.size.width, height: self.mainPlayerSprite.size.height-10))
        
        mainPlayerSprite.physicsBody = physics3
        mainPlayerSprite.physicsBody?.mass = 0.1
      


        
               /*
        let tst = SKShapeNode.init(path: path.cgPath)
        tst.strokeColor = .black
        tst.lineWidth = 2
        let tst2 = SKShapeNode.init(rect: rect)
        nodo = tst
        nodo2 = tst2
        
        nodo.zPosition = 3
        //nodo.fillColor = .red
        nodo2.zPosition = -1
        nodo2.fillColor = .blue
        */
        
        
        mainPlayerSprite.physicsBody?.affectedByGravity = true
        
        mainPlayerSprite.physicsBody?.allowsRotation = false
        
        mainPlayerSprite.physicsBody?.pinned = false
        
        mainPlayerSprite.physicsBody?.isDynamic = true
        
        mainPlayerSprite.physicsBody?.categoryBitMask = (1|2|3)
        
        mainPlayerSprite.physicsBody?.friction = 10.0
        
        
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
