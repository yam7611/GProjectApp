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
    var user: User?
    @IBOutlet weak var greetingLabel: UILabel!
    
    @IBOutlet var buttons: [UIButton]!
    
    var array:NSMutableArray = []
    
    
    @IBAction func pressSession(sender: UIButton) {
    
        
        let number = Int(sender.accessibilityLabel!)
        
        self.performSegueWithIdentifier("segueToDetail", sender: array[number!])
        
        NSNotificationCenter.defaultCenter().postNotificationName("passUserInfo", object: nil, userInfo: ["user":self.user!])
    
    }
    
    override func viewDidLoad() {
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(parseUserInfo(_:)), name: "passUserInfo", object: nil)
        super.viewDidLoad()
        
        Alamofire.request(.GET,"http://115.146.91.233/api/task-specifications").responseJSON{response in
            
            if let JSON = response.result.value{
                self.array = JSON as! NSMutableArray
                
            }
        }
    }
    
    
    func parseUserInfo(notification:NSNotification){
        
        if let userInfo = notification.userInfo{
            if let user = userInfo["user"] as? User{
                self.user = user
                self.greetingLabel.text = "Welcome back,\(self.user!.name)"
                
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
