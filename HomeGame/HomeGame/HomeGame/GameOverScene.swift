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
    
    var PlayAgainButotn = SKSpriteNode()
    var MenuButton = SKSpriteNode()
    var label = SKSpriteNode()
    var backGround = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        backGround = SKSpriteNode.init(imageNamed: "gameOver3")
        addChild(backGround)
        backGround.scale(to: self.frame.size)
        backGround.zPosition -= 2
        
        //let menuButton = SKShapeNode.init(rectOf: CGSize.init(width: 105, height: 30))
        //let playAgainButton = SKShapeNode.init(rectOf: CGSize.init(width: 105, height: 30))
        
        
        
        self.PlayAgainButotn = SKSpriteNode.init(texture: SKTexture.init(imageNamed: "playagain"))
        self.MenuButton =  SKSpriteNode.init(texture: SKTexture.init(imageNamed:"button_menu"))
        self.label = SKSpriteNode.init(texture: SKTexture.init(imageNamed: "gameLabel2"))
        
        self.MenuButton.position.y = self.anchorPoint.y - 10
        self.MenuButton.position.x = self.anchorPoint.x
        
        self.PlayAgainButotn.position.x = self.anchorPoint.x
        self.PlayAgainButotn.position.y = self.MenuButton.position.y + self.MenuButton.frame.size.height + 10
        
        
        self.label.position.x = self.anchorPoint.x
        self.label.position.y = (self.view?.frame.size.height)! / 2 - (label.frame.height/2 + 30)
        
        addChild(label)
        addChild(PlayAgainButotn)
        addChild(MenuButton)
        
        
        
        /*
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
 */
        
        
        
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
