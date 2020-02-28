//
//  BankAccount.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 14/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation

class BankAccount: Codable {
    let id: Int
    let number, iban, holderName: String
    let img: String
    
    let bankName :String?
 
    enum CodingKeys: String, CodingKey {
        case id, number
        case iban = "IBAN"
        case holderName = "holder_name"
        case img
        case bankName = "bank_name"
    }

    init(id: Int, number: String, iban: String, holderName: String, img: String) {
        self.id = id
        self.number = number
        self.iban = iban
        self.holderName = holderName
        self.img = img
        self.bankName = ""
    }
    
    
    
    
   
}



