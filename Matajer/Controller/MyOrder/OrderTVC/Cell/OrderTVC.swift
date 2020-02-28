//
//  OrderTVCTableViewCell.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 29/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import SDWebImage
class OrderTVC: UITableViewCell {
    @IBOutlet weak var stepper :CustomStepper!
    
    
    @IBOutlet weak var invoiceBtn :UIButton!
    @IBOutlet weak var bankTransferBtn :UIButton!
    @IBOutlet weak var reOrderBtn :UIButton!
    
    
    @IBOutlet weak var dateLbl :UILabel!
    @IBOutlet weak var orderNumberLbl :UILabel!
    @IBOutlet weak var productQuantityLbl :UILabel!
    @IBOutlet weak var priceLbl :UILabel!
    @IBOutlet weak var orderStatus :UILabel!
    @IBOutlet weak var gridImageView :GridImageView!
    
    
    var order:Order? {
        didSet{
            let _order = order!
            dateLbl.text = _order.createdAt
            productQuantityLbl.text = _order.productsCount.description
            priceLbl.text = _order.grandTotal.valueWithCurrency
            orderStatus.text = _order.status.localized
            bankTransferBtn.visibility = _order.isNeedBankTransfer ? Visibility.visible : Visibility.gone
            
            orderNumberLbl.text = _order.orderNumber ?? ""
            
            if _order.status == "new" || _order.status == "processing" || _order.status == "delivering"{
                reOrderBtn.isHidden = true
            }else{
                reOrderBtn.isHidden = false

            }
  
            
            switch _order.status {
                case "new":
                    stepper.steps = 1
                    break
                case "processing":
                    stepper.steps = 1
                    break
                case "delivering":
                    stepper.steps = 2
                    break
                case "completed":
                    stepper.steps = 3

                    break
                case "rejected":
                    stepper.steps = 0
                    break
                default:
                    stepper.steps = 0
                    break
            }
 
            initImages(products: _order.products)
            
        }
    }
    
    
    
    func initImages(products :[Product]){
        var imagesListArray :[String] = []
        
        for product in products {
            imagesListArray.append(product.image)
        }
        
        
        gridImageView.images = imagesListArray
        
       
        if AppDelegate.shared.language == "en" {
            let imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
            invoiceBtn.imageEdgeInsets = imageEdgeInsets
            bankTransferBtn.imageEdgeInsets = imageEdgeInsets
            reOrderBtn.imageEdgeInsets = imageEdgeInsets
        }
        
        
       
    }
    
   
    
    
    
    
//    var rowIndex = 0 {
//        didSet{
//            var step = rowIndex % 4
//            stepper.steps = step
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
