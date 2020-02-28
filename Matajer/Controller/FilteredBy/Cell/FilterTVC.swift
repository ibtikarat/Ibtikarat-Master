//
//  FilterTVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 21/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class FilterTVC: UITableViewCell {

    
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var selectedLbl:UILabel!
    
    
    
    var filterObject :FilterObject? {
        didSet{
            nameLbl.text = filterObject!.value
            selectedLbl.text = filterObject!.selectedItemName
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
