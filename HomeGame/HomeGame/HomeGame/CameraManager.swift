//
//  CameraManager.swift
//  ColisionsTest
//
//  Created by Douglas Gehring on 21/07/17.
//  Copyright © 2017 Douglas Gehring. All rights reserved.
//


/***** MISSING INTEGRATION WITH CODE *****/

import SpriteKit
import UIKit

class CameraManager: AnyObject {

    var esquerda = false
    var direita = false
    
    var lastPositionToRight = CGPoint(x: 268, y: 0)
    var lastPositionToLeft = CGPoint(x: -268, y: 0)

    
    var cameraNode:SKCameraNode!
    
    
    
    
    init() {
        
        cameraNode = SKCameraNode()
    }
    
    
    
    func getCostomCamera()->SKCameraNode{
        
        return self.cameraNode
    }
    
    
    func setLeftSideCameraConfigurations(node:SKNode){
        
        if(direita){
            
            lastPositionToRight = node.position
            
        }
        
        direita  = false
        
        esquerda = true
        
        if((lastPositionToRight.x - 536) > node.position.x){
            
            lastPositionToRight.x = node.position.x + 536
            
        }
        
    }
    
    
    func setRightSideCameraConfiguration(){
        
        
        esquerda = false
        direita = true
        
    }
    
    
    func checkCameraPositionAndPerformMovement(node:SKNode){
        
        
        if(node.position.x >= lastPositionToRight.x && direita){
            
            cameraNode.position.x = (node.position.x - 268)
            
        }
        
        if(node.position.x <= (lastPositionToRight.x - 536) && esquerda){
            
            cameraNode.position.x = (node.position.x + 268)
            
        }
        
    }
    
    
    
    
}
