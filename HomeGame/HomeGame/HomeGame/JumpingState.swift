//
//  JumpingState.swift
//  HomeGame
//
//  Created by Laura Corssac on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit
import GameplayKit

class JumpingState: GKState {
    
    weak var player: Player?
    var rightMovement: Bool!
    
    var distance: Double!
    
    init(with player: Player) {
        self.player = player
        super.init()
    }

    override func didEnter(from previousState: GKState?) {
        
        //let pontoTeste = CGPoint(x: 100, y: 100)
        //let impluse = SKAction.move(to: pontoTeste, duration: 10)
        //player?.nodeTest.run(impluse, completion: {
        //    self.player?.stateMachine.enter(StoppedState.self)
       // })
        
        player?.component(ofType: JumpComponent.self)?.distance = self.distance

         player?.component(ofType: JumpComponent.self)?.rightMovement = self.rightMovement
         player?.component(ofType: JumpComponent.self)?.jumpAnimate()
        
        
        
        //player
       
   
    
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    

}
