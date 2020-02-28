//
//  OfferCVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 09/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import Loady
class OfferCVC: UICollectionViewCell {

 
    
    
    @IBOutlet weak var addToCartButton :AddToCartButton!
    @IBOutlet weak var commistionPriceLbl :UILabel!
    @IBOutlet weak var titleProduct :UILabel!
    @IBOutlet weak var descriptionProduct :UILabel!
    @IBOutlet weak var offerLabel :UILabel!
    @IBOutlet weak var addToFav :UICheckBox!
    @IBOutlet weak var productImage :UIImageView!
    @IBOutlet weak var priceLbl :UILabel!

    
    var commistionPrice = " 500 ر.س" {
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
    
    
    var product :Product? {
        didSet{
            let pro = product!
           
            if !pro.priceAfterDiscountValue.isEmpty {
                commistionPriceLbl.text = pro.priceAfterDiscountValue
                commistionPrice = pro.priceValue
            }else{
                 commistionPriceLbl.text = pro.priceValue
                 commistionPrice = ""
            }
          
            titleProduct.text = pro.category?.name
            descriptionProduct.text = pro.name
//            descriptionProduct.attributedText = pro.reviewsDescription.htmlAttributedString
            offerLabel.isHidden = !pro.isOffer
            productImage.sd_setImage(with: URL(string:pro.image)!, completed: nil)
            addToFav.isChecked = pro.isFavorite

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        if AppDelegate.shared.language == "en" {
            addToCartButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        }
        
//        addToCartButton.setAnimation(LoadyAnimationType.topLine())

    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
//              self.addToCartButton.applyGradient(colours: [UIColor.CustomColor.colorAccent, UIColor.CustomColor.colorPrimary],gradientOrientation : GradientOrientation.horizontal)
        
    }
    
    

}
