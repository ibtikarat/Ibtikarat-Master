//
//  PaymentConfirmationTVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 26/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class AddressConfirmationTVC: UITableViewCell {
        //unselected color #BFBFBF
    
    @IBOutlet weak var paymentContent :UIView!
    @IBOutlet weak var inducatorImage :UIImageView!
   
    
    
    @IBOutlet weak var checkBoxView :UICheckBox!
    @IBOutlet weak var titleLbl :UILabel!
    @IBOutlet weak var addressLbl :UILabel!

    @IBOutlet var addOrChangeAddressBtn :UIButton!
    
    var isChangeAddress :Bool = false {
        didSet{
            if addOrChangeAddressBtn != nil {
                       if isChangeAddress {
                           addOrChangeAddressBtn.setTitle("change_address".localized, for: .normal)
                       }else{
                           addOrChangeAddressBtn.setTitle("add_address".localized, for: .normal)
                       }
                   }
        }
    }
    
    
    
    var address :Address? {
        didSet{
            let _address = address!
            titleLbl.text = _address.title
            addressLbl.text = _address.addressDetails
            checkBoxView.isChecked = _address.isDefult
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
    
    
    
    
    
    @IBAction func showMyAddressPage(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc =  AppDelegate.shared.viewController
        let navbar :AddressNVC = storyboard.instanceVC()

        if isChangeAddress {
        let delivaryAddressVC :DelivaryAddressVC = storyboard.instanceVC()
            navbar.viewControllers = [delivaryAddressVC]
            
        }else{
            let delivaryAddressVC :MapAddressVC = storyboard.instanceVC()
                navbar.viewControllers = [delivaryAddressVC]
        }
        
        
        vc.present(navbar, animated: false,pushing: true, completion: nil)

    }
}
