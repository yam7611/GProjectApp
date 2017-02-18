//
//  Parser.swift
//  TrainingBrain
//
//  Created by yam7611 on 1/20/17.
//  Copyright © 2017 yam7611. All rights reserved.
//

import Foundation
import SwiftyJSON


class Parser :NSObject{
    
    
    //put a url into this parser then return a combination of object
    
    
    
    var soundArray = []
    var pictureArray = []
    var nameArray = []
    
    var photoData:NSData?
    var soundData:NSData?
    
    var counterNumber = 0
    
    func parseJSON(url:String,visualRoot:String,auditoryRoot:String) -> Data{
    
        
        let data = Data()
    
        if let urlForParsing = NSURL(string: url){
            
            if let JSONData = NSData(contentsOfURL:urlForParsing){
                let json = JSON(data:JSONData)
                
                let imageRoot = visualRoot

                let soundRoot = auditoryRoot

                for i in 0...json["trialSpecifications"].count{
                    let imageFileName = json["trialSpecifications"][i]["visualStimulusFilename"]
                    
                    let soundFileName = json["trialSpecifications"][i]["auditoryStimulusFilename"]
                    
                    let imageURLString = visualRoot + "/" + imageFileName.stringValue
                    
                    let soundURLString = auditoryRoot + "/" + soundFileName.stringValue
                    
                    data.setPic(NSURL(fileURLWithPath:imageURLString))
                    data.setSound(NSURL(fileURLWithPath:soundURLString))
                    
                    data.setPicsFileName(imageFileName.description)
                    data.setSoundFileName(soundFileName.description)
                    counterNumber += 1
                    
                    soundData = NSData(contentsOfURL: NSURL(string:soundURLString)!)
                    photoData = NSData(contentsOfURL: NSURL(string:imageURLString)!)
                    
                    
                    let imageDestination = fetchDocumentPath().URLByAppendingPathComponent("\(counterNumber).jpeg")
                    
                    let soundDestination = fetchDocumentPath().URLByAppendingPathComponent("\(counterNumber).mp3")
                    
                    
                    data.setPicLocation(imageDestination)
                    data.setSoundLocation(soundDestination)
                    
                    let imgString = imageFileName.description.stringByReplacingOccurrencesOfString(".png", withString: "")
                    
                    let soundString = soundFileName.description.stringByReplacingOccurrencesOfString(".mp3", withString: "")
                    
                    print("imgString:\(imgString),soundString:\(soundString)")
                    
                    if imgString == soundString{
                      data.setCorrectedAns("MATCH")
                    } else {
                       data.setCorrectedAns("NOT_MATCH") 
                    }
                    
                    
                   _ = try? soundData?.writeToURL(soundDestination, options: .DataWritingFileProtectionComplete)
                    
                    _ = try? photoData?.writeToURL(imageDestination, options: .DataWritingFileProtectionComplete)
                    
                    
                }
                
            }
            
        }
        
        return data
    }
    
    
    func fetchDocumentPath() -> NSURL{
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentPath = paths[0]
        
        return documentPath
    }
    
    
    
}
