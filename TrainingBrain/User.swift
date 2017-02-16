//
//  User.swift
//  TrainingBrain
//
//  Created by yam7611 on 2/14/17.
//  Copyright © 2017 yam7611. All rights reserved.
//

import Foundation

class User:NSObject{
    
    var account:String = ""
    var name:String = ""
    var email:String = ""
    var scores = [String:String]()
    
    override init(){
        super.init()
    }

}
