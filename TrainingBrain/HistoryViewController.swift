//
//  HistoryViewController.swift
//  TrainingBrain
//
//  Created by yam7611 on 2/19/17.
//  Copyright © 2017 yam7611. All rights reserved.
//

import UIKit
import Alamofire

class HistoryViewController: UIViewController {
    
    
    // to store all the records related to one particular user
    var records = [Record?]()
    var recordDictionary = [String:Record]()
    
    @IBOutlet var buttons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchUserHistoryFromServer()
        
    }
    
    
    
    //this function involves the process to fetch data from server
    func fetchUserHistoryFromServer(){
        Alamofire.request(.POST,"https://obscure-sierra-33935.herokuapp.com/api/requireHistory/yam7611").responseJSON{
            response in
            
            if let JSON = response.result.value{
                //print("json : \(JSON)")
                
                if let dict = JSON as? NSArray{
                    for i in 0...dict.count - 1 {
                        // print("get rsult:\(dict[i])")
                        if let dic = dict[i] as? NSDictionary{
                            let record = Record(dict: dic)
                            self.records.append(record)
                        }
                        
                    }
                    self.setUpButton()
                }
            }
        }

    }
    
    func setUpButton(){
        
        for i in 0...records.count - 1{
            let record = records[i]
            if let dateNumber = record?.getDate(){
                let buttonId = Int(dateNumber)! - 1
                self.buttons[buttonId].setTitleColor(UIColor.redColor(), forState: .Normal)
                recordDictionary["\(dateNumber)"] = record
                //print("\(dateNumber)'s record:\(record?.getDate())")
                
            }
            
        }
    }
    
    @IBAction func acquireDetail(sender: UIButton) {
        if let index = Int(sender.accessibilityLabel!){
            self.performSegueWithIdentifier("segueToRecordView", sender: recordDictionary["\(index+1)"])
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let dvc = segue.destinationViewController as? RecordViewController
        
        dvc?.record = sender as? Record
    }
    
}
