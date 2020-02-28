//
//  RealmHelper.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 15/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation
import RealmSwift


class RealmHelper {
    
    
    
    static func addToCart(product :Product, quantity :Int = 1){
        let rProduct = convert(productToRealm: product)
        
        
        
        
        let realm = try! Realm()
        let predicate = NSPredicate(format: "id == %ld AND colorId == %ld AND optionId == %ld AND contentId == %ld", rProduct.id, rProduct.colorId , rProduct.optionId,rProduct.contentId)

        if let realmProduct = realm.objects(RProduct.self).filter(predicate).first {
            let realm = try! Realm()
            try! realm.write {
                realmProduct.quantity += quantity
                //incrementQuantity(forProduct: realmProduct)
            }
        }else{
            try! realm.write {
                rProduct.quantity = quantity
                realm.add(rProduct)
            }
        }
        
        
        
        
    }
   
    static func incrementQuantity(forProduct rPoroduct :RProduct){
        let realm = try! Realm()
        try! realm.write {
            rPoroduct.incrementQuantity()
        }
    }
    
    
    static func decrementQuantity(forProduct rPoroduct :RProduct){
        let realm = try! Realm()
        try! realm.write {
            rPoroduct.decrementQuantity()
        }
    }
    
    
    static func countInCart()->Int{
        let realm = try! Realm()
        return realm.objects(RProduct.self).count
    }
    
    
    //deprecated
    static func getAllProductOld()->[RProduct]{
        let realm = try! Realm()
        return realm.objects(RProduct.self).toArray(type: RProduct.self)
    }
    
    
    //deprecated
    static func getAllProduct()->Results<RProduct>{
        let realm = try! Realm()
        return realm.objects(RProduct.self)
    }
    
    
    static func delete(product rProduct :RProduct){
        let realm = try! Realm()
        try! realm.write {
            realm.delete(rProduct)
        }
    }
    
    static func getTotalPrice()->Double{
        let products = getAllProduct()
        
        var totalValue = 0.0
        for rProduct in products{
            if rProduct.priceAfterCommition.isEmpty{
                totalValue += (Double(rProduct.price)! * Double(rProduct.quantity))
                    }else{
                 totalValue += (Double(rProduct.priceAfterCommition)!  * Double(rProduct.quantity))
                }
        }
        
        return totalValue
    }

    
    
    static func getProductJson()->String{
        var json :[[String:Any]] = []
        
        getAllProduct().forEach { (rProduct) in
            var dictionaryProduct = [String:Any]()
            dictionaryProduct["id"] = rProduct.id
            dictionaryProduct["quantity"] = rProduct.quantity
            
            if rProduct.colorId != 0{
                dictionaryProduct["color_id"] = rProduct.colorId
            }
            
            if rProduct.optionId != 0{
                let options = ["id":rProduct.optionId , "content_id":rProduct.contentId]
                dictionaryProduct["options"] = [options]
            }
            
            json.append(dictionaryProduct)
        }
        
        
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: []) else {
            return ""
        }
        
        return String(data: data, encoding: String.Encoding.utf8) ?? ""
        
    }
    
    
    static func removeAllProduct(){
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }


    static func convert(productToRealm product :Product) -> RProduct{
        
        let rProduct = RProduct()
        rProduct.rID = rProduct.incrementaID()
        rProduct.id = product.id
        rProduct.category = product.category?.name ?? ""
        rProduct.name = product.name
        rProduct.price = product.price
        rProduct.priceAfterCommition = product.priceAfterDiscount ?? ""
        rProduct.image = product.image
        
        // TODO: problem how to get default from home
        if product.colors != nil && !product.colors!.isEmpty{
            product.colors?.forEach({ (color) in
                if color.isSelected {
                    rProduct.colorId = color.id!
                    return
                }
            })
        }
        
        
        //
        if product.options != nil && !product.options!.isEmpty{
            product.options?.forEach({ (option) in
                
                option.contents?.forEach { (content) in
                    if content.isSelected {
                        rProduct.optionId = option.id!
                        rProduct.contentId = content.id!
                        return
                    }
                }
            })
        }
                    
        return rProduct
    }
    
    
    
    
    
    
}


extension Results {
    func toArray<T>(type: T.Type) -> [T] {
        return compactMap { $0 as? T }
    }
}

