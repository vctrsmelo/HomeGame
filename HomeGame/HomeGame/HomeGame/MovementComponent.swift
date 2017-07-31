//
//  MovementComponent.swift
//  HomeGame
//
//  Created by Bharbara Cechin on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit
import GameplayKit

// Move Component for moving components (like the mains character)
// Can be used for moving and running, using state machines
class MovementComponent: GKComponent {
    
    var player: Player {
        return self.entity as! Player
    }
    var rightMovement: Bool!
    //var fast: Bool!
    var distance: Double = 0.0
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
     
    }
    
    func movement (){
        let duration = distance * -0.002 + 0.4
        
        
        if rightMovement  {
            player.walk(positionDirection: .right, duration: duration)

        }
        else{
            player.walk(positionDirection: .left, duration: duration)
     
        }
    }
    
    
}
