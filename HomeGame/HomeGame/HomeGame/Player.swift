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
    
    
    
    var spriteA:SKSpriteNode!
    var spriteSheets:[SKTexture] = []

    
    override init() {
        super.init()
        
        
       // self.initializeSpriteNode()
        
        
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

        
        //if( self.stateMachine.currentState is StoppedState ) {
//            self.stateMachine.enter(MovingState.self)
        //}
    }
//    func walk(){
//        
//        let animateSprite = SKAction.animate(with: self.spriteSheets, timePerFrame: 0.1)
//        let moveByAction = SKAction.moveBy(x: 10, y: 0, duration: 0.5)
//        
//        var movementActions = Array<SKAction>()
//        
//        movementActions.append(animateSprite)
//        movementActions.append(moveByAction)
//        
//        let movementActionGroup = SKAction.group(movementActions)
//        
//        self.spriteA.run(SKAction.repeatForever(movementActionGroup))
//        
//    }
//    
    
//    func initializeSpriteNode(){
//        
//        self.spriteSheets.append(SKTexture(imageNamed: "stop"))
//        
//        for i in 1...7{
//            
//            self.spriteSheets.append(SKTexture(imageNamed: "player_run_\(i)"))
//            
//        }
//        
//        let firstFrame = self.spriteSheets[0]
//        
//        spriteA = SKSpriteNode(texture: firstFrame)
//        
//        spriteA.position = CGPoint(x: 10, y: 100)
//        
//    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        
        
        
        
    }
    
    
}
