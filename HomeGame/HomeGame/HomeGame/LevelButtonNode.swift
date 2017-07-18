//
//  LevelButtonNode.swift
//  HomeGame
//
//  Created by Douglas Gehring on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit

class LevelButtonNode : SKSpriteNode {

    // LevelScene:SKScene 
    
    var icon: SKTexture!
    var popView: LevelButtonPopView!
    
    init(pos: CGPoint) {
        self.icon = SKTexture(imageNamed: "icone")
        self.popView = LevelButtonPopView()
        
        super.init(texture: icon, color: .white, size: CGSize(width: 100, height: 100))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func touchButton(){
        self.addChild(popView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchButton()
    }
    
}
