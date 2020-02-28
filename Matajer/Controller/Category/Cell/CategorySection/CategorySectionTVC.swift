//
//  CategorySectionTVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 01/10/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class CategorySectionTVC: UITableViewCell {

    @IBOutlet weak var inducatorImage :UIImageView!
    @IBOutlet weak var titelLbl :UILabel!

    var isExpand :Bool = true {
        didSet{
            if isExpand {
                inducatorImage.image = UIImage(named: "ic_inducator_expand")!
            }else{
                inducatorImage.image = UIImage(named:  "ic_inducator_collapse")!
            }
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
