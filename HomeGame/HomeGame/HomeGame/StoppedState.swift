//
//  StoppedState.swift
//  HomeGame
//
//  Created by Laura Corssac on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit
import GameplayKit

class StoppedState: GKState {
    
    
    weak var player: Player?
    
    init(with player: Player) {
        self.player = player
        super.init()
    }

    
    
    
    
    
    
    
    override func didEnter(from previousState: GKState?) {
        
        
        
    }

}

