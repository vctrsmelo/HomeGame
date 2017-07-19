//
//  StopComponent.swift
//  HomeGame
//
//  Created by Bharbara Cechin on 13/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit
import GameplayKit

class StopComponent: GKComponent {
    var player: Player {
        return self.entity as! Player
    }

    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func stopAnimate(){
        // call player.stop()
        
       // player.checkTextureForInitialFrame()
    }
    
}
