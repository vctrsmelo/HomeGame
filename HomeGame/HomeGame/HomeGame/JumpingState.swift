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
    
    init(with player: Player) {
        self.player = player
        super.init()
    }

    override func didEnter(from previousState: GKState?) {
        
         player?.component(ofType: JumpComponent.self)?.rightMovement = self.rightMovement
         player?.component(ofType: JumpComponent.self)?.jumpAnimate()
    
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    

}
