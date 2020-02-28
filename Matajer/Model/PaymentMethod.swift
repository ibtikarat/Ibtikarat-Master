//
//  PaymentMethods.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 17/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation
import UIKit
class PaymentMethod {
    var title :String
    var image :UIImage
    var type :PaymentMethodType
    
    
    var isSelected :Bool = false
    
    
    init(title:String, image: UIImage , type: PaymentMethodType){
        self.title = title
        self.image = image
        self.type = type
    }
    
    static func getAllPaymentMethod()->[PaymentMethod] {
        var paymentMethods = [PaymentMethod]()
        
        
      paymentMethods.append(PaymentMethod(title: "credit_cards".localized, image: UIImage(named:"thumnil_icon_credit_card")!, type: .cashOnDelivery))
             //change to online when activate online payment
        
        
        paymentMethods.append(PaymentMethod(title: "bank_transfer".localized, image: UIImage(named:"ic_bank_transfer")!, type: .bank))
     
        
        paymentMethods.append(PaymentMethod(title: "paiement_when_recieving".localized, image: UIImage(named:"ic_cash")!, type: .cashOnDelivery))
        
        return paymentMethods
    }
    
}

enum PaymentMethodType :String{
   case bank = "bank"
  
   case online = "online"
   case cashOnDelivery = "cashOnDelivery"
}
