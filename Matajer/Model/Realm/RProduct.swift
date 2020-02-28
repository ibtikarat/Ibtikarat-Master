//
//  RProduct.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 16/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation
import RealmSwift
class RProduct :Object {
    @objc dynamic var rID = 0

    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var category = ""
    @objc dynamic var date = Date()
    @objc dynamic var quantity = 1
    @objc dynamic var price = ""
    @objc dynamic var priceAfterCommition = ""
    @objc dynamic var image = ""
    
    @objc dynamic var colorId = 0
    
    //for option
    @objc dynamic var optionId = 0
    @objc dynamic var contentId = 0

    
    override static func primaryKey() -> String? {
        return "rID"
    }
    
    
    func decrementQuantity() {
        if quantity > 1 {
            quantity -= 1
        }
    }
    
    func incrementQuantity() {
        quantity += 1
    }
    
    
    func incrementaID() -> Int{
        let realm = try! Realm()
        if let retNext = realm.objects(RProduct.self).sorted(byKeyPath: "rID").last?.rID {
            return retNext + 1
        }else{
            return 1
        }
    }
    
    
}
