//
//  MyRatingTVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 25/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class OfferDetailsTVC: UITableViewCell {

    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var specificationLbl: UILabel!

    
    var descriptionProduct :String = "" {
        didSet{
            descriptionLbl.text = descriptionProduct.htmlAttributedString?.string
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
