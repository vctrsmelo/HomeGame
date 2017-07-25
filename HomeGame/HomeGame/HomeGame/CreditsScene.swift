//
//  CreditsScene.swift
//  HomeGame
//
//  Created by Laura Corssac on 24/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit
import GameplayKit

class CreditsScene: SKScene {
    
    
    
    var background = SKSpriteNode()
    var nameArray = ["Bharbara Cechin", "Douglas Gehring", "Juliana Cardoso", "Laura Corssac", "Victor Melo"]
    
    override func didMove(to view: SKView) {
        
        
        background = SKSpriteNode.init(imageNamed: "backGroundCredits")
        addChild(background)
        background.scale(to: (self.view?.frame.size)!)
        background.alpha = 1
        background.zPosition = -2
        
        var counter = 0
        for name in nameArray{
            
            let info = SKLabelNode(fontNamed: "Helvetica-Bold")
            let info2 = SKLabelNode(fontNamed: "Helvetica-Bold")

            let nameComps = name.components(separatedBy: " ")
            let stringFormatted = String.init(format: nameComps[0] + "\r\n" + nameComps[1])
            
            info.text = nameComps[0]
            info2.text = nameComps[1]
            info.fontSize = 14
            info.fontColor = SKColor.white
            info2.fontSize = 14
            info2.fontColor = SKColor.white
            
            let iceberg = childNode(withName: "obj\(counter)") as! SKSpriteNode
            

            let icePos = CGPoint(x: iceberg.position.x - 3, y: iceberg.position.y + iceberg.frame.size.height/2 - 25)
            
            info.position = CGPoint(x: icePos.x, y: icePos.y)
            info2.position = CGPoint(x: icePos.x, y: icePos.y - 15)
            info.zPosition = 3
            info2.zPosition = 3

            
            let shadow = SKSpriteNode.init(imageNamed: "685")
            shadow.position = CGPoint(x: iceberg.position.x, y: iceberg.position.y - 3)
            shadow.zPosition = iceberg.zPosition - 10
            shadow.colorBlendFactor = 0.5
            shadow.color = .black
            shadow.alpha = 0.25
            shadow.blendMode = .alpha
            
        
            
            addChild(info2)
            addChild(shadow)
            addChild(info)
            counter = counter + 1
            
            iceberg.shadowedBitMask = 1
            iceberg.shadowCastBitMask = 1
            iceberg.lightingBitMask = 1
            /*
            let light = SKLightNode()
            
            light.falloff = 0
            light.isEnabled = true
            light.shadowColor = .black
            light.position = iceberg.position
            light.zPosition = iceberg.zPosition + 1
            light.categoryBitMask = 1
            addChild(light)
            */
        }
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let woodTrunk = childNode(withName: "woodTrunk")
        let touch = touches.first
        
        
        if (woodTrunk?.contains((touch?.location(in: self))!))!{
            
            if let home = SKScene(fileNamed: "MainScene"){
                self.view?.presentScene(home)
            }
            
            
        }
        
        
    }
    
    

}
