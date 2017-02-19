//
//  RecordViewController.swift
//  TrainingBrain
//
//  Created by yam7611 on 2/19/17.
//  Copyright © 2017 yam7611. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var blockLabel: UILabel!
    @IBOutlet weak var ratioLabel: UILabel!
    
    
    var record:Record?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLabel()
       
    }
    func setLabel(){
        startTimeLabel.text = record?.getStartTime()
        endTimeLabel.text = record?.getEndTime()
        ratioLabel.text = record?.getRatio()
        blockLabel.text = record?.getBlock()
    }
    
}
