//
//  WorkoutTableViewCell.swift
//  projectCARE
//
//  Created by Cindy Lu on 2/21/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {
    let store:HealthStore = HealthStore.getInstance()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBAction func WorkoutSessionSelected(_ sender: Any) {
    }
    @IBOutlet weak var WorkoutSessionSelected: UIButton!
    
//    setFrame:(CGRect)frame {
//        frame.origin.y += 4;
//        frame.size.height -= 2 * 4;
//        [super setFrame:frame];
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
