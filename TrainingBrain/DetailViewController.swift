//
//  DetailViewController.swift
//  TrainingBrain
//
//  Created by yam7611 on 2/14/17.
//  Copyright © 2017 yam7611. All rights reserved.
//

import UIKit
import Alamofire


class DetailViewController: UIViewController {

    var data:AnyObject?
    var dictionary = [String:AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        let dictionary = data as? NSDictionary
        let linkArray = dictionary!["links"]! as? NSArray
        let linkInfo = linkArray![1] as? NSDictionary
        let link = linkInfo!["href"]
        //print("the content recived from prev vc is:\(link!)")
        
        Alamofire.request(.GET,"\(link!)").responseJSON{response in
            
            if let JSON = response.result.value{
                print("JSON:\(JSON)")

            }
            
        }
    }
}
