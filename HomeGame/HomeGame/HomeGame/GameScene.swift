//
//  GameScene.swift
//  HomeGame
//
//  Created by Victor S Melo on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player: Player!
    var GameStateMachine: GKStateMachine!
    var gesture: UISwipeGestureRecognizer!
    
    let base = SKSpriteNode.init(color: .cyan, size: CGSize(width: 100, height: 100))
    let ball = SKShapeNode.init(circleOfRadius: 40)
    
    
    var xDistance: CGFloat!
    var yDistance: CGFloat!
    var angle: CGFloat!
    
    
    
    //DOUGLAS
    var stop = false
    

    
    override func didMove(to view: SKView) {
        
        
        
        addChild(base)
        base.position = CGPoint(x: 0, y: 0)
        
        addChild(ball)
        ball.position = base.position
        
        ball.fillColor = .brown
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector
            (self.tapped(sender:)))
        
        view.addGestureRecognizer(tap)
        
    
    self.player =  Player()
    addChild(player.nodeTest)
    addChild(player.mainPlayerSprite)
        
        let playingState = PlayingState()
        let waitingState = WaitingState()
        self.GameStateMachine = GKStateMachine(states: [playingState, waitingState])
        self.GameStateMachine.enter(PlayingState.self)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        player?.stateMachine.enter(StoppedState.self)
        print ("touches endeed")
        ball.position = base.position
    }
    
    func tapped(sender: UITapGestureRecognizer){
        player.changeState(stateClass: JumpingState.self)
        ///self.stop = true
        //player.jump()
        print("tapped")
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        
        
        if angle != nil && xDistance != nil && yDistance != nil {
            //ball.position = CGPoint(x: basePos.x + xDistance, y:  basePos.y + yDistance)
           // ball.position = CGPoint(x: base.position.x + xDistance, y:  base.position.y + yDistance)
        }
        
        player.update(deltaTime: currentTime)
        
       
        
        // Called before each frame is rendered
        
        //if gesture != nil {
       // if gesture.state == UIGestureRecognizerState.ended {
         //   print("swipe ended")
           // NSLog(String (describing: gesture.direction))
        
        
    //}
      //  }
        
        
    }
    
    
    
    

    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        
        //if player?.stateMachine.currentState is JumpingState
       // {
            print ("canceled")
            player?.stateMachine.enter(StoppedState.self)
        //}
        
        
        
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
      //player?.stateMachine.enter(MovingState.self)
        
        
        for touch in touches
        {
            let location = touch.location(in: self)
            let vector  = CGVector(dx: location.x - base.position.x, dy: location.y - base.position.y)
            let angle = atan2(vector.dx, vector.dy)
            
            let degree = GLKMathRadiansToDegrees(Float(angle))
            
            let lenght: CGFloat = 40
            
            
            var xDist: CGFloat! // = sin(angle) * lenght
            var yDist: CGFloat! // = cos(angle) * lenght
            
            
            print(degree + 180)
            
            if abs(location.x) - base.position.x <= 40
            {
                xDist = location.x
                
            }
            else{
                player?.stateMachine.state(forClass: MovingState.self)?.fast = true
                
                if ( sin(angle)  < 0 ){
                    
                    //if (angle < 0) {
                    //xDist = sin(angle) * lenght
                    xDist = -40
                }
                else {
                    
                    xDist = 40
                }
                
            }
            
            if abs(location.y) - base.position.y <= 40
            {
                yDist = location.y
                
            }
            else{
                
                if (cos(angle) < 0){
                    
                    yDist = -40
                }
                else{
                    yDist = 40
                }
                
                
                //yDist = cos(angle) * lenght
            }
            
            
            ball.position = CGPoint(x: base.position.x + xDist, y:  base.position.y + yDist)
            
            
           // let deltaX: CGFloat = sin(angle) * 5
           // let deltaY: CGFloat = cos(angle) * 5
            if sin(angle) > 0 {
                player?.stateMachine.state(forClass: MovingState.self)?.rightMovement = true
            }
            
            
            
            // print(deltaY)
            // print(deltaX)
            
          //  player?.nodeTest.position = CGPoint(x:(player?.nodeTest.position.x)! + deltaX,y: (player?.nodeTest.position.y)! + deltaY)
            
            
            
            
        }

        //player?.stateMachine.enter(MovingState.self)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        player?.stateMachine.enter(MovingState.self)

        
        
    }
    
    
}
