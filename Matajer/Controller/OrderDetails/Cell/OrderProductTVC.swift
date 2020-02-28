//
//  OrderTVCTableViewCell.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 29/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class OrderProductTVC: UITableViewCell {

    
    
      @IBOutlet weak var addReputation :UIButton!
      @IBOutlet weak var reOrder :UIButton!
 
    
      @IBOutlet weak var priceLbl :UILabel!
      @IBOutlet weak var categoryLbl :UILabel!
      @IBOutlet weak var titleLbl :UILabel!
      @IBOutlet weak var quantityLbl :UILabel!
      @IBOutlet weak var productImage :UIImageView!
      
      
      
      
      var product :Product? {
          didSet{
              let pro = product!
              priceLbl.text = pro.priceValue
              categoryLbl.text = pro.category?.name
              titleLbl.text =  pro.name
              quantityLbl.text =  "(x\(pro.quantity!.description))"
              productImage!.sd_setImage(with: URL(string:pro.image)!, completed: nil)
              
          }
      }
      
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        if AppDelegate.shared.language == "en" {
                   let imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
                   addReputation.imageEdgeInsets = imageEdgeInsets
                   reOrder.imageEdgeInsets = imageEdgeInsets
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
}
