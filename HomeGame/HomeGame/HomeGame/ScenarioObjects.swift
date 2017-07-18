//
//  ScenarioObjects.swift
//  HomeGame
//
//  Created by Douglas Gehring on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit
import GameplayKit

class ScenarioObjects: GKEntity {

    var objectSprite:SKSpriteNode!
    var objectName:String!
    var offensive = false
    
    init(objectSprite:SKSpriteNode, objectName:String) {
        
        super.init()
        
        self.objectName = objectName
        self.objectSprite = objectSprite
        
        self.verifyOffensiveName()
        
        self.objectSprite.physicsBody?.isDynamic = true
        
        self.objectSprite.physicsBody?.collisionBitMask = 1
        
               // Fall Component for falling objects (like the ice that falls from the top of a cave)
        let fallcomponent = FallComponent()
        self.addComponent(fallcomponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPhysicsBody(){
        
        
        self.objectSprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "iceSpriteCenario"), size: CGSize(width: self.objectSprite.size.width, height: self.objectSprite.size.height))
        self.objectSprite.physicsBody?.affectedByGravity = false
        self.objectSprite.physicsBody?.pinned = true
        self.objectSprite.physicsBody?.allowsRotation = false
        
    }
    
    
    func setOffensive(){
        
        self.offensive = true
    }
    
    func verifyOffensiveName(){
        
        if (self.objectName.range(of: "ice_cub") != nil){
         
            self.setOffensive()
        }
        
    }
    
    // Components to be added
    
    
}
