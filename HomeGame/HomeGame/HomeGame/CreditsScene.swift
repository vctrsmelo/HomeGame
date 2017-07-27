//
//  CreditsScene.swift
//  HomeGame
//
//  Created by Laura Corssac on 24/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import SpriteKit
import GameplayKit

class CreditsScene: SKScene {
    
    let creditsSceneLaura = false
    
    var newBackground:  SKSpriteNode!
    var sea:            SKSpriteNode!
    var stones:         [SKSpriteNode]! = []
    var menubtn:           SKSpriteNode!
    
    var background =    SKSpriteNode()
    var nameArray =     ["Bharbara Cechin", "Douglas Gehring", "Juliana Cardoso", "Laura Corssac", "Victor Melo"]
    
    override func didMove(to view: SKView) {
        
        if(creditsSceneLaura){
            didMoveLaura()
        } // fim credits scene laura
        else {
            if(initCreditsSceneAttributes()){
                print("Credits SUCCESS")
                
                self.addChild(self.newBackground)
                self.addChild(self.sea)
                for stone in self.stones {
                    self.addChild(stone)
                }
                self.addChild(menubtn)
            }
        }
    }
    
    func initCreditsSceneAttributes() -> Bool {
        initNewBackgroundAndSea()
        initStones()
        initMenuButton("button_menu")
        
        return true
    }
    
    func initNewBackgroundAndSea() {
        /* Initialize background with texture */
        // init BACKGROUND
        let backgroundTexture = SKTexture(imageNamed: "Prancheta 8")
        
        let viewWidth = self.view?.bounds.width
        let viewHeight = self.view?.bounds.height
        let backgroundSize = CGSize(width: viewWidth!, height: viewHeight!)
        
        self.newBackground = SKSpriteNode(texture: backgroundTexture, size: backgroundSize)
        
        self.newBackground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.newBackground.zPosition = CGFloat(-100)
        
        // init SEA
        let seaTexture = SKTexture(imageNamed: "Prancheta 5")
        
        let seaSize = CGSize(width: viewWidth!, height: (viewHeight!)/4.5)
        
        self.sea = SKSpriteNode(texture: seaTexture, size: seaSize)
        
        self.sea.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        
        let seaPosX = self.newBackground.frame.midX
        let seaPosY = self.newBackground.frame.minY
        self.sea.position = CGPoint(x: seaPosX, y: seaPosY)
        
        self.sea.zPosition = CGFloat(-90)
    }
    
    func initStones() {
        // cria varios stoneNode's, que contem o sprite de stone de cada um dos componentes do grupo
        
        var stoneNum = 0
        while(stoneNum < 5) {
            let stoneTexture = SKTexture(imageNamed: self.nameArray[stoneNum])

            let viewWidth = self.view?.bounds.width
            let viewHeight = self.view?.bounds.height
            let stoneSize = CGSize(width: (viewWidth!)/4.4, height: (viewHeight!)/5.5)
            
            let stoneNode = SKSpriteNode(texture: stoneTexture, size: stoneSize)
            
            print(stoneNode)
            
            stoneNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            
            let nodePosX = self.newBackground.frame.midX
            let nodePosY = self.newBackground.frame.minY
            
            print("\(nodePosX), \(nodePosY)\n")
            
            // MARK: instrutor
            switch stoneNum {
            case 0:
                // Bharbara: anchor point, x&y position, zposition
                stoneNode.position = CGPoint(x: nodePosX+(viewWidth!/5.5), y: nodePosY+(viewHeight!/9.7))
                stoneNode.zPosition = CGFloat(100)
                stoneNode.scale(to: CGSize(width: (viewWidth!)/6.2, height: (viewHeight!)/6.5))
                break
            case 1:
                // Douglas: anchor point, x&y position, zposition
                stoneNode.position = CGPoint(x: nodePosX, y: nodePosY)
                stoneNode.zPosition = CGFloat(101)
                break
            case 2:
                // Juliana: anchor point, x&y position, zposition
                stoneNode.anchorPoint = CGPoint(x: 1.1, y: 0.2)
                stoneNode.position = CGPoint(x: nodePosX+(viewWidth!)/2, y: nodePosY)
                stoneNode.zPosition = CGFloat(102)
                stoneNode.scale(to: CGSize(width: (viewWidth!)/4, height: (viewHeight!)/5))
                break
            case 3:
                // Laura: anchor point, x&y position, zposition
                stoneNode.position = CGPoint(x: nodePosX-(viewWidth!/5.5), y: nodePosY+(viewHeight!/9.7))
                stoneNode.zPosition = CGFloat(100)
                stoneNode.scale(to: CGSize(width: (viewWidth!)/6.2, height: (viewHeight!)/6.5))
                break
            case 4:
                // Victor: anchor point, x&y position, zposition
                stoneNode.anchorPoint = CGPoint(x: -0.1, y: 0.2)
                stoneNode.position = CGPoint(x: nodePosX-(viewWidth!)/2, y: nodePosY)
                stoneNode.zPosition = CGFloat(102)
                stoneNode.scale(to: CGSize(width: (viewWidth!)/4, height: (viewHeight!)/5))
                break
            default:
                break
            }
            
            self.stones.append(stoneNode)
            stoneNum += 1
        }
    }
    
    func initMenuButton(_ name: String) {
        /* Initialize menu with texture */
        let menubtnTexture = SKTexture(imageNamed: name)
        
        let viewWidth = self.view?.bounds.width
        let viewHeight = self.view?.bounds.height
        let menubtnSize = CGSize(width: (viewWidth!)/6, height: (viewHeight!)/11)
        
        self.menubtn = SKSpriteNode(texture: menubtnTexture, size: menubtnSize)
        
        self.menubtn.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        
        let menubtnPosX = self.newBackground.frame.midX
        let menubtnPosY = self.newBackground.frame.midY
        self.menubtn.position = CGPoint(x: menubtnPosX, y: menubtnPosY)
        
        self.menubtn.zPosition = CGFloat(-90)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(creditsSceneLaura){
            touchesBeganLaura(touches)
        } // fim credits scene laura
        else {
            let mainscene = MainScene(fileNamed: "MainScene")
            if self.menubtn.contains((touches.first?.location(in: self))!) {
                self.menubtn.removeFromParent()
                initMenuButton("button_menu_select")
                self.addChild(menubtn)
                SKAction.wait(forDuration: 1.0)
                self.view?.presentScene(mainscene!, transition: SKTransition.fade(withDuration: 1.0))
            }
        }
    }
    
    // MARK: CREDITS LAURA

    
    func didMoveLaura() {
        background = SKSpriteNode.init(imageNamed: "backGroundCredits")
        addChild(background)
        background.scale(to: (self.view?.frame.size)!)
        background.alpha = 1
        background.zPosition = -2
        
        var counter = 0
        for name in nameArray{
            
            let info = SKLabelNode(fontNamed: "Helvetica-Bold")
            let info2 = SKLabelNode(fontNamed: "Helvetica-Bold")
            
            let nameComps = name.components(separatedBy: " ")
            //let stringFormatted = String.init(format: nameComps[0] + "\r\n" + nameComps[1])
            
            info.text = nameComps[0]
            info2.text = nameComps[1]
            info.fontSize = 14
            info.fontColor = SKColor.white
            info2.fontSize = 14
            info2.fontColor = SKColor.white
            
            let iceberg = childNode(withName: "obj\(counter)") as! SKSpriteNode
            
            let icePos = CGPoint(x: iceberg.position.x - 3, y: iceberg.position.y + iceberg.frame.size.height/2 - 25)
            
            info.position = CGPoint(x: icePos.x, y: icePos.y)
            info2.position = CGPoint(x: icePos.x, y: icePos.y - 15)
            info.zPosition = 3
            info2.zPosition = 3
            
            let shadow = SKSpriteNode.init(imageNamed: "685")
            shadow.position = CGPoint(x: iceberg.position.x, y: iceberg.position.y - 3)
            shadow.zPosition = iceberg.zPosition - 10
            shadow.colorBlendFactor = 0.5
            shadow.color = .black
            shadow.alpha = 0.25
            shadow.blendMode = .alpha
            
            addChild(info2)
            addChild(shadow)
            addChild(info)
            counter = counter + 1
            
            iceberg.shadowedBitMask = 1
            iceberg.shadowCastBitMask = 1
            iceberg.lightingBitMask = 1
            
            /*
             let light = SKLightNode()
             
             light.falloff = 0
             light.isEnabled = true
             light.shadowColor = .black
             light.position = iceberg.position
             light.zPosition = iceberg.zPosition + 1
             light.categoryBitMask = 1
             addChild(light)
             */
        }
    }
    
    func touchesBeganLaura(_ touches: Set<UITouch>) {
        let woodTrunk = childNode(withName: "woodTrunk")
        let touch = touches.first
        
        if (woodTrunk?.contains((touch?.location(in: self))!))!{
            if let home = SKScene(fileNamed: "MainScene"){
                self.view?.presentScene(home)
            }
        }
    }
}
