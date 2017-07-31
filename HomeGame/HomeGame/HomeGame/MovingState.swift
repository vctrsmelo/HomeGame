//
//  MovingState.swift
//  HomeGame
//
//  Created by Laura Corssac on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit
import GameplayKit

class MovingState: GKState {
    
    var touchesSet: Set<UITouch>!
    
    var rightMovement: Bool = true
    //var fast: Bool = false
    var distance: Double = 0.0
    var stop = 0
    //var basePos: CGPoint!
    //var xDistance: CGFloat!
    //var yDistance: CGFloat!
    //var angle: CGFloat!
   // let ball: SKShapeNode!
    
    
    
    
    weak var player: Player?
    
    init(with player: Player) {
        self.player = player
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        
      movePlayer()
        
    }
    
    func movePlayer (){
        
        
    


        
    }

    
    override func update(deltaTime seconds: TimeInterval) {
       
        player?.component(ofType: MovementComponent.self)?.distance = self.distance
        player?.component(ofType: MovementComponent.self)?.rightMovement = self.rightMovement
        
        player?.component(ofType: MovementComponent.self)?.movement()

        if self.stop == 1
        {
            if !(player?.checkTextureForInitialFrame())!
            {
                player?.stateMachine.enter(StoppedState.self)
                self.player?.animationEnded = 1
                //self.player?.runEnded = 1
                self.player?.jumpFinished = 1
            }
            
        }
    }
    
    
    
    override func willExit(to nextState: GKState) {
        
    }
    
    
}
