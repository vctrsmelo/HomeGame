//
//  StoppedState.swift
//  HomeGame
//
//  Created by Laura Corssac on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit
import GameplayKit

class StoppedState: GKState {
    
    
    weak var player: Player?
    
    init(with player: Player) {
        self.player = player
        super.init()
    }

    
    
    
    override func willExit(to nextState: GKState) {
        
    }
    
    
    
    override func didEnter(from previousState: GKState?) {
        _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            //Do stuff every second here
        }
        print("did enter")
        player?.component(ofType: StopComponent.self)?.stopAnimate()
        
        
    }
    
    
    override func update(deltaTime seconds: TimeInterval) {
        
        //print("stopped!!!")
        
        //if (player?.checkTextureForInitialFrame())!{
            
          //  player?.stopMainPlayerSpriteAnimation()
        //}
    }

}

