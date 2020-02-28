//
//  OfferCVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 09/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import SDWebImage
class CartTVC: UITableViewCell {

    var refreshProduct : (()->())?
    
    
    @IBOutlet weak var categroyLbl :UILabel!
    @IBOutlet weak var titleLbl :UILabel!
    @IBOutlet weak var priceLbl :UILabel!
    @IBOutlet weak var priceAfterCommissionLbl :UILabel!
    @IBOutlet weak var createAtlbl :UILabel!
    @IBOutlet weak var imgView :UIImageView!
    
    
    
    
    @IBOutlet weak var counterLbl :UILabel!

    @IBOutlet weak var removeBtn :UIButton!

 
    
    
    var oldPrice = "" {
        didSet{
            if oldPrice.isEmpty{
                priceLbl.text = ""
                return
            }
        
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string:oldPrice)
              attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
              priceLbl.attributedText = attributeString
            
        }
    }
    
    
    
    
    var rProduct :RProduct? {
        didSet{
            let rPro = rProduct!
            titleLbl.text = rPro.name
            
            categroyLbl.text = rPro.category
            
//             let formatter = DateFormatter()
//             formatter.locale = Locale(identifier: "en")
//             formatter.dateFormat = "dd MMM yyyy - hh:mm"
//
//          createAtlbl.text = formatter.string(from: rPro.date)
            createAtlbl.text = ""
            
            imgView.sd_setImage(with: URL(string: rPro.image), completed: nil)
            counterLbl.text = rPro.quantity.description
            
            
             
            
            
            if !rPro.priceAfterCommition.isEmpty {
                priceAfterCommissionLbl.text = rPro.priceAfterCommition.valueWithCurrency
                oldPrice = rPro.price.valueWithCurrency
            }else{
                priceAfterCommissionLbl.text = rPro.price.valueWithCurrency
                 oldPrice = ""
            }
            
            
            
 
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
 
//        self.addToCartButton.applyGradient(colours: [#colorLiteral(red: 0.9951180816, green: 0.5745646358, blue: 0.1128445193, alpha: 1), #colorLiteral(red: 0.9374084473, green: 0.2829045057, blue: 0, alpha: 1)],gradientOrientation : GradientOrientation.horizontal)

    }

    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        let image = UIImage(named: "ic_addreess_delete")?.withRenderingMode(.alwaysTemplate)
        removeBtn.setImage(image, for: .normal)
        removeBtn.imageEdgeInsets.left = 8
        removeBtn.imageEdgeInsets.right = 0
//        removeBtn.tintColor = UIColor.CustomColor.primaryColor
        
        
        if AppDelegate.shared.language == "en" {
                        removeBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
                    }
        
    }
    
    
    
    @IBAction func plus(_ sender :UIButton){
        
        RealmHelper.incrementQuantity(forProduct: rProduct!)
        counterLbl.text = rProduct!.quantity.description
        refreshProduct?()
        //updateTotalPrice()
        
    }
    
    @IBAction func minus(_ sender :UIButton){
        if rProduct!.quantity > 0 {
            RealmHelper.decrementQuantity(forProduct: rProduct!)
            counterLbl.text = rProduct!.quantity.description
            refreshProduct?()
           // updateTotalPrice()
         }
    }
    
    
    
//    func updateTotalPrice(){
//        NotificationCenter.default.post(name: NSNotification.Name(CartVC.UPDATE_TOTAL_PRICE_OBSERVER), object: nil)
//
//    }
//
}
