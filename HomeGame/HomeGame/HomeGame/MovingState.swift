//
//  MovingState.swift
//  HomeGame
//
//  Created by Laura Corssac on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit
import GameplayKit

class MovingState: GKState {
    
    
    weak var player: Player?
    
    init(with player: Player) {
        self.player = player
        super.init()
    }

    override func didEnter(from previousState: GKState?) {
        
        
        switch previousState {
        case is StoppedState:
             player?.nodeTest.color = .blue
            break
        case is JumpingState:
        
            player?.nodeTest.color = .brown
            break
        default:
            break
            
        }
        

        
    }
    
    

}
