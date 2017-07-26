//
//  Level1Scene.swift
//  HomeGame
//
//  Created by Douglas Gehring on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit
import GameplayKit
import AudioToolbox
class Level1Scene: SKScene , SKPhysicsContactDelegate, UIGestureRecognizerDelegate{
    
    var scenarioObjects:[ScenarioObjects]!
    var characterNodes:[CharacterNode]!
    
    //model attributes
    var player: Player! = nil
    
    //player control interface
    let base: SKShapeNode = SKShapeNode(circleOfRadius: 50)
    let ball: SKShapeNode = SKShapeNode(circleOfRadius: 40)
    
    //controller attributes
    var tap: UITapGestureRecognizer!
    var stop = false
    var tolerance: Float =  5
    var joystickGesture: UIGestureRecognizer!
    var longPressSetted = false
    
    
    //water
    var waterNode1: SBDynamicWaterNode!
    var waterNode1Size: CGSize!
    var waterNode2: SBDynamicWaterNode!
    var waterNode2Size: CGSize!
    var waterNode3: SBDynamicWaterNode!
    var waterNode3Size: CGSize!
    let kFixedTimeStep: Double = Double(1.0/500)
    let kSurfaceHeight: Double = 235
    var splashWidth: Int!
    var splashForceMultiplier: Double!
    let WATER_COLOR = SKColor.blue
    var hasReferenceFrameTime = false
    var lastFrameTime: TimeInterval!
    
    var tapLocation: CGPoint!
    
    var longPressLocation: CGPoint!
    
    //movement attributes
    var rightMov = true
    var xGreaterThanLenght = false
    var yGreaterThanLenght = false
    
    var endGameReached = false
    
    
    
    // Camera manager integration
    
    
    var cameraManager:CameraManager!
    
    override func sceneDidLoad() {
        
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        return true

    }
    
    override func didMove(to view: SKView) {
        
        
        
        super.didMove(to: view)
        
        
        
        //let credits = SKScene(fileNamed: "CreditsScene")
       // self.view?.presentScene(credits)
        
        self.physicsWorld.contactDelegate = self
        
        
        self.setCameraConfigurations()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(gesture:)))
        longPressRecognizer.delegate = self
        longPressRecognizer.numberOfTouchesRequired = 1
        self.view?.addGestureRecognizer(longPressRecognizer)
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gesture:)))
        tapRecognizer.delegate = self
        self.view?.addGestureRecognizer(tapRecognizer)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(gesture:)))
        panRecognizer.delegate = self
        panRecognizer.maximumNumberOfTouches = 1
        self.view?.addGestureRecognizer(panRecognizer)
        
        self.initScenarioElements()
        self.initCharacterNodes()
        self.initControllerInterface()
        
        if let view = self.view {
            view.isMultipleTouchEnabled = true
        }
        
        
        
        if let water1 = self.childNode(withName: "//water1") as? SKSpriteNode {
            self.waterNode1 = SBDynamicWaterNode.init(width: Float(water1.size.width), numJoints: 100, surfaceHeight: Float(water1.size.height), fillColour: water1.color)
            self.waterNode1Size = water1.size
            self.waterNode1.position = CGPoint(x: water1.position.x, y: water1.position.y-water1.size.height/2)
            self.waterNode1.physicsBody = SKPhysicsBody(rectangleOf:CGSize(width: water1.size.width, height: 1))
            self.waterNode1.zPosition = water1.zPosition
            self.waterNode1.alpha = water1.alpha
            
            self.waterNode1.physicsBody?.collisionBitMask = 1
            self.waterNode1.physicsBody?.contactTestBitMask = 1
            self.waterNode1.physicsBody?.categoryBitMask = 1
            self.waterNode1.physicsBody?.isDynamic = true
            
            self.waterNode1.name = "water1"
            
            self.waterNode1.physicsBody?.affectedByGravity = false
            self.waterNode1.physicsBody?.pinned = true
            self.waterNode1.physicsBody?.allowsRotation = false
            
            self.removeChildren(in: [water1])
            self.addChild(waterNode1)
            
        }
        
        if let water2 = self.childNode(withName: "//water2") as? SKSpriteNode {
            self.waterNode2 = SBDynamicWaterNode.init(width: Float(water2.size.width), numJoints: 100, surfaceHeight: Float(water2.size.height), fillColour: water2.color)
            self.waterNode2Size = water2.size
            self.waterNode2.position = CGPoint(x: water2.position.x, y: water2.position.y-water2.size.height/2)
            self.waterNode2.physicsBody = SKPhysicsBody(rectangleOf:CGSize(width: water2.size.width, height: 1))
            self.waterNode2.zPosition = water2.zPosition
            self.waterNode2.alpha = water2.alpha
            
            self.waterNode2.physicsBody?.collisionBitMask = 1
            self.waterNode2.physicsBody?.contactTestBitMask = 1
            self.waterNode2.physicsBody?.categoryBitMask = 1
            self.waterNode2.physicsBody?.isDynamic = true
            
            self.waterNode2.name = "water2"
            
            self.waterNode2.physicsBody?.affectedByGravity = false
            self.waterNode2.physicsBody?.pinned = true
            self.waterNode2.physicsBody?.allowsRotation = false
            

            self.removeChildren(in: [water2])
            self.addChild(waterNode2)
            
        }
        
        if let water3 = self.childNode(withName: "//water3") as? SKSpriteNode {
            self.waterNode3 = SBDynamicWaterNode.init(width: Float(water3.size.width), numJoints: 100, surfaceHeight: Float(water3.size.height), fillColour: water3.color)
            self.waterNode3Size = water3.size
            self.waterNode3.position = CGPoint(x: water3.position.x, y: water3.position.y-water3.size.height/2)
            self.waterNode3.physicsBody = SKPhysicsBody(rectangleOf:CGSize(width: water3.size.width, height: 1))
            self.waterNode3.zPosition = water3.zPosition
            self.waterNode3.alpha = water3.alpha
            
            self.waterNode3.physicsBody?.collisionBitMask = 1
            self.waterNode3.physicsBody?.contactTestBitMask = 1
            self.waterNode3.physicsBody?.categoryBitMask = 1
            self.waterNode3.physicsBody?.isDynamic = true
            
            self.waterNode3.name = "water3"
            
            self.waterNode3.physicsBody?.affectedByGravity = false
            self.waterNode3.physicsBody?.pinned = true
            self.waterNode3.physicsBody?.allowsRotation = false
            
            self.removeChildren(in: [water3])
            self.addChild(waterNode3)
            
        }

        self.setDefaultWaterValues() //water
        

    }
    
    
    func fixedWaterUpdate(_ dt:TimeInterval){
        
        self.waterNode1.update(dt)
        
        let location = Float(0.0) //Float(self.waterNode1.frame.size.width)
        
        if self.player.isAboveWater && self.player.mainPlayerSprite.position.y < self.waterNode1.position.y+CGFloat(self.waterNode1.surfaceHeight){
            print("player X: \(self.player.mainPlayerSprite.position.x) Y: \(self.player.mainPlayerSprite.position.y)")
            print("water X: \(self.waterNode1.position.x) Y: \(self.waterNode1.position.y)")

            let waterMinX = self.waterNode1.position.x-self.waterNode1Size.width/2.0
            self.player.isAboveWater = false
            
            self.waterNode1.splashAt(x: Float(abs(self.player.mainPlayerSprite.position.x-waterMinX)), force: 20, width: 20)
            
        }
        
        
        
    }
    
    func lateWaterUpdate(_ dt: CFTimeInterval){
        
        self.waterNode1.render()
        
    }
    
    func setDefaultWaterValues(){
        
        self.splashWidth = 20
        self.splashForceMultiplier = 0.125
        self.waterNode1?.setDefaultValues()
        self.waterNode2?.setDefaultValues()
        self.waterNode3?.setDefaultValues()
        
    }


    
    func setCameraConfigurations(){
        
        self.cameraManager = CameraManager(viewWidth: (self.view?.frame.width)!)
        
        addChild(self.cameraManager.cameraNode)
        
        camera = self.cameraManager.cameraNode
        
        
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
    
    
    func fallObj (obj: SKNode){
       
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate) //treme
            let wait = SKAction.wait(forDuration: 1) //esperea 1 sec
            let fall = SKAction.move(to: CGPoint(x: obj.position.x, y: -200), duration: 2) //cai
            let sequence = SKAction.sequence([wait, fall])
            obj.run(sequence, completion: { 
                  obj.removeFromParent()
            })
          
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        var playerColision = false
        
        var playerNode:SKNode!
        
        var obstacleNode:SKNode!
        
        if let name = contact.bodyA.node?.name{
            if name == "Player" {
            
                playerNode = contact.bodyA.node
                obstacleNode = contact.bodyB.node
                playerColision = true
            
            }
            
        }
        else if let name = contact.bodyB.node?.name{
            if name == "Player"{
                playerNode = contact.bodyB.node
                obstacleNode = contact.bodyA.node
                playerColision = true
            }
        }
        
        
        
        if(playerColision){
            
            if(obstacleNode.physicsBody?.contactTestBitMask == 1){
                
                // Chao escorrega
                
            }
            else if(obstacleNode.physicsBody?.contactTestBitMask == 2){
                
                // Agua - morre
                // ou
                // Ice cub - morre
            }
            else if(obstacleNode.physicsBody?.contactTestBitMask == 3){
                
                if ( obstacleNode.position.y  < playerNode.position.y  && playerNode.position.x  > obstacleNode.position.x - obstacleNode.frame.size.width/2 && playerNode.position.x < obstacleNode.position.x + obstacleNode.frame.size.width/2){
                    
                    self.obstacleAnimation(obstacle: obstacleNode)
                    
                }
            }
                
            else if (obstacleNode.physicsBody?.contactTestBitMask == 4){
                
                
                player?.stateMachine.enter(PlayerWonState.self)
                print("morreu")
                
            }
            else if(obstacleNode.physicsBody?.contactTestBitMask == 5){
                // end game ground touched
                
                
                endGameReached = true
                
                print("end game")
                
                
            }

            
        }
        
    }
    
    
    
    func obstacleAnimation(obstacle: SKNode){
        //let wait = SKAction.wait(forDuration: 1.0)
        let rot1 = SKAction.rotate(byAngle: -CGFloat(GLKMathDegreesToRadians(1)), duration: 0.1)
        let rot2 = rot1.reversed()
        let rot3 = SKAction.rotate(byAngle: CGFloat(GLKMathDegreesToRadians(1)), duration: 0.1)
        let rot4 = rot3.reversed()
        var animationAction = Array<SKAction>()
        animationAction.append(rot1)
        animationAction.append(rot2)
        animationAction.append(rot3)
        animationAction.append(rot4)
        
        let fallAction: SKAction = SKAction.move(to: CGPoint(x: obstacle.position.x, y:-200), duration:1.0)
        let animationFull = SKAction.sequence(animationAction)
        let rotateAnimFull = SKAction.repeat(animationFull, count: 3)
        let animWithFall = SKAction.sequence([rotateAnimFull, fallAction])
        
        obstacle.run(animWithFall)
        
    }
    
    
    
    
    func initControllerInterface(){
        
        ball.fillColor = .brown
        base.fillColor = .cyan
        ball.zPosition = 1
        base.zPosition = 1
        
        ball.isHidden = true
        base.isHidden = true
        
        ball.position = base.position
        
        self.addChild(base)
        self.addChild(ball)
        
        
    }
    
    func handleTap(gesture: UITapGestureRecognizer){
        
        
        if(!endGameReached){
            
            player?.stateMachine.state(forClass: JumpingState.self)?.rightMovement = self.rightMov
            
            tapLocation = gesture.location(in: self.view)
            
            player.changeState(stateClass: JumpingState.self)
            
            if(self.rightMov){
                
                self.cameraManager.setRightSideCameraConfiguration()
            }
            else{
                
                self.cameraManager.setLeftSideCameraConfigurations(node: self.player.mainPlayerSprite)
            }
            
            if childNode(withName: "fallObj") != nil{
                self.fallObj(obj: self.childNode(withName: "fallObj")!)
            }
            
        }
        
        
    }
    
    //controller methodss
    public func handleLongPress (gesture: UILongPressGestureRecognizer){

        
        if(!endGameReached){
            
            
            if longPressSetted{
                return
            }
            
            
            let position = gesture.location(in: self.view!)
            self.longPressLocation = self.convertPoint(fromView: position)
            if gesture.state == .began{
                base.position = self.convertPoint(fromView: position)
                ball.position = base.position
                base.isHidden = false
                ball.isHidden = false
                
            }
            
            if gesture.state == .ended || gesture.state == .cancelled{
                
                base.isHidden = true
                ball.isHidden = true
                
                ball.position = base.position
                player?.stateMachine.state(forClass: MovingState.self)?.stop = 1
                return
                
            }
            
            
        }
        
    }
    
    
    public func handlePan(gesture: UIPanGestureRecognizer){

        if(!endGameReached){
            
            
            let position = gesture.location(in: self.view!)
            
            self.longPressLocation = self.convertPoint(fromView: position)
            
            if gesture.state == .began{
                
                base.position = self.convertPoint(fromView: position)
                
                
                ball.position = base.position
                base.isHidden = false
                ball.isHidden = false
                
            }
            
            if gesture.state == .ended || gesture.state == .cancelled{
                
                base.isHidden = true
                ball.isHidden = true
                
                ball.position = base.position
                player?.stateMachine.state(forClass: MovingState.self)?.stop = 1
                return
                
            }
            
            setJoystickPosition(to: self.convertPoint(fromView: position))
            
        
            
        }
        
    }
    
    
    private func setJoystickPosition(to location : CGPoint){
        
        let vector  = CGVector(dx: location.x - base.position.x, dy: location.y - base.position.y)
        let angle = atan2(vector.dx, vector.dy)
        
        //let degree = GLKMathRadiansToDegrees(Float(angle))
        
        let LENGHT: CGFloat = 40
        
        var xDist: CGFloat! // = sin(angle) * lenght
        var yDist: CGFloat! // = cos(angle) * lenght
        
        if abs(location.x - base.position.x) <= LENGHT
        {
            xDist = abs(location.x - base.position.x)
            self.xGreaterThanLenght = false
            
        }
        else{
            if location.x < base.position.x {
                xDist = -LENGHT
            }
            else
            {
                xDist = LENGHT
            }
            
            self.xGreaterThanLenght = true
        }
        
        if abs(location.y - base.position.y) <= LENGHT
        {
            yDist = abs(location.y - base.position.y)
            self.yGreaterThanLenght = false
            
        }
        else{
            self.yGreaterThanLenght = true
            
            if location.y > base.position.y{
                yDist = LENGHT
            }
            else {
                yDist = -LENGHT
            }
            
        }
        if angle == 0 && !(self.player?.stateMachine.currentState is JumpingState){
            
            player?.stateMachine.state(forClass: MovingState.self)?.stop = 1
            
        }
        else{



            if sin(angle) > 0{
                self.rightMov = true
                
                self.cameraManager.setRightSideCameraConfiguration()

            }
            else{
                self.rightMov = false
                
                self.cameraManager.setLeftSideCameraConfigurations(node: player.mainPlayerSprite)
                
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
    
    override func update(_ currentTime: TimeInterval) {
        
        let DISTANCE: Double = 150
        
        if (!base.isHidden && !(self.player?.stateMachine.currentState is JumpingState)){
            
            if abs (ball.position.x - base.position.x) > 3 { //&& self.player?.stateMachine.currentState is StoppedState{
               
                    
                self.player?.stateMachine.enter(MovingState.self)
                player?.stateMachine.state(forClass: MovingState.self)?.stop = 0
                
                
                if abs (longPressLocation.x - base.position.x) >= CGFloat (DISTANCE){
                    //if abs(ball.position.x - base.position.x) >= 40{
                    
                    player?.stateMachine.state(forClass: MovingState.self)?.distance = DISTANCE
                    
                    //player?.stateMachine.state(forClass: MovingState.self)?.fast = true
                    
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
                    //player?.stateMachine.state(forClass: MovingState.self)?.fast = false
                    player?.stateMachine.state(forClass: MovingState.self)?.distance = abs (Double(longPressLocation.x - base.position.x))
                    
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
                
            else if !(self.player?.stateMachine.currentState is JumpingState){

                player?.stateMachine.state(forClass: MovingState.self)?.stop = 1
                
                
            }
            
        }
        
        player.update(deltaTime: currentTime)
        
        self.cameraManager.checkCameraPositionAndPerformMovement(node: player.mainPlayerSprite)
        
        
        if(endGameReached){
            
            player.performEndGameAnimation()
            
        }
        
 
        //Water
        if !self.hasReferenceFrameTime{
            self.lastFrameTime = currentTime
            self.hasReferenceFrameTime = true
            return
        }
        let dt: TimeInterval = currentTime-self.lastFrameTime
        
        // Fixed Update
        var accumulator: TimeInterval = 0;
        accumulator += dt;
        
        while (accumulator >= kFixedTimeStep) {
            self.fixedWaterUpdate(kFixedTimeStep)
            accumulator -= kFixedTimeStep
        }
        
        self.lateWaterUpdate(dt)
        self.lastFrameTime = currentTime
        
    }
    
    
}
