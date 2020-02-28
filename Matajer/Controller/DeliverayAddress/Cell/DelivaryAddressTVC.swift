//
//  DelivaryAddressTVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 25/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class DelivaryAddressTVC: UITableViewCell {

    
    
    
    var deleteAddressAction : ((Address)->())?
    var updateAddressAction : ((Address)->())?
    
    
    @IBOutlet weak var phoneLbl :UILabel!
    @IBOutlet weak var addressLbl :UILabel!
    @IBOutlet weak var titleLbl :UILabel!
    @IBOutlet weak var checkBox :UICheckBox!
    
    
    var address :Address?{
        didSet{
            let addres = address!
            titleLbl.text = addres.title
            addressLbl.text = addres.addressDetails + "," + addres.region
            phoneLbl.text = addres.phone
            checkBox.isChecked = addres.isDefult
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
    
    
    
    @IBAction func deleteAddress(_ sender :UIButton){
        deleteAddressAction?(address!)
    }
    
    @IBAction func updateAddress(_ sender :UIButton){
        updateAddressAction?(address!)

    }
    
    
}
