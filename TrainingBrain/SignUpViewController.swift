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
            
            
            
            Alamofire.request(.POST,"https://obscure-sierra-33935.herokuapp.com/signUp",parameters: ["account": accountText,"password":passwordText,"name":nameText]).responseJSON{response in
            
            print(response.request)
            print(response.response)
            print(response.data)
            print(response.result)
                
                if let JSON = response.result.value{
                    print("JSON:\(JSON)")
                }
            }
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
