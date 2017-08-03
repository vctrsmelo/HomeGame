//
//  IntroAnimation.swift
//  HomeGame
//
//  Created by Douglas Gehring on 01/08/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit
import GameplayKit

class IntroAnimation: SKScene, SKPhysicsContactDelegate {

    
    
    var player:Player!
    
    var mother:BearMother!
    
    var cameraManager:CameraManager!
    
    var iceCracked = false
    
    var counterToFall = 0
    
    var lightActioned = false
    
    var counterToLight = 0
    
    var snow:SKEmitterNode!
    
    var light:SKEmitterNode!
    
    var dir:CGFloat = 1
    
    var dirChanged = true
    
    var firstAnimationFinished = false
    
    var oneEnterOnly = false
    
    var lagrima:SKEmitterNode!
    
    var counterToInitGame = 0
    
    var initCounterToInitGame = false
    
    override func didMove(to view: SKView) {
        
     
        self.physicsWorld.contactDelegate = self
        
        print("Entrou")
        
        player = Player()
        
        player.initializePlayerPhysicsBody()
        
        self.player.mainPlayerSprite.zPosition = 1
        
        self.player.mainPlayerSprite.position.y = -130
        
        addChild(self.player.mainPlayerSprite)
        
        self.setCameraConfigurations()
        
        self.setMotherPosition()
        
        self.setSnowConfigurations()
        
    }
    
    
    private func setLagrimaConfigurations(position:CGPoint){
        
        
        self.lagrima = SKEmitterNode.init(fileNamed: "Lagrima")
        
        self.lagrima.position.x = position.x + 30
            
        self.lagrima.position.y = position.y + 12
        
        self.lagrima.zPosition = 2
        
        self.addChild(lagrima)
        
        
        
    }
    
    private func setLightConfigurations(){
        
        
        self.light = SKEmitterNode(fileNamed: "BigLight")
        
        self.light.position.x = self.player.mainPlayerSprite.position.x
        self.light.position.y = self.player.mainPlayerSprite.position.y
        
        
        self.addChild(self.light)
        
        
    }
    
    private func setSnowConfigurations(){
        
        self.snow = SKEmitterNode(fileNamed: "snowParticle")
        
        self.snow.position.x = 500
        self.snow.position.y = 200
        
        
        self.addChild(self.snow)
        
    }
    
    
    func setMotherPosition(){
        
        self.mother = BearMother()
        
        self.mother.mainMotherSprite.position.x = 100
        self.mother.mainMotherSprite.position.y = -100
        
        self.mother.mainMotherSprite.zPosition = 1
        
        self.addChild(self.mother.mainMotherSprite)
        
    }
    
    func setCameraConfigurations(){
        
        
        self.cameraManager = CameraManager(viewWidth: (self.view?.frame.width)!)
        
        addChild(self.cameraManager.cameraNode)
        
        camera = self.cameraManager.cameraNode
        
        self.cameraManager.introAnimation = true
        
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
            
            if(obstacleNode.physicsBody?.contactTestBitMask == 31){
                
                // Chao cai
                
                self.iceCracked = true
                
                self.cameraManager.performZoomToIntroAnimation()
            }
                
        }
        
    }
    
    
    
    func obstacleAnimation(obstacle: SKNode){
            
            
            //let wait = SKAction.wait(forDuration: 1.0)
            let rot1 = SKAction.rotate(byAngle: -CGFloat(GLKMathDegreesToRadians(1.5)), duration: 0.1)
            let rot2 = rot1.reversed()
            let rot3 = SKAction.rotate(byAngle: CGFloat(GLKMathDegreesToRadians(1.5)), duration: 0.1)
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
                //obstacle.removeFromParent()
            })
        
        
        
    }
    
    
    
    
    func handleAnimation(){
        
        self.player.performIntroGameAnimation(direction: dir)
        self.mother.animateMotherToGoAhead()
        if(self.firstAnimationFinished){
            
            self.player.performIntroGameAnimationBackwards()
        }
        
    }
    
    
    func iceFall(){
        
        print("chao cai")
        
        let iceCrack = self.childNode(withName: "ice")
        
        iceCrack?.physicsBody?.affectedByGravity = true
        
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        self.handleAnimation()
        
        if(iceCracked){
            
            self.obstacleAnimation(obstacle: self.childNode(withName: "ice")!)
            
            counterToFall+=1
            
            if(!dirChanged){
                
                //dir *= -1
                //dirChanged = true
                
                
                
            }
            if(counterToFall == 80){
                
                self.lightActioned = true
                
                self.iceFall()
                
            }
            if(counterToFall >= 50 && self.player
                .finishEndGameAnimation){
                
                self.firstAnimationFinished = true
            }
            
            if(self.player.finishEndGameAnimationBack && !oneEnterOnly){
                
                self.oneEnterOnly = true
                
                self.setLagrimaConfigurations(position: self.player
                .mainPlayerSprite.position)
                
                self.initCounterToInitGame = true
                
                self.cameraManager.performZoomToIntroAnimationFinal()
                
            }
            if(self.initCounterToInitGame){
                
                self.counterToInitGame+=1
                
                if(self.counterToInitGame == 120){
                    
                    self.callInitGameScene()
                }
            }
            
            
        }
        
        if(self.lightActioned){
            
           // self.setLightConfigurations()
            
        }
        
        cameraManager.checkCameraPositionAndPerformMovement(node: player.mainPlayerSprite)
        
    }


    private func callInitGameScene(){
        
        if let view = self.view as! SKView? {
            GameViewController.sharedView = view
            if let scene = SKScene(fileNamed: "Level1Scene") {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            
          
        }

        
    }


}





