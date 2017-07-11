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
    
    override init() {
        super.init()
        
        
        let playerStopped = StoppedState(with: self)
        let playerMoving = MovingState(with: self)
        let playerJumping = JumpingState(with: self)
        
        let spriteComponent = PlayerComponent(color: SKColor.blue, size: CGSize(width: 50, height: 50))
        self.addComponent(spriteComponent)
        
       
        self.stateMachine = GKStateMachine(states: [playerMoving, playerJumping, playerStopped])
        self.stateMachine.enter(StoppedState.self)
        
   
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeState() {
        
        if( self.stateMachine.currentState is StoppedState ) {
            self.stateMachine.enter(MovingState.self)
        }
    }
    
    
    
}
