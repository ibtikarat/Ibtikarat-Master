//
//  Invoice.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 23/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation
class Invoice: Codable {
    let id: Int
    let paymentMethod: String
    let couponType: String?
    let couponValue, taxPercentage, taxCost, cashOnDeliveryCost: String
    let grandProductsPrices, grandTotal, status, createdAt: String
    let productsCount, isNeedBankTransfer: Int
    let address: Address
    let shippingDetails: ShippingMethod
    let bankTransfers: [BankTransfer]
    let products: [Product]

    enum CodingKeys: String, CodingKey {
        case id
        case paymentMethod = "payment_method"
        case couponType = "coupon_type"
        case couponValue = "coupon_value"
        case taxPercentage = "tax_percentage"
        case taxCost = "tax_cost"
        case cashOnDeliveryCost = "cash_on_delivery_cost"
        case grandProductsPrices = "grand_products_prices"
        case grandTotal = "grand_total"
        case status
        case createdAt = "created_at"
        case productsCount = "products_count"
        case isNeedBankTransfer = "is_need_bank_transfer"
        case address
        case shippingDetails = "shipping_details"
        case bankTransfers = "bank_transfers"
        case products
    }

    init(id: Int, paymentMethod: String, couponType: String?, couponValue: String, taxPercentage: String, taxCost: String, cashOnDeliveryCost: String, grandProductsPrices: String, grandTotal: String, status: String, createdAt: String, productsCount: Int, isNeedBankTransfer: Int, address: Address, shippingDetails: ShippingMethod, bankTransfers: [BankTransfer], products: [Product]) {
        self.id = id
        self.paymentMethod = paymentMethod
        self.couponType = couponType
        self.couponValue = couponValue
        self.taxPercentage = taxPercentage
        self.taxCost = taxCost
        self.cashOnDeliveryCost = cashOnDeliveryCost
        self.grandProductsPrices = grandProductsPrices
        self.grandTotal = grandTotal
        self.status = status
        self.createdAt = createdAt
        self.productsCount = productsCount
        self.isNeedBankTransfer = isNeedBankTransfer
        self.address = address
        self.shippingDetails = shippingDetails
        self.bankTransfers = bankTransfers
        self.products = products
    }
}
