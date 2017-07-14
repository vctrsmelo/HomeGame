//
//  FallComponent.swift
//  HomeGame
//
//  Created by Bharbara Cechin on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit
import GameplayKit

// Component for falling objects (like the cave ice that falls to the ground)
class FallComponent: GKComponent {
    
    var scenarioObj: ScenarioObjects {
        return self.entity as! ScenarioObjects
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO
    func fallAnimate(){
//        self.node.physicsBody?.applyImpulse(<#T##impulse: CGVector##CGVector#>)
        
//        guard let animationComponent = self.entity?.component(ofType: FallComponent.self) else { return }
//         animationComponent.animate()
        
        // call scenarioObj.fall()
    }

}
