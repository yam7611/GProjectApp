//
//  LoginViewController.swift
//  TrainingBrain
//
//  Created by yam7611 on 2/13/17.
//  Copyright © 2017 yam7611. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    
    @IBOutlet weak var accountTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var tempDict :NSMutableDictionary?
    var user = User()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func login(sender: UIButton) {
        
        guard let accountText = accountTextField.text,passwordText = passwordTextField.text else{
            return
        }
        
        Alamofire.request(.POST,"https://obscure-sierra-33935.herokuapp.com/api/todo/",parameters: ["account":accountText,"password":passwordText]).responseJSON{ response in
            if let JSON = response.result.value{
                self.tempDict = JSON as? NSMutableDictionary
                if self.tempDict!["name"]! as! String != "null"{
                    
                    self.user.name = self.tempDict!["name"]! as! String
                    self.user.account = self.tempDict!["account"]! as! String
                    self.performSegueWithIdentifier("segueToMenu", sender: self.user)
                } else {
                    print("wrong password")
                }
               
            }
        }
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("user's name is :\(self.user.name)")
        
        
        if let dvc = segue.destinationViewController as? MenuViewController{
            
            dvc.user = sender as? User
           
        }
        
        
    }

}
