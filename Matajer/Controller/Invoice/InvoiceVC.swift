//
//  OrderConfirmationVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 26/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

 
 



class InvoiceVC: UIViewController {

    @IBOutlet weak var orderConfirmationTV :UITableView!
    
    
    @IBOutlet weak var totalLbl: UILabel!
     
    @IBOutlet weak var cashOnDeliveryLbl: UILabel!
    @IBOutlet weak var cashOnDeliveryTextLbl: UILabel!
    
    @IBOutlet weak var delivaryLbl: UILabel!
    @IBOutlet weak var delivaryTextLbl: UILabel!
      
    @IBOutlet weak var couponLbl: UILabel!
    @IBOutlet weak var couponTextLbl: UILabel!
    
    @IBOutlet weak var finalTaxLbl: UILabel!
    @IBOutlet weak var estimatedTaxLbl: UILabel!
 
    
    @IBOutlet weak var finalTotalTextLabel: UILabel!
    @IBOutlet weak var taxTextLabel: UILabel!

    var arrayObjects :[OrderConfirmationObject] = []
    
    
    var products = [Product]()
    var selectedAddresses :Address?
    var selectedShippingMethods : ShippingMethod?
    var selectedPaymentMethod : PaymentMethod?
    var invoice  :Invoice?
 
    var isInvoice = true
    
    
    var order :Order?
    override func viewDidLoad() {
        super.viewDidLoad()

 
        registerViewCells()
        initDataSourceDataAndDelegate()
        
        startReqestGetInvoice(id: order!.id)
    }
    
    
    func initData(){
        let appContent = AppDelegate.shared.appContent
        
        
//        var totalValue = Double(invoice!.grandProductsPrices)! + Double(invoice!.cashOnDeliveryCost)!
//        totalValue -=  Double(invoice!.couponValue)!
//        totalLbl.text = Int(totalValue).description.valueWithCurrency
        
        totalLbl.text = Double(invoice!.grandProductsPrices)!.description.valueWithCurrency
        finalTaxLbl.text = invoice?.grandTotal.valueWithCurrency
        cashOnDeliveryLbl.text = invoice?.cashOnDeliveryCost.valueWithCurrency
        
        
        
        if Double(invoice!.shippingDetails.price) == 0 {
            delivaryLbl.visibility = .gone
            delivaryTextLbl.visibility = .gone
        }else{
            delivaryLbl.text = invoice?.shippingDetails.price.valueWithCurrency
            delivaryLbl.visibility = .visible
            delivaryTextLbl.visibility = .visible
        }
        
        
        if (invoice?.taxCost ?? "0.00") == "0.00" {
            finalTotalTextLabel.text = "Final total".localized
            taxTextLabel.visibility = .gone
            estimatedTaxLbl.visibility = .gone
            estimatedTaxLbl.text = "-"
        }else{
            finalTotalTextLabel.text = "Final total tax incl".localized
            taxTextLabel.visibility = .visible
            estimatedTaxLbl.visibility = .visible
            estimatedTaxLbl.text = invoice?.taxCost.valueWithCurrency
        }
        
//        estimatedTaxLbl.text = invoice?.taxCost.valueWithCurrency
        
 
          if self.selectedPaymentMethod?.type == .cashOnDelivery {
              cashOnDeliveryTextLbl.visibility = .visible
              cashOnDeliveryLbl.visibility = .visible
              cashOnDeliveryLbl.text = appContent?.cashOnDeliveryCost.valueWithCurrency
          }else{
              cashOnDeliveryTextLbl.visibility = .gone
              cashOnDeliveryLbl.visibility = .gone
              cashOnDeliveryLbl.text = "0".valueWithCurrency
          }
 

        if invoice?.couponType != nil {
            couponTextLbl.visibility = .visible
            couponLbl.visibility = .visible
            if invoice?.couponType == "value" {
                couponLbl.text = "-\(invoice!.couponValue)".valueWithCurrency
            }else{
                couponLbl.text = "%\(invoice!.couponValue)"
            }
            }else{
                couponTextLbl.visibility = .gone
                         couponLbl.visibility = .gone
                         couponLbl.text = "-"
            }


       
        
    }
    
    
    
    func registerViewCells(){
        
        
        orderConfirmationTV.register(UINib(nibName: "PaymentConfirmationTVC", bundle: .main), forCellReuseIdentifier:
               OrderConfirmationObject.ConfirmationType.paymentCell.rawValue)
               orderConfirmationTV.register(UINib(nibName: "ProductIInConfirmationTVC", bundle: .main), forCellReuseIdentifier: OrderConfirmationObject.ConfirmationType.productCell.rawValue)
               orderConfirmationTV.register(UINib(nibName: "AddressConfirmationTVC", bundle: .main), forCellReuseIdentifier:         OrderConfirmationObject.ConfirmationType.addressCell.rawValue)
               orderConfirmationTV.register(UINib(nibName: "OtherAddressTVC", bundle: .main), forCellReuseIdentifier: "OtherAddressTVC")
               orderConfirmationTV.register(UINib(nibName: "ShippingMethodConfirmationTVC", bundle: .main), forCellReuseIdentifier: OrderConfirmationObject.ConfirmationType.shippingMethodCell.rawValue)

               orderConfirmationTV.register(UINib(nibName: "ShippingMethodConfirmationLbelTVC", bundle: .main), forCellReuseIdentifier: "ShippingMethodConfirmationTLblVC")

               orderConfirmationTV.register(UINib(nibName: "HeaderTitleCell", bundle: .main), forCellReuseIdentifier: "HeaderTitleCell")

    }
    
    func initDataSourceDataAndDelegate(){
        orderConfirmationTV.dataSource = self
        orderConfirmationTV.delegate = self
        orderConfirmationTV.sectionFooterHeight = 0.0
    }
    
    
    
    func initDataForCollections(){
        
        arrayObjects.append(OrderConfirmationObject(title: "cart".localized, data: products, type: .productCell))
        
        arrayObjects.append(OrderConfirmationObject(title: "delivary_address".localized, data: [selectedAddresses], type: .addressCell))
        
        arrayObjects.append(OrderConfirmationObject(title: "payment_methods".localized, data: [selectedPaymentMethod], type: .paymentCell))

        arrayObjects.append(OrderConfirmationObject(title: "shipment_methods".localized, data: [selectedShippingMethods], type: .shippingMethodCell))

        
        orderConfirmationTV.reloadData()
    }
    
    

    
    private func startReqestGetInvoice(id:Int){
        orderConfirmationTV.isHidden = true
        API.INVOICE.startRequest(showIndicator: true,nestedParams: id.description) { (Api, statusResult) in
                  if statusResult.isSuccess {
                    self.orderConfirmationTV.isHidden = false

                     let value = statusResult.data  
                     let invoiceData = try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                     self.invoice = try! JSONDecoder().decode(Invoice.self, from: invoiceData)
                    
                    self.invoice!.shippingDetails.isSelected = true
                    self.invoice!.address.isDefult = true

                    self.selectedShippingMethods = self.invoice!.shippingDetails

                    self.selectedAddresses = self.invoice!.address
                    
                      
                    if var paymentMethods = PaymentMethod.getAllPaymentMethod().first(where: {$0.type.rawValue == self.invoice!.paymentMethod}) {

                        self.selectedPaymentMethod = paymentMethods
                        self.products.append(contentsOf: self.invoice!.products)
                       
 
                        self.initDataForCollections()
                    }
                    
                    self.initData()

                   }else{
                   self.showOkAlert(title: "", message: statusResult.errorMessege)
                  }
              }
    }
         
      
    
 
    func refreshSelected(){

       // initData()
    }
    
    
    
     
    
    

}
















extension InvoiceVC  :UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayObjects.count
    }
    
 
  
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableCell(withIdentifier: "HeaderTitleCell") as! HeaderTitleCell
        headerView.titleLbl.text = arrayObjects[section].title
        return headerView
    }
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if isInvoice && arrayObjects[section].type  ==  .addressCell {
            return arrayObjects[section].data.count
        }
        
        
        if  (arrayObjects[section].type  ==  .addressCell && !isInvoice) || arrayObjects[section].type  ==  .shippingMethodCell {
            return arrayObjects[section].data.count + 1
        }
        return arrayObjects[section].data.count
    }
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                // tableView.frame.size.height = tableView.contentSize.height
                
                let type = arrayObjects[indexPath.section].type
                let identifier = type.rawValue
                switch type {
                case .productCell:
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: identifier , for: indexPath) as! ProductIInConfirmationTVC
                        productCell(productIInConfirmationTVC: cell, indexPath: indexPath)
                    
                    cell.selectionStyle = .none
 
                    return cell
                case .paymentCell:
                    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! PaymentConfirmationTVC
                        paymentCell(paymentConfirmationTVC :cell, indexPath :indexPath)
                    cell.selectionStyle = .none

 
                    return cell
                case .addressCell:
               
                    if indexPath.row == arrayObjects[indexPath.section].data.count  {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "OtherAddressTVC", for: indexPath) as! AddressConfirmationTVC
                        cell.selectionStyle = .none
 
                        return cell
                    }else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! AddressConfirmationTVC
                               addressCell(addressConfirmationTVC :cell, indexPath :indexPath)
                        cell.selectionStyle = .none
 
                        return cell
                    }
                    

                case .shippingMethodCell:
                    if indexPath.row == 0 {
                          let cell = tableView.dequeueReusableCell(withIdentifier: "ShippingMethodConfirmationTLblVC", for: indexPath)
                                    cell.selectionStyle = .none
 
                        return  cell
                    }else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ShippingMethodConfirmationTVC
                        shippingMethodCell(shippingMethodConfirmationTVC: cell,indexPath: indexPath)
                      cell.selectionStyle = .none
 
                        return cell
                    }
                default:
         
                    return UITableViewCell()
                }
                
                return UITableViewCell()
                }
    
   
 
    
    
    
    func productCell(productIInConfirmationTVC :ProductIInConfirmationTVC, indexPath :IndexPath){
        if let product = arrayObjects[indexPath.section].data[indexPath.row] as? RProduct {
            productIInConfirmationTVC.rproduct = product
        }else if let product = arrayObjects[indexPath.section].data[indexPath.row] as? Product {
            productIInConfirmationTVC.product = product
        }
    }
    
    
    
    func paymentCell(paymentConfirmationTVC :PaymentConfirmationTVC, indexPath :IndexPath){
        paymentConfirmationTVC.paymentMethod = (arrayObjects[indexPath.section].data[indexPath.row] as! PaymentMethod)
        if isInvoice {
            paymentConfirmationTVC.selectedBackgorund()
        }
        
    }
    
    
    
    func addressCell(addressConfirmationTVC :AddressConfirmationTVC, indexPath :IndexPath){
        
        addressConfirmationTVC.address = (arrayObjects[indexPath.section].data[indexPath.row] as! Address)
        
        if isInvoice {
            addressConfirmationTVC.checkBoxView.removeTarget(nil, action: nil, for: .allEvents)
             addressConfirmationTVC.checkBoxView.isUserInteractionEnabled = false
        }
    }
    
    
    
    func shippingMethodCell(shippingMethodConfirmationTVC :ShippingMethodConfirmationTVC, indexPath :IndexPath){
        shippingMethodConfirmationTVC.shippingMethod = (arrayObjects[indexPath.section].data[indexPath.row - 1] as! ShippingMethod)
        
        if isInvoice {
            shippingMethodConfirmationTVC.checkBoxView.removeTarget(nil, action: nil, for: .allEvents)

             shippingMethodConfirmationTVC.checkBoxView.isUserInteractionEnabled = false
            
        }
        
        
    }
    
    
}










extension InvoiceVC : UITableViewDelegate  {
    
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
              return 64
          }
 
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
        
       
            
        
        
      
        
}

    


