//
//  MenuViewController.swift
//  TrainingBrain
//
//  Created by yam7611 on 2/14/17.
//  Copyright © 2017 yam7611. All rights reserved.
//

import UIKit
import Alamofire

class MenuViewController: UIViewController {
    var user: User?{
        didSet{
            print("user account is:\(user?.account)")
        }
    }
    
    
    @IBOutlet weak var greetingLabel: UILabel!
    
    @IBOutlet var buttons: [UIButton]!
    
    var array:NSMutableArray = []
    
    
    @IBAction func pressSession(sender: UIButton) {
        
       // print(sender.titleLabel)
        
//        if let user1 = user{
//           
//        
//        }
        
        let number = Int(sender.accessibilityLabel!)
        
        self.performSegueWithIdentifier("segueToDetail", sender: array[number!])
        
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName("userInfo123", object: nil, userInfo: ["user":"123"])
        
        
        self.greetingLabel.text = "Welcome back,\((user?.name)!) \n Please select the session below"
        
        Alamofire.request(.GET,"http://115.146.91.233/api/task-specifications").responseJSON{response in
            
            if let JSON = response.result.value{
                self.array = JSON as! NSMutableArray
                
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let dvc = segue.destinationViewController as?  DetailViewController
        
        guard let destinationVC = dvc else {
            return
        }
        
        destinationVC.data = sender
       
    }
    
    
}
