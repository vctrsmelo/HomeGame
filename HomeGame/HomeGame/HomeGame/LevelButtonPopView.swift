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
        super.init(texture: background, color: .white, size: CGSize(width: 450, height: 450))
        self.zPosition = CGFloat(100)

        // scene to be pushed
        self.levelScene = Level1Scene()
        
        self.initPlayButton()
        self.isUserInteractionEnabled = true
        self.addChild(playButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let homeScene = self.parent?.parent as! SKScene
        if playButton.frame.contains((touches.first?.location(in: self))!) {
            let gameScene = GameScene(size: homeScene.size)
            homeScene.view?.presentScene(gameScene)
        }
        else {
            self.removeFromParent()
        }
    }
    
    func initPlayButton(){
        let playTexture = SKTexture(imageNamed: "play1600")
        
        self.playButton = SKSpriteNode(texture: playTexture, color: .white, size: CGSize(width: 100, height: 100))
        
        self.playButton.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        
        let playButtonPosX = self.frame.midX
        let playButtonPosY = self.frame.minY
        self.playButton.position = CGPoint(x: playButtonPosX, y: playButtonPosY)
        
        self.playButton.zPosition = CGFloat(110)
    }
}
