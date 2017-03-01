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
    var user = User()
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
    var auditoryStimulusDurationInSeconds:Float? = 0.0
    var visualStimulusDurationInSeconds:Float? = 0.0
    var timeoutNoticeDurationInSeconds:Float? = 0.0
    var responseWindowInSeconds:Float? = 0.0
    var interTrialIntervalInSeconds:Float? = 0.0
    var links:NSDictionary? = [String:AnyObject]()
    var textForDenotingDownloading = UILabel()
    
    
    let blockNames = ["bst1-1","bst1-2","bst1-3","bst2-1","bst2-2","bst2-3","bst3-1","bst3-2","bst3-3","bst4-1","bst4-2","bst4-3","bst5-1","bst5-2","bst5-3","bs-1","bs-2","bs-3","bs-4","bs-5","mc-1","mc-2","mc-3","mc-4","mc-5","mct-1","mct-2","mct-3"]
    
    var correctedAns = []
    
    var currentBlock = ""
    
    var NUMBER_OF_TEST = 0
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var matchBtn: UIButton!
    @IBOutlet weak var unmatchBtn: UIButton!
    
    var counter :Int = 0{
        
        didSet{
            let soundURL = data.getSoundsLocation(counter-1)
            
            //matchBtn.hidden = true
            //unmatchBtn.hidden = true
            matchBtn.enabled = false
            unmatchBtn.enabled = false
            
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(gotUserInfo(_:)), name: "userInfo", object: nil)
        
        super.viewDidLoad()
        
        timerForCountingResponse = NSTimer.scheduledTimerWithTimeInterval(0.0, target: self, selector: #selector(startCounting(_:)), userInfo: nil, repeats: false)
        

        //self.matchBtn.hidden = true
        //self.unmatchBtn.hidden = true
        matchBtn.enabled = false
        unmatchBtn.enabled = false
        
       // print("the date and time is:\(covertedDate)")
        
        if counter < data.countNumberOfElement() - 1 {
            timer = NSTimer.scheduledTimerWithTimeInterval(6.0, target: self, selector: #selector(changeQuestion(_:)), userInfo: nil, repeats: true)
        } else {
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func gotUserInfo(notification:NSNotification){
        print("go to oberser!!!")
        if let userInfo = notification.userInfo {
            if let user = userInfo["user"] as? User{
                self.user = user
                print("\(self.user)")
            }
        }
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
            auditoryStimulusDurationInSeconds = dict["auditoryStimulusDurationInSeconds"] as? Float
            visualStimulusDurationInSeconds = dict["visualStimulusDurationInSeconds"] as? Float
            timeoutNoticeDurationInSeconds = dict["timeoutNoticeDurationInSeconds"] as? Float
            responseWindowInSeconds = dict["responseWindowInSeconds"] as? Float
            interTrialIntervalInSeconds = dict["interTrialIntervalInSeconds"] as? Float
            
            links = dict["_links"] as? NSDictionary
            linkDict = links!["generateTrialSpecifications"] as? NSDictionary
            link = linkDict!["href"] as? String
            print("the link is\(link!)")
            
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.startAnimating()
                
                self.view.addSubview(self.textForDenotingDownloading)
               
                self.textForDenotingDownloading.translatesAutoresizingMaskIntoConstraints = false
                self.textForDenotingDownloading.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
                self.textForDenotingDownloading.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor, constant: -60).active = true
                
                self.textForDenotingDownloading.text = "Please wait while content is downloading..."
                self.textForDenotingDownloading.sizeToFit()
                self.textForDenotingDownloading.adjustsFontSizeToFitWidth = true
                self.textForDenotingDownloading.textColor = UIColor.blackColor()
                
                
            })
            
            self.data = parser.parseJSON(link!,visualRoot: visualStimulusRoot!,auditoryRoot: auditoryStimulusRoot!)
            
            self.NUMBER_OF_TEST = self.data.countNumberOfSound()
            print("current number of question :\(self.NUMBER_OF_TEST)")
            
            for i in 0...self.blockNames.count - 1{
                
                if link!.containsString(self.blockNames[i]){
                    currentBlock = self.blockNames[i]
                }
            }
        }
    }
    
    func displayBtn(notificaiton:NSNotificationCenter){
       // self.matchBtn.hidden = false
        //self.unmatchBtn.hidden = false
        matchBtn.enabled = true
        unmatchBtn.enabled = true
        
        self.imgView.image = nil
           }
    
    func removeBtn(notification:NSNotificationCenter){
        self.matchBtn.enabled = false
        self.unmatchBtn.enabled = false
        
        
    }
    
    func loadingVisual(notification:NSNotificationCenter){
        let image = UIImage(data: NSData(contentsOfURL:data.getPicLocation(counter-1))!)
        imgView.image = image
    }
    
    func changeQuestion(notification:NSNotificationCenter){
        
        if counter < NUMBER_OF_TEST - 1 {
            counter += 1
            if counter == 1{
                self.spinner.stopAnimating()
                
                self.textForDenotingDownloading.removeFromSuperview()
                currentDate = NSDate()
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                covertedDate = dateFormatter.stringFromDate(currentDate!)
            }
            print("current item number:\(counter)")
           // print("corrected ans is:\(data.getCorrectedAns(counter))")
        } else {
            endTime = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            convertedEndTime = dateFormatter.stringFromDate(endTime!)
            writeToJSON()
            timer.invalidate()
            
            print("task finished")
            
            let endT = endTime?.timeIntervalSince1970
            let startT = currentDate?.timeIntervalSince1970
            print("end time is:\(endT! - startT!)")
        }
    }
    
    func startCounting(notification:NSNotificationCenter){
        
        startAnsTiming = NSDate()
        
        print(startAnsTiming?.timeIntervalSince1970.description)
    }
    
    func writeToJSON(){
        
        var json:JSON
        var jsonArray = [JSON]()
        
        json = ["block":"\(currentBlock)","start_time":"\(currentDate!)","completedAt":"\(convertedEndTime!)","end_time":""]
        
        var innerLayerOfJSON :JSON?
        
        
        var point = 0.0
        for i in 0...NUMBER_OF_TEST-2{
            if answers[i].1 == data.getCorrectedAns(i) {
                point += 1.0
            }
            print("your ans:\( answers[i].1),and the right one is:\(data.getCorrectedAns(i) )")
            innerLayerOfJSON =
                            ["auditoryStimulusFilename":data.getSoundFileName(i),"visualStimulusFilename":data.getPicsFileName(i),"responseTimeSeconds":"\(answers[i].0)","reponse":"\(answers[i].1)"]
            jsonArray.append(innerLayerOfJSON!)
        }
        
        
        
        json["stimulusResponses"].string = "\(jsonArray)"
        
        //print("the json data is :\(json.description)")
        
        let jsonParams:[String:AnyObject]? = json as? [String:AnyObject]

        
        Alamofire.request(.POST,"https://obscure-sierra-33935.herokuapp.com/api/uploadRecord", parameters:["block":"\(self.currentBlock)","start_time":"\(self.covertedDate!)","end_time":"\(self.convertedEndTime!)","ratio":"\(point/Double(NUMBER_OF_TEST))","account":"yam7611"]).responseJSON{
            response in
            
            if let JSON = response.result.value{
                print("JSON:\(JSON)")
            }
        }
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
