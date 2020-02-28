//
//  PaymentConfirmationTVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 26/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import SDWebImage

class ShippingMethodConfirmationTVC: UITableViewCell {
        //unselected color #BFBFBF
    
    @IBOutlet weak var paymentContent :UIView!
    @IBOutlet weak var inducatorImage :UIImageView!
   
    
    @IBOutlet weak var checkBoxView :UICheckBox!
    @IBOutlet weak var titleLbl :UILabel!
    @IBOutlet weak var deliveryTimeLbl :UILabel!
    @IBOutlet weak var priceLbl :UILabel!
    @IBOutlet weak var imgView :UIImageView!

//    let id: Int
//    let deliveryTime, price, title: String
//    let img: String

    
    var shippingMethod :ShippingMethod? {
        didSet{
            let _shippingMethod = shippingMethod!
            titleLbl.text = _shippingMethod.title
            deliveryTimeLbl.text = _shippingMethod.deliveryTime! + " " + "day".localized
            priceLbl.text = _shippingMethod.price.valueWithCurrency
            imgView.sd_setImage(with: URL(string: _shippingMethod.img), completed:  nil)
            checkBoxView.isChecked  = _shippingMethod.isSelected
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if inducatorImage != nil {
        inducatorImage.image = UIImage(named: "ic_inducator_forward")!.withRenderingMode(.alwaysTemplate)
        inducatorImage.tintColor = UIColor.black
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    
    
    func selectedBackgorund(){
        self.paymentContent.layer.borderColor = UIColor.CustomColor.primaryColor.cgColor
    }
    
    
    func unSelectedBackgorund(){
        self.paymentContent.layer.borderColor = UIColor.CustomColor.grayDark.cgColor
    }
    
    
    
}
