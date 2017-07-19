//
//  GameScene.swift
//  HomeGame
//
//  Created by Victor S Melo on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var player: Player!
    var GameStateMachine: GKStateMachine!
    var gesture: UISwipeGestureRecognizer!
    
    let base = SKSpriteNode.init(color: .cyan, size: CGSize(width: 100, height: 100))
    let ball = SKShapeNode.init(circleOfRadius: 40)
    
    
    var xDistance: CGFloat!
    var yDistance: CGFloat!
    var angle: CGFloat!
    var tolerance: Float =  5
    
    var longTap: UILongPressGestureRecognizer!
    var tap: UITapGestureRecognizer!
    var stop = false
    
    var fatalElements = ["ice_cub, water"]
    var rightMov = false
    var rightMov = true
    var xGreaterThanLenght = false
    var yGreaterThanLenght = false
    
    var bGround  = SKSpriteNode()
    var back2 = SKSpriteNode()
    
    var sceneObjects:[ScenarioObjects] = []
    

    
    override func didMove(to view: SKView) {
        
        
    
        
        
        
        
        bGround = SKSpriteNode.init(imageNamed: "ground")
        back2 = SKSpriteNode.init(imageNamed: "ground")
        bGround.position = CGPoint.zero
        back2.position = CGPoint(x: self.frame.width, y: 0)
        
        self.getScenarioElements()
        
        addChild(back2)
        addChild(bGround)
        
        
        
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector
            (self.tapped(sender:)))
        self.tap = Tap
        tap.delaysTouchesBegan = true
        view.addGestureRecognizer(Tap)
        
        
        self.player =  Player()
        //addChild(player.nodeTest)
        addChild(player.mainPlayerSprite)
        
        let playingState = PlayingState()
        let waitingState = WaitingState()
        self.GameStateMachine = GKStateMachine(states: [playingState, waitingState])
        self.GameStateMachine.enter(PlayingState.self)
        
        
//        let longTap:UILongPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(self.longTapped))
//        longTap.delegate = self as? UIGestureRecognizerDelegate
//        longTap.minimumPressDuration = 1
//        view.addGestureRecognizer(longTap)
//        
//        self.longTap = longTap
//        addChild(base)
//        addChild(ball)
        ball.fillColor = .brown
        ball.zPosition = 1
        base.zPosition = 1
        player.mainPlayerSprite.zPosition = 1
        
    }
    
   func longTapped (){
    
    
    
    print("long tappeeeeeed")
    
    if longTap.state == .began {
    print("bega")
   
  var location = self.longTap.location(in: self.view)
//    
//   // location.
//    location.x = location.x - (view?.frame.size.width)!/2 + 0.5
//    
//    if (location.y <  (view?.frame.size.height)!/2 )
//    {
//        
//        location.y = abs (location.y - (view?.frame.size.height)!/2) + 0.5
//        
//    }
//    else{
//        location.y = location.y - (view?.frame.size.height)!/2 + 0.5
//        
//    }
//    
//    base.position = location
   // base.convert(location, to: self)
    
    let posititi =  self.convert(location, to: self)
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
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player?.stateMachine.state(forClass: MovingState.self)?.stop = 1
       // player?.stateMachine.enter(StoppedState.self)
        print ("touches endeed")
        ball.removeFromParent()
        base.removeFromParent()
        
    }
    
    func tapped(sender: UITapGestureRecognizer){
        
        player?.stateMachine.state(forClass: JumpingState.self)?.rightMovement = self.rightMov
        
        player.changeState(stateClass: JumpingState.self)
        ///self.stop = true
        //player.jump()
        print("tapped")
        
        player.changeState(stateClass: StoppedState.self)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if !(player.stateMachine.currentState is StoppedState){
            if (player?.mainPlayerSprite.position.x)! > (view?.frame.size.width)!/4 ||
                (player?.mainPlayerSprite.position.x)! < -(view?.frame.size.width)!/4{
                bGround.position.x -= 1
                back2.position.x -= 1
                
                player?.positionToWalk.x = 0
                
                
                if bGround.position.x < -self.frame.size.width{
                    
                    bGround.position.x  = abs (bGround.position.x)
                    
                }
                if back2.position.x < -self.frame.size.width{
                    
                    back2.position.x  = abs (back2.position.x)
                }
                
            }
            
            
        
        
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
    
    
    
    

    func didBegin(_ contact: SKPhysicsContact) {

        print("Morreu - Volte ao inicio")
        self.player.resetPlayerPosition()
        
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //
        //if player?.stateMachine.currentState is JumpingState
        // {
        print ("canceled")
        player?.stateMachine.enter(StoppedState.self)
        //}
        
        ball.position =  base.position
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        player?.stateMachine.enter(MovingState.self)
        player?.stateMachine.state(forClass: MovingState.self)?.stop = 0
        
        print("touches moved")
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
            if abs(location.x - base.position.x) <= lenght
            {
                //xDist = location.x - base.position.x
                xDist = abs(location.x - base.position.x)
                player?.stateMachine.state(forClass: MovingState.self)?.fast = false
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
                
                player?.stateMachine.state(forClass: MovingState.self)?.fast = true
                self.xGreaterThanLenght = true
                
                //if ( sin(angle)  < 0 ){
                    
                    //if (angle < 0) {
                    //xDist = sin(angle) * lenght
                //    xDist = -40
               // }
               // else {
                    
                //    xDist = 40
               // }
                
            }
            
            if abs(location.y - base.position.y) <= lenght
            {
                //yDist = location.y
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
//                
//                if (cos(angle) < 0){
//                    
//                    yDist = -40
//                }
//                else{
//                    yDist = 40
//                }
                
                
                //yDist = cos(angle) * lenght
            }
            if angle == 0 {
                
                player?.stateMachine.state(forClass: MovingState.self)?.stop = 1

            }
            else{
                
        
            
            if sin(angle) > 0 {
                player?.stateMachine.state(forClass: MovingState.self)?.rightMovement = true
                self.rightMov = true
                
            }
            else{
                player?.stateMachine.state(forClass: MovingState.self)?.rightMovement = false
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
                
            }
            ball.position = CGPoint(x: base.position.x + xDist, y:  base.position.y + yDist)

        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        player?.stateMachine.enter(MovingState.self)
        
        player?.stateMachine.state(forClass: MovingState.self)?.stop = 0
        
        
        addChild(base)
        addChild(ball)
       
        base.position = (touches.first?.location(in: self))!
        ball.position = (touches.first?.location(in: self))!
        
        
        print("base pos x = " + String (describing: base.position.x))
        print("ball pos x= " +  String(describing: ball.position.x))
        
        print("base pos y= " +  String(describing: ball.position.y))
        print("ball pos y= " +  String(describing: ball.position.y))

        
//        base.zPosition = 1
//        ball.zPosition = 1
//        
        
        
    }
    
    
    
    func seeIfItWasTapped(touches:Set<UITouch> ) -> Bool{
        
        
        
        
        let firstTouch = touches.first!
        let number = touches.endIndex
        
        let lastTouch = touches[touches.index(touches.startIndex, offsetBy: touches.count-1)]
        
        
        print(firstTouch.location(in: self).x)
        print(firstTouch.location(in: self).y)
        print(lastTouch.location(in: self).x)
        print(lastTouch.location(in: self).y)
        
        print("difer x =  " + String (describing: abs (lastTouch.location(in: self).x) - abs(firstTouch.location(in: self).x)))
        print("difer y = " + String (describing: abs (lastTouch.location(in: self).y) - abs(firstTouch.location(in: self).y)))
        
        
        if abs (lastTouch.location(in: self).x) - abs(firstTouch.location(in: self).x) > CGFloat (tolerance)
        {
            
            return false
        }
        if abs (lastTouch.location(in: self).y) - abs(firstTouch.location(in: self).y) > CGFloat (tolerance)
        {
            
            return false
        }
        
        
        return true
        
        //        for touch in touches {
        //
        //            if abs(Float (touch.location(in: self).x))  > abs(Float((firstTouch?.location(in: self).x)!)) + tolerance || abs(Float(touch.location(in: self).y))  > abs (Float ((firstTouch?.location(in: self).y)!)) + tolerance{
        //
        //                return false
        //            }
        //        }
        
        
        
    }
    
    func getScenarioElements(){
        
        for child in self.children{

            self.sceneObjects.append(ScenarioObjects(objectSprite: child as! SKSpriteNode,objectName: (child.name)!))
            
        }
    }
    
   
    
    
    
}
