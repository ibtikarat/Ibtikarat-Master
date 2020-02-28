//
//  ProductIInComfirmationTVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 26/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import SDWebImage
class ProductIInConfirmationTVC: UITableViewCell {

    
    @IBOutlet weak var commistionPriceLbl :UILabel!
    @IBOutlet weak var categoryLbl :UILabel!
    @IBOutlet weak var titleLbl :UILabel!
    @IBOutlet weak var productImage :UIImageView!
    @IBOutlet weak var priceLbl :UILabel!
    
    
    
    var commistionPrice = "" {
          didSet{
              if commistionPrice.isEmpty {
                    priceLbl.text = commistionPrice
                  return
              }
              let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string:commistionPrice)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                priceLbl.attributedText = attributeString
              
          }
      }
      
    
    
    
    var product :Product?  {
        didSet{
            if let  pro = product {



          if !pro.priceAfterDiscountValue.isEmpty {
              commistionPriceLbl.text = pro.priceAfterDiscountValue
              commistionPrice = pro.priceValue
          }else{
               commistionPriceLbl.text = pro.priceValue.valueWithCurrency
               commistionPrice = ""
          }
                
                
     
            
            categoryLbl.text = pro.category?.name
            titleLbl.text = pro.name
            
            productImage.sd_setImage(with: URL(string: pro.image)!, completed: nil)
            
            }
            
        }
    }
    
    
    var rproduct :RProduct?  {
          didSet{
              if let  pro = rproduct {

              
              if !pro.priceAfterCommition.isEmpty {
                  commistionPriceLbl.text = pro.priceAfterCommition.valueWithCurrency
                  commistionPrice = pro.price.valueWithCurrency
              }else{
                  commistionPriceLbl.text = pro.price.valueWithCurrency
                   commistionPrice = ""
              }
              
              
              categoryLbl.text = pro.category
              titleLbl.text = pro.name
              
              productImage.sd_setImage(with: URL(string: pro.image)!, completed: nil)
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
