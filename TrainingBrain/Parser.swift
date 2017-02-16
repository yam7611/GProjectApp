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
    
    func parseJSON(url:String) -> Data{
    
        
        let data = Data()
    
        if let urlForParsing = NSURL(string: url+"/api/trials/chinese-characters-session-1"){
            
            if let JSONData = NSData(contentsOfURL:urlForParsing){
                let json = JSON(data:JSONData)
                
                let imageRoot = json["visualStimulusRoot"]

                let soundRoot = json["auditoryStimulusRoot"]

                for i in 0...json["stimulusPairs"].count{
                    let imageFileName = json["stimulusPairs"][i]["visualStimulusFilename"]
                    
                    let soundFileName = json["stimulusPairs"][i]["auditoryStimulusFilename"]
                    
                    let imageURLString = url  + imageRoot.stringValue + "/" + imageFileName.stringValue
                    
                    let soundURLString = url  + soundRoot.stringValue + "/" + soundFileName.stringValue
                    
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
