//
//  scheduleTableViewCell.swift
//  CountDown
//
//  Created by NANZI WANG on 4/27/17.
//  Copyright © 2017 PrettyMotion. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var scheduleTime: UILabel!
    @IBOutlet weak var scheduleCountDown: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
