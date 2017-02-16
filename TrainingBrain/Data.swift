//
//  Data.swift
//  TrainingBrain
//
//  Created by yam7611 on 1/22/17.
//  Copyright © 2017 yam7611. All rights reserved.
//

import Foundation

class Data{
   
    private var sounds:[NSURL] = []
    private var pics:[NSURL] = []
    private var name:[NSURL] = []
    private var picsLocation:[NSURL] = []
    private var soundsLocation:[NSURL] = []
    private var soundFileName :[String] = []
    private var picsFileName:[String] = []
    
    init(){
        
    }
    
    func setPic(url:NSURL){
        self.pics.append(url)
    }
    func setSound(url:NSURL){
        self.sounds.append(url)
    }
    
    func getSound(number:Int) -> NSURL{
       return self.sounds[number]
    }
    
    func getImage(number:Int) -> NSURL{
        return self.pics[number]
    }
    
    func setPicLocation(location:NSURL){
        self.picsLocation.append(location)
    }
    func setSoundLocation(location:NSURL){
         self.soundsLocation.append(location)
    }
    
    func getPicLocation(number:Int)-> NSURL {
        
        return self.picsLocation[number]
    }
    
    func getSoundsLocation(number:Int)-> NSURL {
        
        return self.soundsLocation[number]
    }

    
    
    func countNumberOfElement() ->Int{
        return pics.count
    }
    func countNumberOfSound() ->Int{
        return sounds.count
    }
    
    func setSoundFileName(soundName:String){
        self.soundFileName.append(soundName)
    }
    
    func setPicsFileName(picName:String){
        self.picsFileName.append(picName)
    }
    
    func getSoundFileName(number:Int) ->String{
        return self.soundFileName[number]
    }
    func getPicsFileName(number:Int) ->String{
        return self.picsFileName[number]
    }
    
}
