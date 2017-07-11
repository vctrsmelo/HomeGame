//
//  GameScene.swift
//  HomeGame
//
//  Created by Victor S Melo on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player: Player!
    
    
    
    override func didMove(to view: SKView) {
        
    
        self.player =  Player()
       addChild(player.nodeTest)
        
    }
    
    
   
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.changeState()
    }
    
    
}
