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
    
    
    override func didMove(to view: SKView) {
        
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector
            (self.tapped(sender:)))
        
        let swipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(sender:)))
        let swipe2:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(sender:)))
        let swipe3:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(sender:)))
        let swipe4:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(sender:)))
        
        swipe2.direction = .left
        swipe.direction = .right
        swipe3.direction = .up
        swipe4.direction = .down
        view.addGestureRecognizer(swipe4)
        view.addGestureRecognizer(swipe3)
        view.addGestureRecognizer(swipe2)
        view.addGestureRecognizer(swipe)
        view.addGestureRecognizer(tap)
        
    
    self.player =  Player()
    addChild(player.nodeTest)
        
        let playingState = PlayingState()
        let waitingState = WaitingState()
        
        
        
        self.GameStateMachine = GKStateMachine(states: [playingState, waitingState])
        
        self.GameStateMachine.enter(PlayingState.self) //user comeca pensando no nivel, e nao jogando
        
    }
    
    
    
    func tapped(sender: UITapGestureRecognizer){
        
        player.changeState(stateClass: JumpingState.self)
        
        print("tapped")
    }
    
    
    
     func swiped(sender:UISwipeGestureRecognizer){
        
        player.changeState(stateClass: MovingState.self)
        
        
        print("swiped")
    }
    

   
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    
    

    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        
        
    }
    
    
}
