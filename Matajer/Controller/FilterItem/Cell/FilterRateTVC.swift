//
//  FilterRateTVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 21/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import Cosmos
class FilterRateTVC: UITableViewCell {

    
    @IBOutlet weak var rateView :CosmosView!
    @IBOutlet weak var checkBtn:UICheckBox!

    
    
    var filterItem :FilterItem? {
         didSet{
            rateView.rating = Double(filterItem!.id)
            checkBtn.isChecked = filterItem!.isSelected
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
