//
//  QuestionViewController.swift
//  TrainingBrain
//
//  Created by yam7611 on 2/17/17.
//  Copyright © 2017 yam7611. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON
import Alamofire

class QuestionViewController: UIViewController {
    
    
    @IBOutlet weak var imgView: UIImageView!
    
    let urlString = ""
    let parser = Parser()
    let rootURL = "http://115.146.91.233/"
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
    var questionDetailDict:NSDictionary?{
        didSet{
            self.mappingFunctionFromDicitonary(questionDetailDict)
        }
    }
    var timer = NSTimer()
    var linkDict:NSDictionary? = [String:AnyObject]()
    var link: String? = ""
    
    // parameters below will be used for this question test,all the values are given by API server.
    
    var auditoryStimulusRoot:String? = ""
    var visualStimulusRoot:String? = ""
    var auditoryStimulusDurationInSeconds:String? = ""
    var visualStimulusDurationInSeconds:String? = ""
    var timeoutNoticeDurationInSeconds:String? = ""
    var responseWindowInSeconds:String? = ""
    var interTrialIntervalInSeconds:String? = ""
    var links:NSDictionary? = [String:AnyObject]()
    
    var NUMBER_OF_TEST = 0
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.matchBtn.hidden = true
        self.unmatchBtn.hidden = true
        
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
    
    func mappingFunctionFromDicitonary(dictionary:NSDictionary?){
        
        if let dict = dictionary {
            
            auditoryStimulusRoot = dict["auditoryStimulusRoot"] as? String
            auditoryStimulusRoot = rootURL + auditoryStimulusRoot!
            visualStimulusRoot = dict["visualStimulusRoot"] as? String
            visualStimulusRoot = rootURL + visualStimulusRoot!
            auditoryStimulusDurationInSeconds = dict["auditoryStimulusDurationInSeconds"] as? String
            visualStimulusDurationInSeconds = dict["visualStimulusDurationInSeconds"] as? String
            timeoutNoticeDurationInSeconds = dict["timeoutNoticeDurationInSeconds"] as? String
            responseWindowInSeconds = dict["responseWindowInSeconds"] as? String
            interTrialIntervalInSeconds = dict["interTrialIntervalInSeconds"] as? String
            links = dict["_links"] as? NSDictionary
            linkDict = links!["generateTrialSpecifications"] as? NSDictionary
            link = linkDict!["href"] as? String
            print("the link is\(link!)")
            self.data = parser.parseJSON(link!,visualRoot: visualStimulusRoot!,auditoryRoot: auditoryStimulusRoot!)
            self.NUMBER_OF_TEST = self.data.countNumberOfSound()
            
        }
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
        
        //print(startAnsTiming?.timeIntervalSince1970.description)
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
    
    override func viewWillDisappear(animated: Bool) {
        self.timerForVisual.invalidate()
        self.timerForAns.invalidate()
        self.timerForRemoveBtn.invalidate()
        self.timer.invalidate()
        self.timerForCountingResponse.invalidate()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}
