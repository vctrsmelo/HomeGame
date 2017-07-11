//
//  Database.swift
//  HomeGame
//
//  Created by Douglas Gehring on 11/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit


class Database: AnyObject {

    
    var userDefaults:UserDefaults!
    var currentLevel:Int
    
    
    init() {

        self.userDefaults = UserDefaults.standard
        self.currentLevel = 0
        
        if(self.checkFirstUse()){
            
            self.currentLevel = 1
            self.writeDataToUserDefaultsFile()
        }else{
            
            self.currentLevel = self.userDefaults.integer(forKey: "CurrentLevel")
        }
        
    }
    
    
    func setUserToNextLevel(){
        
        self.currentLevel+=1
        
        self.writeDataToUserDefaultsFile()
    }
    
    func checkFirstUse()->Bool{
        
        if(!self.userDefaults.bool(forKey: "CurrentLevel")){
            
            return true
        }
        
        return false
    }
    
    
    
    func writeDataToUserDefaultsFile(){
        
        
        self.userDefaults.set(self.currentLevel, forKey: "CurrentLevel")
        
    }
    
}
