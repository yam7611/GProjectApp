//
//  ViewController.swift
//  TrainingBrain
//
//  Created by yam7611 on 12/14/16.
//  Copyright © 2016 yam7611. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AVFoundation

class ViewController: UIViewController {

    let url = "http://115.146.91.233"
    var adPlayer : AVAudioPlayer!
    var fstSoundUrl : String = ""
    
    var photoData:NSData?
    var soundData:NSData?
    
    var picNumber = 0
    var soundNumber = 0
    var photoArray:[NSData] = []
    var soundArray:[NSData] = []
    
    var soundUrl : NSURL?
    var player : AVAudioPlayer?
    @IBOutlet weak var textField: UITextField!
    var currentPage:Int = 0{
        
        
        didSet{
            print("currentPage is:\(currentPage)")
            if let imgData = photoData{
                imageView.image = UIImage(data:photoArray[currentPage])
                
                do {
                    
                    soundUrl = fetchDocumentPath().URLByAppendingPathComponent("\(currentPage).mp3")
                    
                    guard let newSoundURL = soundUrl else{
                        return
                    }
                    player = try AVAudioPlayer(contentsOfURL: newSoundURL)
                    
                }catch let error as NSError{
                    print("error:\(error.description)")
                }
            }
        }
        
    }
    @IBAction func saveButtonTapped(sender: UIButton) {
        
        guard let todoItem = textField.text else{
            return
        }
        
        Alamofire.request(.POST,"https://obscure-sierra-33935.herokuapp.com/todo",parameters: ["name":todoItem])
        textField.text = ""
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(.GET,"https://obscure-sierra-33935.herokuapp.com/todo").responseJSON{response in
            
            print(response.request)
            print(response.response)
            print(response.data)
            print(response.result)
            
            if let JSON = response.result.value{
                print("JSON:\(JSON)")
            }
        }
//        
//        if let usrString = NSURL(string: url+"/api/trials/chinese-characters-session-1"){
//            if let data = NSData(contentsOfURL: usrString){
//                let json = JSON(data:data)
//                
//                let fstAtt = json["trialId"]
//                
//                let auditoryStimulusRoot = json["auditoryStimulusRoot"]
//                let visualStimulusRoot = json["visualStimulusRoot"]
//                
//                
//                for i in 0...json["stimulusPairs"].count {
//                    let fstImg = json["stimulusPairs"][i]["visualStimulusFilename"]
//                    
//                    let fstSound = json["stimulusPairs"][i]["auditoryStimulusFilename"]
//                    
//                    let fstPicUrl = url + visualStimulusRoot.stringValue + "/" + fstImg.stringValue
//                    
//                    let fstSoundUrl = url + auditoryStimulusRoot.stringValue + "/" + fstSound.stringValue
//                    
//                    photoData = NSData(contentsOfURL: NSURL(string:fstPicUrl)!)
//                    soundData = NSData(contentsOfURL: NSURL(string:fstSoundUrl)!)
//                    
//                    
//                    if let photoData1 = photoData{
//                        photoArray.insert(photoData1, atIndex: i)
//                        
//                    }
//                    
//                    if let soundData1 = soundData{
//                        soundArray.insert(soundData1,atIndex:i)
//                    }
//                   
//                    picNumber += 1
//                    soundNumber += 1
//                    let destinationPhotoUrl = fetchDocumentPath().URLByAppendingPathComponent("\(picNumber).jpeg")
//                    let destinationSoundUrl = fetchDocumentPath().URLByAppendingPathComponent("\(soundNumber).mp3")
//                    
//                    _ = try? photoData?.writeToURL(destinationPhotoUrl, options: .DataWritingFileProtectionComplete)
//                    _ = try? soundData?.writeToURL(destinationSoundUrl, options: .DataWritingFileProtectionComplete)
//                    
//                    
//                }
//                
//                
//            }
//        }
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func playSoundd(sender: UIButton) {

        player?.prepareToPlay()
        player?.play()
    }
    
    @IBAction func goToNext(sender: UIButton) {
        currentPage += 1
        //print("current page:\(currentPage)")
    }
    @IBAction func goToPrev(sender: UIButton) {
        currentPage -= 1
        //print("current page:\(currentPage)")
    }

    @IBAction func playSound(sender: UIButton) {
        
        if let audioUrl = NSURL(string :fstSoundUrl){
            
//            let documentsDirectoryURL = NSFileManager().URLsForDirectory( .DocumentDirectory,inDomains:.UserDomainMask).first!
//            
            let destinationUrl = fetchDocumentPath().URLByAppendingPathComponent("Test")

            let fileUrl = fetchDocumentPath().URLByAppendingPathComponent("f1.jpeg")
            
            
            let soundFileURL = fetchDocumentPath().URLByAppendingPathComponent("sound.mp3")
            
            
            
            _ = try? photoData?.writeToURL(fileUrl, options: .DataWritingFileProtectionComplete)
            _ = try? soundData?.writeToURL(soundFileURL, options: .DataWritingFileProtectionComplete)
            
            print("the destination is:\(destinationUrl)")
            
            if NSFileManager().fileExistsAtPath(fileUrl.path!){
                print("The file already exsist at path")
            } else {
                print("go to else")
                NSURLSession.sharedSession().downloadTaskWithURL(audioUrl,completionHandler: {(data,response,error) -> Void in

                    
                    
                    if error == nil {
                        print("succ")
                    } else {
                        do {
                            try NSFileManager().moveItemAtURL(audioUrl, toURL: fileUrl)
                        } catch let error1 as NSError{
                            print("the error is:\(error1.localizedDescription)")
                        }
                    }
 
                
                }).resume()
                
            }
            
        }
    }
    
    func fetchDocumentPath() -> NSURL{
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentPath = paths[0]
        
        return documentPath
    }
    
    func play(url:NSURL){
        do {
            let ad1Player = try AVAudioPlayer(contentsOfURL:url)
            
            adPlayer = ad1Player
            adPlayer.play()
            
            print("sound url:" + fstSoundUrl)
            
            
        }catch{
            print("error")

        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

