//
//  PlayerComponent.swift
//  HomeGame
//
//  Created by Laura Corssac on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit
import GameplayKit

class PlayerComponent: GKSKNodeComponent {

    
    let spriteNode: SKSpriteNode!
    
    
    
    
    init(color: SKColor, size: CGSize) {
        self.spriteNode = SKSpriteNode(color: color, size: size)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
