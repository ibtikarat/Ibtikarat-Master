//
//  OfferCVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 09/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class FavoriteCVC: UICollectionViewCell {

    var clickedAddToCart :((Product) ->())?

    
    @IBOutlet weak var addToCartButton :UIButton!
    
    
      @IBOutlet weak var commistionPriceLbl :UILabel!
       @IBOutlet weak var titleProduct :UILabel!
       @IBOutlet weak var descriptionProduct :UILabel!
       @IBOutlet weak var offerLabel :UILabel!
       @IBOutlet weak var removeToFav :UIButton!
       @IBOutlet weak var productImage :UIImageView!
       @IBOutlet weak var priceLbl :UILabel!

       
       var commistionPrice = "" {
           didSet{
            if  commistionPrice.isEmpty{
                commistionPriceLbl.text = ""
                return
            }
               let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string:commistionPrice)
                 attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                 commistionPriceLbl.attributedText = attributeString
            
               
            
           }
       }
       
       
       var product :Product? {
           didSet{
               let pro = product!
            
            if !pro.priceAfterDiscountValue.isEmpty{
                     priceLbl.text = pro.priceAfterDiscountValue
                     commistionPrice = pro.priceValue
            }else{
                priceLbl.text = pro.priceValue
                commistionPrice = ""
            }
     
            titleProduct.text = pro.category?.name
            descriptionProduct.text = pro.name
               offerLabel.isHidden = !pro.isOffer
               productImage.sd_setImage(with: URL(string:pro.image)!, completed: nil)
           }
       }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.addToCartButton.applyGradient(colours: [#colorLiteral(red: 0.9951180816, green: 0.5745646358, blue: 0.1128445193, alpha: 1), #colorLiteral(red: 0.9374084473, green: 0.2829045057, blue: 0, alpha: 1)],gradientOrientation : GradientOrientation.horizontal)
        if AppDelegate.shared.language == "en" {
            addToCartButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        }
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addToCartButton.applyGradient(colours: [UIColor.CustomColor.primaryColor2,UIColor.CustomColor.primaryColor],gradientOrientation : GradientOrientation.horizontal)
    
    }
    
    
    @IBAction func addToCart(_ sender :UIButton){
        clickedAddToCart?(product!)
    }
    
}
