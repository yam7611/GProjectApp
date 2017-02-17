//
//  DetailViewController.swift
//  TrainingBrain
//
//  Created by yam7611 on 2/14/17.
//  Copyright © 2017 yam7611. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailViewController: UIViewController {

    var data:AnyObject?
    var dictionary = [String:AnyObject]()
    var linkDict:NSDictionary? = [String:AnyObject]()
    var buttonId = ""
    let url = "http://115.146.91.233"
    var visualRoot:String? = ""
    var soundRoot:String? = ""
    var blockDetailDict:NSDictionary? = [String:AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let dictionary = data as? NSDictionary
        let linkArray = dictionary!["links"]! as? NSArray
        let linkInfo = linkArray![1] as? NSDictionary
        let link = linkInfo!["href"]
        //print("the content recived from prev vc is:\(link!)")
        
        Alamofire.request(.GET,"\(link!)").responseJSON{response in
            
            if let JSON = response.result.value{
                //print("JSON:\(JSON)")
                if let dict = JSON as? NSDictionary{
                    //print("the links are:\(dict["_links"])")
                    
                    self.linkDict = dict["_links"] as? NSDictionary
                    //print("thr first link is\(self.linkDict?["blockSpecification"])")
                    if let url = self.linkDict?["blockSpecification"] as? NSDictionary{
                        self.fetchQuestionDetail(url["href"] as? String)
                    }
                }
            }
            
        }
    }
    
    func fetchQuestionDetail(urlString:String?){
        
        if let url = urlString{
            Alamofire.request(.GET,"\(url)").responseJSON{
                response in
                if let JSON = response.result.value{
                    //print("json is: \(JSON)")
                    if let quesitonDict = JSON as? NSDictionary{
                        self.blockDetailDict = quesitonDict
                        
                        self.visualRoot = quesitonDict["visualStimulusRoot"] as? String
                        self.visualRoot = self.url + self.visualRoot!
                        self.soundRoot = quesitonDict["auditoryStimulusRoot"] as? String
                        self.soundRoot = self.url + self.soundRoot!
                        //print(self.soundRoot)
                        
                    }
                }
            }
        }
        //print("root is:\(self.visualRoot)")
    }
    @IBAction func pressBlock(sender: UIButton) {
        self.performSegueWithIdentifier("segueToDetailQuestion", sender: self.blockDetailDict)
            //buttonId =
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //
        if let dvc = segue.destinationViewController as? QuestionViewController{
            dvc.questionDetailDict = sender as? NSDictionary
        }
    }
}
