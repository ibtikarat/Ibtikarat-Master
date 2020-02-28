//
//  CategoryTVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 25/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class CategoryTVC: UITableViewCell {

    
    @IBOutlet weak var selectedLineView :UIView!
    
    @IBOutlet weak var titelLbl :UILabel!

    
    var category :Category = Category(){
        didSet{
            category.isSelected ? selectedBackgorund() :unSelectedBackgorund()
            titelLbl.text = category.name
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
 
    
    
    func selectedBackgorund(){
        self.contentView.backgroundColor = UIColor.white
        self.selectedLineView.backgroundColor = UIColor.CustomColor.primaryColor
        titelLbl.textColor = UIColor.CustomColor.primaryColor
    }
    
    
    func unSelectedBackgorund(){
        self.contentView.backgroundColor = UIColor(rgb: 0xECEEEE)
        self.selectedLineView.backgroundColor = UIColor.clear
        titelLbl.textColor = UIColor.CustomColor.grayDark

    }
}
