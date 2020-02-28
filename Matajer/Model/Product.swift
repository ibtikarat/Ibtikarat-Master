//
//  Category.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 25/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation


class Product: Codable {
          let _id: Int?
          let productId: Int?
          let _price: String
          private let _isOffer: Int
          let _priceAfterDiscount: String?
          let sliderImage: String?
          let name, reviewsDescription: String
          let image: String

        
           let grandRate: Double?
           let ratesCount: Int?
           let images: [Image]?
           let specifications: [Specification]?
           let options: [Option]?
           let suggestions: [Product]?
           let colors: [Color]?
           let tradeMark: TradeMark?
           let category: Category?
           let rates: [Rate]?
    
    
           let yourRate :Rate?
           let quantity :Int?
    
           private var _isFavorite: Int

    
//          enum CodingKeys: String, CodingKey {
//              case id, price
//              case _isOffer = "is_offer"
//              case priceAfterDiscount = "price_after_discount"
//              case sliderImage = "slider_image"
//              case name
//              case reviewsDescription = "description"
//
//              case image = "img"
//              case category
//          }
    let ratesCounts: RatesCounts?

 
    enum CodingKeys: String, CodingKey {
           case _id = "id"
            case _price = "price"
            case productId = "product_id"
           case _isOffer = "is_offer"
           case _priceAfterDiscount = "price_after_discount"
           case sliderImage = "slider_image"
           case suggestions, name
           case reviewsDescription = "description"
           case image = "img"
           case grandRate = "grand_rate"
           case ratesCount = "rates_count"
           case images, specifications, colors
           case tradeMark = "trade_mark"
           case category, rates
           case ratesCounts = "rates_counts"
           case _isFavorite = "is_favorite"
           case yourRate = "your_rate"
           case quantity
           case options

       }
    
    
    init(id: Int, price: String, isOffer: Int, priceAfterDiscount: String, sliderImage: String?, suggestions: [Product], name: String, reviewsDescription: String, image: String, grandRate: Double, ratesCount: Int, images: [Image], specifications: [Specification], colors: [Color], tradeMark: TradeMark, category: Category, rates: [Rate]) {
        self._id = id
        self._price = price
        self._isOffer = isOffer
        self._priceAfterDiscount = priceAfterDiscount
        self.sliderImage = sliderImage
        self.suggestions = suggestions
        self.name = name
        self.reviewsDescription = reviewsDescription
        self.image = image
        self.grandRate = grandRate
        self.ratesCount = ratesCount
        self.images = images
        self.specifications = specifications
        self.colors = colors
        self.tradeMark = tradeMark
        self.category = category
        self.rates = rates
        self.ratesCounts = nil
        self._isFavorite = 0
        self.yourRate = nil
        self.quantity = 0
        self.productId = 0
        self.options = []
    }
    
    
 
    var price  :String {
        get{
            let value = Int(Double(_price)!)
            return value.description
        }
    }
    
    var priceAfterDiscount :String?{
        get{
            if _priceAfterDiscount != nil && !_priceAfterDiscount!.isEmpty{
            let value = Int(Double(_priceAfterDiscount!)!)
            return value.description
            }else{
                return nil
            }
        }
    }
    
    var priceValue :String{
          get{
              return  price.valueWithCurrency
          }
      }
    
    
    var priceAfterDiscountValue :String{
          get{
            return priceAfterDiscount?.valueWithCurrency ?? ""
          }
      }
    
    
    var isOffer :Bool{
        get{
            return _isOffer == 1
        }
    }
    
    
    
    var isFavorite :Bool{
        get{
            return _isFavorite == 1
        }
        
        set{
            _isFavorite = newValue ?  1 : 0
        }
    }
    
    
    var id :Int {
        get{
            return _id ?? productId ?? 0
        }
    }
    var isSelected :Bool = false
}






class Image : Codable{
    let img: String?
}

class Option : Codable{
    let id: Int?
    let name: String?
    let contents: [OptionContent]?
    enum CodingKeys: String, CodingKey {
        case id,name,contents
    }
}

class OptionContent : Codable{
    let id: Int?
    let content: String?
    enum CodingKeys: String, CodingKey {
        case id,content
    }
    var isSelected = false
}



class Specification : Codable{
    let key: String?
    let value: String?
    enum CodingKeys: String, CodingKey {
        case key,value
    }
    var isSelected = false
}





class Color : Codable{
    let id: Int?
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case id, content
    }
    
    var isSelected = false

}





