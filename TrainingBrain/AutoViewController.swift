//
//  AutoViewController.swift
//  TrainingBrain
//
//  Created by yam7611 on 1/20/17.
//  Copyright © 2017 yam7611. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON

class AutoViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    let urlString = "http://115.146.91.233"
    let parser = Parser()
    
    var data = Data()
    var player : AVAudioPlayer?
    var timerForVisual = NSTimer()
    
    var timerForAns = NSTimer()
    var timerForRemoveBtn = NSTimer()
    var timerForCountingResponse = NSTimer()
    var startAnsTiming:NSDate?
    var pressTime:NSDate?
    var tempAns = ""
    var duration = ""
    var answers = [(String,String)]()
    var currentDate :NSDate?
    var endTime:NSDate?
    var covertedDate:String?
    var convertedEndTime:String?
    
    let NUMBER_OF_TEST = 5
    
    
    @IBOutlet weak var matchBtn: UIButton!
    @IBOutlet weak var unmatchBtn: UIButton!
    
    var counter :Int = 0{
        
        didSet{
            let soundURL = data.getSoundsLocation(counter-1)
            
            matchBtn.hidden = true
            unmatchBtn.hidden = true
            
            print("duration is:\(duration),ans is:\(tempAns)")
            
            answers.append((duration,tempAns))
            
            tempAns = "TIMED_OUT"
            duration = "null"
            
            do{
                player = try AVAudioPlayer(contentsOfURL:soundURL)
                player?.play()
                
                timerForVisual = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(loadingVisual(_:)), userInfo: nil, repeats: false)
                timerForAns = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(displayBtn(_:)), userInfo: nil, repeats: false)
                timerForRemoveBtn = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: #selector(removeBtn(_:)), userInfo: nil, repeats: false)
            
            } catch let err as NSError{
                print (err.description)
            }
            
            
        }
        
    }
    var timer = NSTimer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        matchBtn.hidden = true
        unmatchBtn.hidden = true
        
        
        data = parser.parseJSON(urlString)
        

        currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        covertedDate = dateFormatter.stringFromDate(currentDate!)
        
        
        print("the date and time is:\(covertedDate)")
        
        if counter < data.countNumberOfElement() - 1 {
            timer = NSTimer.scheduledTimerWithTimeInterval(6.0, target: self, selector: #selector(changeQuestion(_:)), userInfo: nil, repeats: true)
        } else {
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func pressMatch(sender: UIButton) {
        pressTime = NSDate()
        
        let t1 = pressTime?.timeIntervalSince1970
        let t2 = startAnsTiming?.timeIntervalSince1970
        
        duration = NSString(format:"%.3f",t1! - t2!) as String
        
        tempAns = "MATCH"

    }
    
    @IBAction func pressUnMatch(sender: UIButton) {
        pressTime = NSDate()
        
        let t1 = pressTime?.timeIntervalSince1970
        let t2 = startAnsTiming?.timeIntervalSince1970
        
        duration = NSString(format:"%.3f",t1! - t2!) as String
        
        tempAns = "NOT_MATCH"

    }
    
    func displayBtn(notificaiton:NSNotificationCenter){
        self.matchBtn.hidden = false
        self.unmatchBtn.hidden = false
        
        timerForCountingResponse = NSTimer.scheduledTimerWithTimeInterval(0.0, target: self, selector: #selector(startCounting(_:)), userInfo: nil, repeats: false)
        
    }
    
    func removeBtn(notification:NSNotificationCenter){
        self.matchBtn.hidden = true
        self.unmatchBtn.hidden = true

    }
    
    func loadingVisual(notification:NSNotificationCenter){
        let image = UIImage(data: NSData(contentsOfURL:data.getPicLocation(counter-1))!)
        imgView.image = image
    }
   
    func changeQuestion(notification:NSNotificationCenter){
        
        if counter < NUMBER_OF_TEST {
            counter += 1
            print("current item number:\(counter)")
        } else {
            endTime = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            convertedEndTime = dateFormatter.stringFromDate(endTime!)
            writeToJSON()
            timer.invalidate()
            
            print("task finished")

        }
    }
    
    func startCounting(notification:NSNotificationCenter){
        
    startAnsTiming = NSDate()
        
     print(startAnsTiming?.timeIntervalSince1970.description)
    }
    
    func writeToJSON(){
        
        var json:JSON
        var jsonArray = [JSON]()
        
        json = ["trialID":"Chinese-characters-test","startedAt":"\(currentDate!)","completedAt":"\(convertedEndTime!)","stimulusResponses":""]
        
        var innerLayerOfJSON :JSON?
        
        for i in 0...NUMBER_OF_TEST-1{
            innerLayerOfJSON = ["auditoryStimulusFilename":data.getSoundFileName(i),"visualStimulusFilename":data.getPicsFileName(i),"responseTime":"\(answers[i].0)","reponse":"\(answers[i].1)"]
            jsonArray.append(innerLayerOfJSON!)
        }
        
        json["stimulusResponses"].string = "\(jsonArray)"
        
        
        print("the json data is :\(json.description)")
        
        
        
    }
}
