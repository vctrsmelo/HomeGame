//
//  Level1Scene.swift
//  HomeGame
//
//  Created by Douglas Gehring on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit
import GameplayKit

class Level1Scene: SKScene , SKPhysicsContactDelegate{

    var scenarioObjects:[ScenarioObjects]!
    var characterNodes:[CharacterNode]!
    
    //model attributes
    var player: Player! = nil
    
    //player control interface
    let base = SKShapeNode.init(circleOfRadius: 50)
    let ball = SKShapeNode.init(circleOfRadius: 40)
    
    //controller attributes
    var longTap: UILongPressGestureRecognizer!
    var tap: UITapGestureRecognizer!
    var stop = false
    var tolerance: Float =  5
    var joystickTouch: UITouch!
    
    //movement attributes
    var rightMov = true
    var xGreaterThanLenght = false
    var yGreaterThanLenght = false
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
    
        self.physicsWorld.contactDelegate = self
        
        self.initScenarioElements()
        self.initCharacterNodes()
        self.initControllerInterface()
        
    }
    
    
    func initScenarioElements(){
        
        /* Initializing scenario elements with the name identifier for each one*/
        
    }
    
    func initCharacterNodes(){
        
        /* Initializing characters nodes with the name identifier for each one*/
        player = Player()
        self.addChild(player.mainPlayerSprite)
        player.mainPlayerSprite.zPosition = 1
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
     
        
        var playerColision = false
        
        var playerNode:SKNode!
        
        var obstacleNode:SKNode!
        
        if let name = contact.bodyA.node?.name{
            
            playerNode = contact.bodyA.node
            obstacleNode = contact.bodyB.node
            
            playerColision = true

        }
        else if let name = contact.bodyB.node?.name{
            
            playerNode = contact.bodyB.node
            obstacleNode = contact.bodyA.node
        
            playerColision = true
        }
        
        
        
        if(playerColision){
            
            if(obstacleNode.physicsBody?.contactTestBitMask == 1){
                
                // Chao escorrega
                
                print("Chao escorrega")
            }
            else if(obstacleNode.physicsBody?.contactTestBitMask == 2){
                
                print("Agua morre")
                
                // Agua - morre
                // ou
                // Ice cub - morre
            }
            
        }
        
    }
    

    
    func initControllerInterface(){
        
        ball.fillColor = .brown
        base.fillColor = .cyan
        ball.zPosition = 1
        base.zPosition = 1

        
    }
    
    //controller methods
    func longTapped (){
        print("Long tapped")
        if longTap.state == .began {
            
            let location = self.longTap.location(in: self.view)
            base.position = self.convert(location, to: self)
            base.isHidden = false
            ball.isHidden = false
            
            ball.position = base.position
            
            ball.fillColor = .brown
            
            addChild(base)
            addChild(ball)
        }
        
        if longTap.state == .ended {
            
            
            base.isHidden = true
            ball.isHidden = true
            
            base.removeFromParent()
            ball.removeFromParent()
            
        }
        
        
        
    }
    
    func tapped(sender: UITapGestureRecognizer){
        
        player?.stateMachine.state(forClass: JumpingState.self)?.rightMovement = self.rightMov
        
        player.changeState(stateClass: JumpingState.self)
        ///self.stop = true
        //player.jump()
        print("tapped")
        
        //player.changeState(stateClass: StoppedState.self)
    }
    
    func seeIfItWasTapped(touches:Set<UITouch> ) -> Bool{
        
        let firstTouch = touches.first!
        
        let lastTouch = touches[touches.index(touches.startIndex, offsetBy: touches.count-1)]
        
        if abs (lastTouch.location(in: self).x) - abs(firstTouch.location(in: self).x) > CGFloat (tolerance)
        {
            return false
        }
        
        if abs (lastTouch.location(in: self).y) - abs(firstTouch.location(in: self).y) > CGFloat (tolerance)
        {
            
            return false
        }
        
        return true
        
    }

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        print("began")
    
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        player?.stateMachine.state(forClass: MovingState.self)?.stop = 1
        ball.removeFromParent()
        base.removeFromParent()
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        player?.stateMachine.enter(StoppedState.self)
        ball.position = base.position
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        player?.stateMachine.enter(MovingState.self)
        player?.stateMachine.state(forClass: MovingState.self)?.stop = 0
        
        if !self.children.contains(base){
            addChild(base)
            addChild(ball)
            
            base.position = (touches.first?.location(in: self))!
            ball.position = (touches.first?.location(in: self))!
            
        }

        
        for touch in touches
        {
    
            let location = touch.location(in: self)
            let vector  = CGVector(dx: location.x - base.position.x, dy: location.y - base.position.y)
            var angle = atan2(vector.dx, vector.dy)
            
            let degree = GLKMathRadiansToDegrees(Float(angle))
            
            let lenght: CGFloat = 40
            
            var xDist: CGFloat! // = sin(angle) * lenght
            var yDist: CGFloat! // = cos(angle) * lenght
            
            
            print(degree + 180)
            if abs(location.x - base.position.x) <= lenght
            {
                xDist = abs(location.x - base.position.x)
                self.xGreaterThanLenght = false
                
            }
            else{
                if location.x < base.position.x {
                    xDist = -lenght
                    
                }
                else
                {
                    xDist = lenght
                }
                
                self.xGreaterThanLenght = true
            }
            
            if abs(location.y - base.position.y) <= lenght
            {
                yDist = abs(location.y - base.position.y)
                self.yGreaterThanLenght = false
                
            }
            else{
                self.yGreaterThanLenght = true
                
                if location.y > base.position.y{
                    yDist = lenght
                }
                else {
                    yDist = -lenght
                }
                
            }
            if angle == 0 {
                
                player?.stateMachine.state(forClass: MovingState.self)?.stop = 1
                
            }
            else{
                
                
                
                if sin(angle) > 0 { //moving to the right
                    self.rightMov = true
                    
                }
                else{ //moving to the left
                    self.rightMov = false
                    
                    if !self.xGreaterThanLenght{
                        xDist = -xDist
                    }
                    
                }
                
                
                if cos(angle) <  0{
                    if !self.yGreaterThanLenght{
                        yDist = -yDist
                    }
                }
                ball.position = CGPoint(x: base.position.x + xDist, y:  base.position.y + yDist)
                
            }
            
            
        }
    }

    
    override func update(_ currentTime: TimeInterval) {
        
        
        
        if (self.children .contains(base)){
            
            if abs (ball.position.x - base.position.x) > 3 { //&& self.player?.stateMachine.currentState is StoppedState{
                self.player?.stateMachine.enter(MovingState.self)
                player?.stateMachine.state(forClass: MovingState.self)?.stop = 0
                
                if abs(ball.position.x - base.position.x) >= 40{
                    player?.stateMachine.state(forClass: MovingState.self)?.fast = true
                    
                    if ball.position.x > base.position.x{
                        self.rightMov = true
                        player?.stateMachine.state(forClass: MovingState.self)?.rightMovement = true
                        
                    }
                    else{
                        self.rightMov = false
                        player?.stateMachine.state(forClass: MovingState.self)?.rightMovement = false
                        
                    }
                    
                }
                else{
                    player?.stateMachine.state(forClass: MovingState.self)?.fast = false
                    
                    if ball.position.x > base.position.x {
                        self.rightMov = true
                        player?.stateMachine.state(forClass: MovingState.self)?.rightMovement = true
                        
                    }
                    else{
                        self.rightMov = false
                        player?.stateMachine.state(forClass: MovingState.self)?.rightMovement = false
                        
                    }
                    
                }
                
            }
                
            else{
                
                
                player?.stateMachine.state(forClass: MovingState.self)?.stop = 1
                
                
            }
        }
        
        player.update(deltaTime: currentTime)
 
    }
 
   
}
