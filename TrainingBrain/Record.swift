//
//  Record.swift
//  TrainingBrain
//
//  Created by yam7611 on 2/19/17.
//  Copyright © 2017 yam7611. All rights reserved.
//

import Foundation

class Record{
    
    
    private var endTime:String?
    private var startTime:String?
    private var ratio:String?
    private var block:String?
    private var month:String?
    private var year:String?
    private var date:String?
    
    init(){
        
    }
    init(dict:NSDictionary){
        if let dictRecord = dict as? NSDictionary{
            
            
            self.endTime = dictRecord["end_time"] as? String
            self.startTime = dictRecord["start_time"] as? String
            self.block = dictRecord["block"] as? String
            self.ratio = dictRecord["ratio"] as? String
            
            convertStringToTime(self.startTime!)
        }
    }
    
    func convertStringToTime(string:String){
        let timeString = string
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        let trimedString = (string as NSString).substringToIndex(10)
        self.date = (trimedString as NSString).substringFromIndex(8)
        
        print("time:\(self.date)")
        
    }
    func getDate()->String?{
        return self.date
    }
    
    func setEndTime(eTime:String){
        self.endTime = eTime
    }
    func getEndTime()->String{
        return self.endTime!
    }
    func getStartTime()->String{
        return self.startTime!
    }
    func setStartTime(sTime:String){
        self.startTime = sTime
    }
    func getBlock()->String{
        return self.block!
    }
    func setBlock(block:String){
        self.block = block
    }
    func setRatio(ratio:String){
        self.ratio = ratio
    }
    
    func getRatio()->String{
        return self.ratio!
    }
    
}
