//
//  HomeScene.swift
//  HomeGame
//
//  Created by Douglas Gehring on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit
import GameplayKit

class HomeScene: SKScene {

    var leveButtons:[LevelButtonNode]!
    var worldNode:SKSpriteNode!
    var background:SKSpriteNode!
    

    override func didMove(to view: SKView) {
        
        if(initHomeSceneAttributes()){
            
            print("Init Sucess!")
        }
        
        
    
    }
    
    
    func initHomeSceneAttributes()->Bool{
        
        
        self.initLevelButtons()
        self.initWorldNode()
        self.initBackground()
       
        
        return true
    }
    
    
    func initLevelButtons(){
        
        /* Get the childs from the .sks file using the name identifiers and aloc
         * the nodes according to its locations
         */
    }
    
    func initWorldNode(){
        
        /* Initialize world node with the earth image to place the global warming
         * hotspots
         */
        
    }
    
    func initBackground(){
        
        /* Initialize background with a texture */
        
        
    }
    
    
}
