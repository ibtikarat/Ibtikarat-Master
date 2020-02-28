//
//  Order.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 18/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation


class Order: Codable {
    let id: Int
    let paymentMethod: String
    let couponType: String?
    let orderNumber: String?
    let couponValue, taxPercentage, taxCost, cashOnDeliveryCost: String
    let grandProductsPrices, grandTotal, status, createdAt: String
    let productsCount, _isNeedBankTransfer: Int
    let products: [Product]
    let address: Address
    let shippingDetails: ShippingMethod
    let bankTransfers: [BankTransfer]

    enum CodingKeys: String, CodingKey {
        case id
        case paymentMethod = "payment_method"
        case couponType = "coupon_type"
        case orderNumber = "order_number"
        case couponValue = "coupon_value"
        case taxPercentage = "tax_percentage"
        case taxCost = "tax_cost"
        case cashOnDeliveryCost = "cash_on_delivery_cost"
        case grandProductsPrices = "grand_products_prices"
        case grandTotal = "grand_total"
        case status
        case createdAt = "created_at"
        case productsCount = "products_count"
        case _isNeedBankTransfer = "is_need_bank_transfer"
        case products, address
        case shippingDetails = "shipping_details"
        case bankTransfers = "bank_transfers"
    }

    init(id: Int, paymentMethod: String, couponType: String?, orderNumber: String?,couponValue: String, taxPercentage: String, taxCost: String, cashOnDeliveryCost: String, grandProductsPrices: String, grandTotal: String, status: String, createdAt: String, productsCount: Int, isNeedBankTransfer: Int, products: [Product], address: Address, shippingDetails: ShippingMethod, bankTransfers: [BankTransfer]) {
        self.id = id
        self.paymentMethod = paymentMethod
        self.couponType = couponType
        self.orderNumber = orderNumber
        self.couponValue = couponValue
        self.taxPercentage = taxPercentage
        self.taxCost = taxCost
        self.cashOnDeliveryCost = cashOnDeliveryCost
        self.grandProductsPrices = grandProductsPrices
        self.grandTotal = grandTotal
        self.status = status
        self.createdAt = createdAt
        self.productsCount = productsCount
        self._isNeedBankTransfer = isNeedBankTransfer
        self.products = products
        self.address = address
        self.shippingDetails = shippingDetails
        self.bankTransfers = bankTransfers
    }
    
    
    
    
    var isNeedBankTransfer :Bool{
        return _isNeedBankTransfer == 1
    }
    
}



    
    class BankTransfer: Codable {
        let number: String
        let amount: Int
        let accountOwnerName, date: String
        let img: String
        let bankAccount: BankAccount

        enum CodingKeys: String, CodingKey {
            case number, amount
            case accountOwnerName = "account_owner_name"
            case date, img
            case bankAccount = "bank_account"
        }

        init(number: String, amount: Int, accountOwnerName: String, date: String, img: String, bankAccount: BankAccount) {
            self.number = number
            self.amount = amount
            self.accountOwnerName = accountOwnerName
            self.date = date
            self.img = img
            self.bankAccount = bankAccount
        }
    }
    
    
    



class OrderTax: Codable {
    let haveTax: Int
    let taxPercentage: Double
    let taxNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case haveTax = "have_tax"
        case taxPercentage = "tax_percentage"
        case taxNumber = "tax_number"
        
    }
    
    init(haveTax: Int, taxPercentage: Double, taxNumber: Int) {
        self.haveTax = haveTax
        self.taxPercentage = taxPercentage
        self.taxNumber = taxNumber
    }
}


class OrderContent: Codable {
    
    let taxPercentage: Double
    let cashOnDeliveryCost: Int
    let shippingMethods: [ShippingMethod]
    let banksAccounts: [BankAccount]
    let deliveryAddress:[Address]
    let taxData: OrderTax
    
    enum CodingKeys: String, CodingKey {
        
        case taxPercentage = "taxPercentage"
        case cashOnDeliveryCost = "cashOnDeliveryCost"
        
        case shippingMethods
        case banksAccounts
        case deliveryAddress = "deliveryAddresses"
        case taxData
    }
    
    init(taxPercentage: Double, cashOnDeliveryCost: Int, shippingMethods: [ShippingMethod], banksAccounts:  [BankAccount], deliveryAddress: [Address], taxData: OrderTax) {
        self.taxPercentage = taxPercentage
        self.cashOnDeliveryCost = cashOnDeliveryCost
        self.banksAccounts = banksAccounts
        self.deliveryAddress = deliveryAddress
        self.shippingMethods = shippingMethods
        self.taxData = taxData
    }
    
}
