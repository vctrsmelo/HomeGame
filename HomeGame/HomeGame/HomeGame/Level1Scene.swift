//
//  Level1Scene.swift
//  HomeGame
//
//  Created by Douglas Gehring on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit
import GameplayKit

class Level1Scene: SKScene {

    var title:String!
    var scenarioObjects:[ScenarioObjects]!
    var characterNodes:[CharacterNode]!
    
    override func didMove(to view: SKView) {
        
        self.title = "Level_1_Scene"
        self.initScenarioElements()
        self.initCharacterNodes()
        
        
    }
    
    
    func initScenarioElements(){
        
        /* Initializing scenario elements with the name identifier for each one*/
        
    }
    
    func initCharacterNodes(){
        
        /* Initializing characters nodes with the name identifier for each one*/
    }
    
    
    
    
}
