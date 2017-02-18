//
//  SignUpViewController.swift
//  TrainingBrain
//
//  Created by yam7611 on 2/13/17.
//  Copyright © 2017 yam7611. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var accountTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var repasswordTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
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
    
    @IBAction func send(sender: UIButton) {
        
        guard let accountText = accountTextField.text,passwordText = passwordTextField.text,repassText =  repasswordTextField.text,nameText = nameTextField.text else{
                return
        }
        if passwordText == repassText{
            
            
            
            Alamofire.request(.POST,"https://obscure-sierra-33935.herokuapp.com/api/signUp",parameters: ["account": accountText,"password":passwordText,"name":nameText]).responseJSON{response in
            
            print(response.request)
            print(response.response)
            print(response.data)
            print(response.result)
                
                if let JSON = response.result.value{
                    print("JSON:\(JSON)")
                    
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
        
       
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("user's name is :\(self.user.name)")
        
        
        if let dvc = segue.destinationViewController as? MenuViewController{
            
            dvc.user = sender as? User
            
        }
        
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
