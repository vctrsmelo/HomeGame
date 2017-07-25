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
    var rightMovement: Bool!
    //var fast: Bool!
    var distance: Double = 0.0
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
//        self.entity = Player()

    }
    
    // TODO
//    func moveAnimate(swipeDir: UISwipeGestureRecognizerDirection, inputFirstTouch: UITouch, inputLastTouch: UITouch) {
//        let lastTouchView = inputLastTouch.view!
//        let firstTouchView = inputFirstTouch.view!
//        
//        var distance : CGFloat!
//        if lastTouchView.isEqual(firstTouchView) {
//            if(swipeDir == .right){
//                
//                // só funciona no lado positivo? usar modulo!
//                distance = inputLastTouch.location(in: lastTouchView).x - inputFirstTouch.location(in: firstTouchView).x
//                
//                if distance > 10 {
//                //    player.run()
//                }
//                else {
//                //    player.walk()
//                }
//                
//            }
//            else if (swipeDir == .left){
//                
//                // só funciona no lado positivo? usar modulo!
//                distance = inputLastTouch.location(in: lastTouchView).x - inputFirstTouch.location(in: firstTouchView).x
//                
//                if distance > 10 {
//               //     player.run()
//                }
//                else {
//              //      player.walk()
//                }
//
//            }
//        }
//        
//        
//        
//    }
//    
    
    func movement (){
        let duration = distance * -0.002 + 0.494
        
        
        if rightMovement  {
            player.walk(positionDirection: .right, duration: duration)

        }
        else{
            player.walk(positionDirection: .left, duration: duration)
     
        }
    }
    
    
}
