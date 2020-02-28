//
//  NotiticationTVCTableViewCell.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 25/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class NotiticationTVC: UITableViewCell {
    @IBOutlet weak var titleLbl :UILabel!
    @IBOutlet weak var contentLbl :UILabel!
    @IBOutlet weak var createdAtLbl :UILabel!
    
    
    @IBOutlet weak var verticalLine :UIView!
    
  
    
    
    var notification :Notification? {
        didSet{
            let notify = notification!
            titleLbl.text = notify.title
            contentLbl.text = notify.content
            
            if !notify.isSeen {
                verticalLine.backgroundColor = UIColor.CustomColor.primaryColor
            }else{
                verticalLine.backgroundColor = UIColor.white
            }
   
            createdAtLbl.text = Date.changeFormat(dateString: notify.createdAt)

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
