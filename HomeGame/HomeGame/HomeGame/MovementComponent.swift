//
//  MovementComponent.swift
//  HomeGame
//
//  Created by Bharbara Cechin on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit
import GameplayKit

// Move Component for moving components (like the mains character)
// Can be used for moving and running, using state machines
class MovementComponent: GKComponent {
    
    var player: Player {
        return self.entity as! Player
    }

    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
//        self.entity = Player()

    }
    
    // TODO
    func moveAnimate(swipeDir: UISwipeGestureRecognizerDirection, inputFirstTouch: UITouch, inputLastTouch: UITouch) {
        let lastTouchView = inputLastTouch.view!
        let firstTouchView = inputFirstTouch.view!
        
        var distance : CGFloat!
        if lastTouchView.isEqual(firstTouchView) {
            if(swipeDir == .right){
                
                // só funciona no lado positivo? usar modulo!
                distance = inputLastTouch.location(in: lastTouchView).x - inputFirstTouch.location(in: firstTouchView).x
                
                if distance > 10 {
                    // call run animate com direita
                }
                else {
                    // call move animate com direita
                }
                
            }
            else if (swipeDir == .left){
                
                // só funciona no lado positivo? usar modulo!
                distance = inputLastTouch.location(in: lastTouchView).x - inputFirstTouch.location(in: firstTouchView).x
                
                if distance > 10 {
                    // call run animate com esquerda
                }
                else {
                    // call move animate com esquerda
                }

            }
        }
        
    }
}
