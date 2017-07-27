//
//  PlayerLostState.swift
//  HomeGame
//
//  Created by Laura Corssac on 12/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit
import GameplayKit


class PlayerLostState: GKState {
    
    let player: Player!
    
    init(with player: Player) {
        self.player = player
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        let gameOverScene = SKScene(fileNamed: "GameOverScene")
//        let playerParent = player.mainPlayerSprite.parent as! SKScene
        GameViewController.instanceView?.presentScene(gameOverScene)
    }

}
