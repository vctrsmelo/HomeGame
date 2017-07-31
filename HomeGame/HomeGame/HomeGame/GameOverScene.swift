//
//  GameOverScene.swift
//  HomeGame
//
//  Created by Laura Corssac on 27/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit
import GameplayKit

class GameOverScene: SKScene {
    
    var PlayAgainButotn = SKShapeNode()
    var MenuButton = SKShapeNode()
    
    var backGround = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        backGround = SKSpriteNode.init(imageNamed: "gameOver")
        addChild(backGround)
        backGround.scale(to: self.frame.size)
        
        let menuButton = SKShapeNode.init(rectOf: CGSize.init(width: 105, height: 30))
        let playAgainButton = SKShapeNode.init(rectOf: CGSize.init(width: 105, height: 30))
        
        self.PlayAgainButotn = playAgainButton
        self.MenuButton = menuButton
        
        menuButton.fillColor = .red
        playAgainButton.fillColor = .black
        
        menuButton.isHidden = true
        playAgainButton.isHidden = true
        
        addChild(menuButton)
        addChild(playAgainButton)
        playAgainButton.position = CGPoint(x: -1.5, y: 28)
        menuButton.position = CGPoint(x: -1.5, y: -12)
        playAgainButton.zPosition = 1
        menuButton.zPosition = 1
        
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if  self.PlayAgainButotn.contains((touches.first?.location(in: self))!){
            if let level1 = SKScene(fileNamed: "Level1Scene"){
                GameViewController.sharedView.presentScene(level1)
            }
        }
        
        else{
            if self.MenuButton.contains((touches.first?.location(in: self))!) {
                if let home = SKScene(fileNamed: "MainScene"){
                    GameViewController.sharedView.presentScene(home)
                }
            }
        }
    }

}
