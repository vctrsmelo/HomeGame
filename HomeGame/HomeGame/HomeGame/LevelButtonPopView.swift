//
//  LevelButtonPopView.swift
//  HomeGame
//
//  Created by Bharbara Cechin on 17/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit

class LevelButtonPopView : SKSpriteNode {
//    var background: SKTexture!
    var background: SKTexture!
    var playButton: SKSpriteNode!
    var levelScene: SKScene!

    init() {
        self.background = SKTexture(imageNamed: "photo")
        super.init(texture: background, color: .white, size: CGSize(width: 100, height: 100))

        // scene to be pushed
        self.levelScene = Level1Scene()
        self.playButton = SKSpriteNode(imageNamed: "play1600")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
