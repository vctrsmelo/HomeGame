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
import AVFoundation

class Level1Scene: SKScene , SKPhysicsContactDelegate, UIGestureRecognizerDelegate{
    
    var playerLost = false
    
    var scenarioObjects:[ScenarioObjects]!
    var characterNodes:[CharacterNode]!
    
    // MARK: SOUNDS declaration
    var backgroundSound: SKAudioNode!
    
    //model attributes
    var player: Player! = nil
    
    var fallObjects: [SKNode] = []
    var fallenFinished = true
    var animationCompleted = [true, true, true, true, true]
    
    //player control interface
    let base: SKShapeNode = SKShapeNode(circleOfRadius: 50)
    let ball: SKShapeNode = SKShapeNode(circleOfRadius: 40)
    
    var oneTimeShootingStarAnimation = false
    
    //controller attributes
    var tap: UITapGestureRecognizer!
    var stop = false
    var tolerance: Float =  5
    var joystickGesture: UIGestureRecognizer!
    var longPressSetted = false
    
    // mother 
    
    var mother:BearMother!
    
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
    
    var firstTimeEnteredEndGame = true
    var firstEndedFirstAnimation = true
    
    var alreadyEnteredInCave = false
    
    var fog:[SKEmitterNode] = []
    
    
    var snow:SKEmitterNode!

    //Last animation manager
    var lastAnimationManager:LastAnimationManager!
    var shottingStar:SKEmitterNode!
    
    // Camera manager integration
    var cameraManager:CameraManager!
    
    var distanceJoystickFinger: Double!
    
    override func sceneDidLoad() {
        
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        return true

    }
    
    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        // MARK: SOUNDS INIT AND PLAY (ASYNCHRONOUS!!!! that's why we need another variable)
        let sound = SKAudioNode(fileNamed: "backgroundSound.wav")
        self.backgroundSound = sound
        self.addChild(sound)

        
        self.shottingStar = SKEmitterNode.init(fileNamed: "ShootingStar")
        self.shottingStar.position.x = 10400
        self.shottingStar.position.y = 300
        
        addChild(self.shottingStar)

       
        
        self.snow = SKEmitterNode.init(fileNamed: "snowParticle")
        self.snow.position.x = 8420
        self.snow.position.y = 200
        
        self.addChild(self.snow)
        
        
        
        self.fog.append(SKEmitterNode.init(fileNamed: "SmokeParticle")!)
        
        self.fog[0].position.x = 4450
        self.fog[0].position.y = 60
        self.fog[0].zPosition = 5

        
        self.fog.append(SKEmitterNode.init(fileNamed: "SmokeParticle")!)
        
        self.fog[1].position.x = 6341
        self.fog[1].position.y = 60
        self.fog[1].zPosition = 5
        
        //self.addChild(self.fog[0])
        //self.addChild(self.fog[1])
        
 
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
        
         self.lastAnimationManager = LastAnimationManager()
        

    }
    
    
    func fixedWaterUpdate(_ dt:TimeInterval){
        
        if (self.waterNode1) != nil {
            self.waterNode1.update(dt)
            let water1MinX = self.waterNode1.position.x-self.waterNode1Size.width/2.0
            let playerIsOverWater1 = (self.player.mainPlayerSprite.position.x <= (water1MinX + self.waterNode1Size.width) && (self.player.mainPlayerSprite.position.x - water1MinX) > 0) ? true : false
            
            if playerIsOverWater1 && self.player.isAboveWater && self.player.mainPlayerSprite.position.y < self.waterNode1.position.y+CGFloat(self.waterNode1.surfaceHeight){
                print("Veio water1")
                self.player.isAboveWater = false
                self.waterNode1.splashAt(x: Float(abs(self.player.mainPlayerSprite.position.x-water1MinX)), force: 20, width: 20)
                return
                
            }
            
        }
        
        
        if (self.waterNode2) != nil {
            
            self.waterNode2.update(dt)
            let water2MinX = self.waterNode2.position.x-self.waterNode2Size.width/2.0
            
            let playerIsOverWater2 = (self.player.mainPlayerSprite.position.x <= (self.waterNode2.position.x+self.waterNode2Size.width/2.0) && (self.player.mainPlayerSprite.position.x - water2MinX) > 0) ? true : false
            
            if playerIsOverWater2 && self.player.isAboveWater && self.player.mainPlayerSprite.position.y < self.waterNode2.position.y+CGFloat(self.waterNode2.surfaceHeight){
                print("Veio water2")
                self.player.isAboveWater = false
                self.waterNode2.splashAt(x: Float(abs(self.player.mainPlayerSprite.position.x-water2MinX)), force: 20, width: 20)
                return
                
            }
            
        }
        
        if (self.waterNode3) != nil {
            
            self.waterNode3.update(dt)
            let water3MinX = self.waterNode3.position.x-self.waterNode3Size.width/2.0
            let playerIsOverWater3 = (self.player.mainPlayerSprite.position.x <= (water3MinX + self.waterNode3Size.width) && (self.player.mainPlayerSprite.position.x - water3MinX) > 0) ? true : false
            
            if playerIsOverWater3 && self.player.isAboveWater && self.player.mainPlayerSprite.position.y < self.waterNode3.position.y+CGFloat(self.waterNode3.surfaceHeight){
                print("Veio water3")
                self.player.isAboveWater = false
                self.waterNode3.splashAt(x: Float(abs(self.player.mainPlayerSprite.position.x-water3MinX)), force: 20, width: 20)
                return
                
            }
            
        }
        
    }
    
    func lateWaterUpdate(_ dt: CFTimeInterval){
        
        self.waterNode1?.render()
        self.waterNode2?.render()
        self.waterNode3?.render()
        
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
        player.initializePlayerPhysicsBody()
        
        /** Initializing mother **/
        
        mother = BearMother()
        
        mother.mainMotherSprite.position.x = 9620
        self.addChild(mother.mainMotherSprite)
        mother.mainMotherSprite.zPosition = 1
        
        
        //addChild(player.nodo)
        //addChild(player.nodo2)
        
    }
    
    
    func fallObj (obj: SKNode){
       
        //for obj in self.fallObjects{
            let nameSep = obj.name?.components(separatedBy: "_")
            let objNumber: Int = Int((nameSep?[1])!)!
        let waitDuration: Double!
        
        switch objNumber {
        case 0:
            waitDuration = 0.7
            break
        case 1:
            waitDuration = 3
            break
        case 2:
            waitDuration = 0.5
            break
        default:
            waitDuration = 0
            break

        }
        
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate) //treme
            obj.zPosition = player.mainPlayerSprite.zPosition
            let wait = SKAction.wait(forDuration: waitDuration) //esperea
            let fall = SKAction.move(to: CGPoint(x: obj.position.x, y: -200), duration: 3) //cai
            let sequence = SKAction.sequence([wait, fall])
            obj.run(sequence, completion: { 
                  obj.removeFromParent()
                if objNumber != 2 {
                    self.fallObj(obj: self.fallObjects[objNumber + 1])
                }

            })
          
        //}
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var playerColision = false
        var playerNode:SKNode!
        var obstacleNode:SKNode!
        
        if let name = contact.bodyA.node?.name{
            if name == "Player" {
                print("body a player")

                playerNode = contact.bodyA.node
                obstacleNode = contact.bodyB.node
                playerColision = true
            
            }
            
        }
        
        if let name = contact.bodyB.node?.name{
            if name == "Player"{
                print("body b player")
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
                
                // MARK: BACKGROUND SOUND END
                backgroundSound!.run(SKAction.stop())

                // Agua - morre
                // ou
                // Ice cub - morre
            }
            else if(obstacleNode.physicsBody?.contactTestBitMask == 31){
                
                
                if ( obstacleNode.position.y  < playerNode.position.y  && playerNode.position.x  > obstacleNode.position.x - obstacleNode.frame.size.width/2 && playerNode.position.x < obstacleNode.position.x + obstacleNode.frame.size.width/2){
                    
                    self.obstacleAnimation(obstacle: obstacleNode)
                    
                }
            }
                
            else if (obstacleNode.physicsBody?.contactTestBitMask == 4){
                
                // MARK: BACKGROUND SOUND END
                backgroundSound!.run(SKAction.stop())

                player?.stateMachine.enter(PlayerWonState.self)
                print("morreu")
                
            }
            else if(obstacleNode.physicsBody?.contactTestBitMask == 5){
                // end game ground touched
                
                // MARK: BACKGROUND SOUND END
                backgroundSound!.run(SKAction.stop())

                endGameReached = true
                
                print("end game")
                
                
            }
            else if(obstacleNode.name == "Mother"){
                
                self.player.finishEndGameAnimation = true
                
            }
            /*
            else  if(obstacleNode.physicsBody?.contactTestBitMask == 22){
                // entrou na cave
                print("entrou na cave")
                if childNode(withName: "fallObj_0") != nil && childNode(withName: "fallObj_1") != nil && childNode(withName: "fallObj_2") != nil{
                self.fallObjects.append(childNode(withName: "fallObj_0")!)
                self.fallObjects.append(childNode(withName: "fallObj_1")!)
                self.fallObjects.append(childNode(withName: "fallObj_2")!)
                
                //if childNode(withName: "fallObj") != nil{
                    self.fallObj(obj: fallObjects[0])
                //}
                
                }
                
            }*/
            
            else  if(obstacleNode.physicsBody?.contactTestBitMask == 7){
                // MARK: BACKGROUND SOUND END
                backgroundSound!.run(SKAction.stop())

                print("nao desviou do objeto")
                if !(player.stateMachine.currentState is PlayerLostState) {
                    playerLost = true
                }
            }

            
        }
        
    }
    
    
    
    func obstacleAnimation(obstacle: SKNode){
        
        let nameArray = obstacle.name?.components(separatedBy: "_")
        let obsNumber = Int((nameArray?[1])!)

        if animationCompleted[obsNumber!] {
            animationCompleted[obsNumber!] =  false
        
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

            obstacle.run(animWithFall, completion: {
                obstacle.removeFromParent()
                self.animationCompleted[obsNumber!] = true
            })
        }
        
    }
    
    func initControllerInterface(){
        
        base.lineWidth = 10
        
        base.strokeColor = .gray
        ball.fillColor = .lightGray
        //base.fillColor = .cyan
        ball.zPosition = 2
        base.zPosition = 2
        ball.strokeColor = ball.fillColor
        
        ball.isHidden = true
        base.isHidden = true
        
        ball.position = base.position
        
        base.zPosition = 100
        ball.zPosition = 100
        self.cameraManager.cameraNode.addChild(base)
        self.cameraManager.cameraNode.addChild(ball)
        
        
    }
    
    func handleTap(gesture: UITapGestureRecognizer){
        
        if(!endGameReached && !playerLost){
            
            player?.stopMovingSound()
            player.stateMachine.state(forClass: JumpingState.self)?.distance = self.distanceJoystickFinger
            player?.stateMachine.state(forClass: JumpingState.self)?.rightMovement = self.rightMov
            
            tapLocation = gesture.location(in: self.view)
            
            player.changeState(stateClass: JumpingState.self)
            
            if(self.rightMov){
                
                self.cameraManager.setRightSideCameraConfiguration()
            }
            else{
                
                self.cameraManager.setLeftSideCameraConfigurations(node: self.player.mainPlayerSprite)
            }
            
            
            
        }
        
        
    }
    
    //controller methodss
    public func handleLongPress (gesture: UILongPressGestureRecognizer){

        if longPressSetted || endGameReached || playerLost{
            return
        }
        
        var position = gesture.location(in: self.view!)
        position = self.convertPoint(fromView: position)
        position =  (camera?.convert(position, from: self))!
        
        self.longPressLocation = position
        

        
        
        if gesture.state == .began{
            base.position = position
            ball.position = base.position
            base.isHidden = false
            ball.isHidden = false
            
        }
        
        if gesture.state == .ended || gesture.state == .cancelled{
            
            base.isHidden = true
            ball.isHidden = true
            
            ball.position = base.position
            player?.stateMachine.state(forClass: MovingState.self)?.stop = 1
            player?.stopMovingSound()
            return
            
        }
        
    }
    
    
    public func handlePan(gesture: UIPanGestureRecognizer){

        if endGameReached || playerLost{
            return
        }
        
        var position = gesture.location(in: self.view!)
        position = self.convertPoint(fromView: position)
        position =  (camera?.convert(position, from: self))!
        self.longPressLocation = position

        
        if gesture.state == .began{
            
            base.position = position
            
            
            ball.position = base.position
            base.isHidden = false
            ball.isHidden = false
            
            
        }
        
        if gesture.state == .ended || gesture.state == .cancelled{
            
            base.isHidden = true
            ball.isHidden = true
            
            ball.position = base.position
            player?.stateMachine.state(forClass: MovingState.self)?.stop = 1
            player?.stopMovingSound()
            return
            
        }

        setJoystickPosition(to: position)
       
    }
    
    
    func checkIfUserInCave() {
        
        if player.mainPlayerSprite.position.x >= 4900 && !alreadyEnteredInCave {
            print("entrou na cave")
            alreadyEnteredInCave = true
            if childNode(withName: "fallObj_0") != nil && childNode(withName: "fallObj_1") != nil && childNode(withName: "fallObj_2") != nil{
                self.fallObjects.append(childNode(withName: "fallObj_0")!)
                self.fallObjects.append(childNode(withName: "fallObj_1")!)
                self.fallObjects.append(childNode(withName: "fallObj_2")!)
                
                //if childNode(withName: "fallObj") != nil{
                self.fallObj(obj: fallObjects[0])
                //}
                
            }

            
            
        }
        
    }
    
    
    
    private func setJoystickPosition(to location : CGPoint){
        
        let vector  = CGVector(dx: location.x - base.position.x, dy: location.y - base.position.y)
        let angle = atan2(vector.dx, vector.dy)
        
        let LENGHT: CGFloat = 40
        
        var xDist: CGFloat!
        var yDist: CGFloat!
        
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
    
    
    func dealWithRotation() {
        
        if player.mainPlayerSprite.position.x > 1990 && player.mainPlayerSprite.position.x < 2100 {
            
            
            
                player.mainPlayerSprite.zRotation = CGFloat(GLKMathDegreesToRadians(20))
            
        }
        
        else if player.mainPlayerSprite.position.x > 6800 && player.mainPlayerSprite.position.x < 7454.0771484375 {
            player.mainPlayerSprite.zRotation = CGFloat(GLKMathDegreesToRadians(10))

        }
        else {
            
            
            player.mainPlayerSprite.zRotation = 0
        }
        
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if playerLost{
            player?.stateMachine.enter(PlayerLostState.self)
            return
        }
        
        let DISTANCE: Double = 150
        
        //LOCATIONS TO ROTATE
        //1964.1656 - 2131.72729492188
        //6769.2255859375 - 7454.0771484375

        
        
        
        
        
        
        if(!endGameReached){
            
            self.checkIfUserInCave()
            self.dealWithRotation()
            
            
            if (!base.isHidden && !(self.player?.stateMachine.currentState is JumpingState)){
                
                
                if abs (ball.position.x - base.position.x) > 3 { //&& self.player?.stateMachine.currentState is StoppedState{
                    
                    
                    self.player?.stateMachine.enter(MovingState.self)
                    player?.stateMachine.state(forClass: MovingState.self)?.stop = 0
                    
                    
                    if abs (longPressLocation.x - base.position.x) >= CGFloat (DISTANCE){
                        
                        self.distanceJoystickFinger = DISTANCE
                        //if abs(ball.position.x - base.position.x) >= 40{
                        
                        player?.stateMachine.state(forClass: MovingState.self)?.distance = DISTANCE
                        
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

                        player?.stateMachine.state(forClass: MovingState.self)?.distance = abs (Double(longPressLocation.x - base.position.x))
                        
                        self.distanceJoystickFinger = abs (Double(longPressLocation.x - base.position.x))

                        
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
            else if ball.isHidden{
                
                self.distanceJoystickFinger = 0
                
            }
            
            
        }
        
       
        
        player.update(deltaTime: currentTime)
        
        self.cameraManager.checkCameraPositionAndPerformMovement(node: player.mainPlayerSprite)
        
       
        
        if(endGameReached){
            
            if(firstTimeEnteredEndGame){
                
                self.player.changePhysicsBody()
                self.mother.changePhysicsBody()
                
                firstTimeEnteredEndGame = false
                
                player.mainPlayerSprite.removeAllActions()
                self.base.isHidden = true
                self.ball.isHidden = true

            }
            
            if(self.mother.sonAndMotherMatchedPosition){
                
                self.cameraManager.performZoomToEndGame()
            }
            
            mother.animateMotherToSonDirection()
            
            if(!self.firstEndGameAnimationIsFinished()){
            
                
                player.performEndGameAnimation()
                
                
            }
            
            if(self.firstEndGameAnimationIsFinished()){
                
                if(firstEndedFirstAnimation){
                    
                    firstEndedFirstAnimation = false
                    
                    self.removeFirstAnimationNodesFromScreenAndPrepareNextAnimation()
                    self.executeSecondAnimation()
                    
                }
                
                
                // then run third animation
            
                
                if(!self.oneTimeShootingStarAnimation){
                    
                    self.movementShootingStar()

                }
                
                self.executeThirdAnimation()
                
                if(self.lastAnimationManager.allTheGameAnimationsAreFinished()){
                    
                    player.stateMachine.enter(PlayerWonState.self)

                }
            }
            
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
    
  
    func firstEndGameAnimationIsFinished()->Bool{
        
        return self.player.finishEndGameAnimation
        
    }
    
    func removeFirstAnimationNodesFromScreenAndPrepareNextAnimation(){
        
        let playerNodeToBeRemoved = self.childNode(withName: "Player")
        let motherBearToBeRemoved = self.childNode(withName: "Mother")
        
        
        var correctedXForNextAnimation = (motherBearToBeRemoved?.position.x)! - (playerNodeToBeRemoved?.position.x)!
        
        correctedXForNextAnimation += (playerNodeToBeRemoved?.position.x)!
        
        let correctedYForNextAnimation = motherBearToBeRemoved?.position.y
        
        
        self.lastAnimationManager.prepareMainNodeForAnimation(px: correctedXForNextAnimation, py: correctedYForNextAnimation!)
        
        
        motherBearToBeRemoved?.removeFromParent()
        playerNodeToBeRemoved?.removeFromParent()
        
        
        self.addChild(self.lastAnimationManager.animationMainNode)
        
    }
    
    func executeSecondAnimation(){
        
        self.lastAnimationManager.performOneTimeOnlyEndAnimation()
        
    }
    
    func executeThirdAnimation(){
        
        self.lastAnimationManager.performShakingHeadAnimation()
    }
    
    func movementShootingStar(){
        
        self.shottingStar.run(SKAction.move(to: CGPoint.init(x: self.player.mainPlayerSprite.position.x-400, y: self.player.mainPlayerSprite.position.y+120), duration: 0.8), completion: {() -> Void in
            
           self.oneTimeShootingStarAnimation = true
            
        })
        
    }
    
}
