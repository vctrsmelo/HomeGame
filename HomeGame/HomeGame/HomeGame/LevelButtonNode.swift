//
//  LevelButtonNode.swift
//  HomeGame
//
//  Created by Douglas Gehring on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit

class LevelButtonNode{

    // LevelScene:SKScene 
    
    var icon:SKSpriteNode!
    var background:SKSpriteNode!
    var levelScene:SKScene!
    
    init(background:SKSpriteNode,
         levelScene:SKScene) {
        
        // Todas imagens terão o mesmo icone? PlayButton?
        self.icon = SKSpriteNode(texture: SKTexture(image: UIImage(named: "icone.png")!))
        self.background = background
        self.levelScene = levelScene
        
    }
    
    func pushSceneUp(){
        
        // Pushing the scene to the view controller
        
    }
    
    
    
}
