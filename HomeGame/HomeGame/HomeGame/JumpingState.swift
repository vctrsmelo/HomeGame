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
    
    init(with player: Player) {
        self.player = player
        super.init()
    }

    override func didEnter(from previousState: GKState?) {
        
        let pontoTeste = CGPoint(x: 100, y: 100)
        let impluse = SKAction.move(to: pontoTeste, duration: 10)
        player?.nodeTest.run(impluse)
   
    
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    

}
