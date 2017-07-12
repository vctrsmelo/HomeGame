//
//  CharacterNode.swift
//  HomeGame
//
//  Created by Douglas Gehring on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit
import GameplayKit

class CharacterNode: GKEntity {

    var characterSprite:SKSpriteNode!
    var name:String!
    
    init(characterSprite:SKSpriteNode, name:String) {
        
        super.init()
        
        self.characterSprite = characterSprite
        self.name = name
        
        // movecomponent
        let movecomponent = MovementComponent()
        addComponent(movecomponent)
        
        // jumpcomponent
        let jumpcomponent = JumpComponent()
        addComponent(jumpcomponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Components to be added
    
    
}
