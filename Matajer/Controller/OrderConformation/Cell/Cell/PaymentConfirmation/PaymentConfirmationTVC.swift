//
//  PaymentConfirmationTVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 26/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import SDWebImage
class PaymentConfirmationTVC: UITableViewCell {
        //unselected color #BFBFBF
    
    @IBOutlet weak var paymentContent :UIView!
    @IBOutlet weak var titleLbl :UILabel!
    @IBOutlet weak var imgView :UIImageView!
    @IBOutlet weak var checkBoxView :UICheckBox!

    var paymentMethod :PaymentMethod?  {
        didSet{
            var paymentMet = paymentMethod!
            
            titleLbl.text = paymentMet.title
            imgView.image = paymentMet.image
            
            
            paymentMet.isSelected ? selectedBackgorund() : unSelectedBackgorund()
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
//        self.paymentContent.layer.borderColor = UIColor.CustomColor.colorPrimary.cgColor
        
        checkBoxView.isChecked = true

    }
    
    
    func unSelectedBackgorund(){
//    self.paymentContent.layer.borderColor = UIColor.CustomColor.grayLight.cgColor
        
        checkBoxView.isChecked = false

    }
    
    
    
}
