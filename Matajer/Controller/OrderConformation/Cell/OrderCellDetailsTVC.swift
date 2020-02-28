//
//  OrderCellDetailsTVCTableViewCell.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 26/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class OrderCellDetailsTVC: UITableViewCell {
    
    
    var refreshSelected :(()->())?
    
    
    
    @IBOutlet weak var confirmationTV :AGTableView!
    
    @IBOutlet weak var titelLbl :UILabel!
    
 
    
    var identifier = ""
    var isInvoice = false
    
    
    var orderConfirmationObject :OrderConfirmationObject! = nil {
        didSet{
            
            identifier = orderConfirmationObject.type.rawValue
            titelLbl.text = orderConfirmationObject.title
            registerViewCells()

            confirmationTV.reloadData()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        initDataForCollections()
        self.confirmationTV.estimatedRowHeight = 50
        self.confirmationTV.delegate = self
        self.confirmationTV.dataSource = self
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    
    func registerViewCells(){
        
        switch orderConfirmationObject?.type {
        case .paymentCell:
            confirmationTV.register(UINib(nibName: "PaymentConfirmationTVC", bundle: .main), forCellReuseIdentifier: identifier)
            
            
        case .productCell:
            
            confirmationTV.register(UINib(nibName: "ProductIInConfirmationTVC", bundle: .main), forCellReuseIdentifier: identifier)
            
        case .addressCell:
            confirmationTV.register(UINib(nibName: "AddressConfirmationTVC", bundle: .main), forCellReuseIdentifier: identifier)
            
//
            confirmationTV.register(UINib(nibName: "OtherAddressTVC", bundle: .main), forCellReuseIdentifier: "OtherAddressTVC")
            
            
        case .shippingMethodCell:
            confirmationTV.register(UINib(nibName: "ShippingMethodConfirmationTVC", bundle: .main), forCellReuseIdentifier: identifier)
            confirmationTV.register(UINib(nibName: "ShippingMethodConfirmationLbelTVC", bundle: .main), forCellReuseIdentifier: "ShippingMethodConfirmationTLblVC")

        default:
            break
        }
        
        
        
    }
    
    func initDataForCollections(){
        confirmationTV.dataSource = self
        confirmationTV.delegate = self

 
    }
    
    
 
    override func layoutSubviews() {
        super.layoutSubviews()

        self.confirmationTV.layoutSubviews()
        self.superTableView?.beginUpdates()
        self.superTableView?.endUpdates()
    }

    
}


extension OrderCellDetailsTVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isInvoice && orderConfirmationObject?.type  ==  .addressCell {
            return orderConfirmationObject!.data.count
        }
        
        
        if  (orderConfirmationObject?.type  ==  .addressCell && !isInvoice) || orderConfirmationObject?.type  ==  .shippingMethodCell {
            return orderConfirmationObject!.data.count + 1
        }
        return orderConfirmationObject!.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // tableView.frame.size.height = tableView.contentSize.height
        
        switch orderConfirmationObject?.type {
        case .productCell:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ProductIInConfirmationTVC
                productCell(productIInConfirmationTVC: cell, indexPath: indexPath)
            
            cell.selectionStyle = .none
//            cell.setNeedsLayout()

            return cell
        case .paymentCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! PaymentConfirmationTVC
                paymentCell(paymentConfirmationTVC :cell, indexPath :indexPath)
            cell.selectionStyle = .none

//             cell.setNeedsLayout()
            
            return cell
        case .addressCell:
       
            if indexPath.row == orderConfirmationObject!.data.count  {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OtherAddressTVC", for: indexPath) as! AddressConfirmationTVC
                cell.selectionStyle = .none
//                cell.setNeedsLayout()

                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! AddressConfirmationTVC
                       addressCell(addressConfirmationTVC :cell, indexPath :indexPath)
                cell.selectionStyle = .none
//                cell.setNeedsLayout()

                return cell
            }
            

        case .shippingMethodCell:
            if indexPath.row == 0 {
                  let cell = tableView.dequeueReusableCell(withIdentifier: "ShippingMethodConfirmationTLblVC", for: indexPath)
                            cell.selectionStyle = .none
//                cell.setNeedsLayout()

                return  cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ShippingMethodConfirmationTVC
                shippingMethodCell(shippingMethodConfirmationTVC: cell,indexPath: indexPath)
              cell.selectionStyle = .none
//                cell.setNeedsLayout()

                return cell
            }
        default:
 
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
    
    
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        self.layoutSubviews()
//        self.layoutIfNeeded()
//    }
//
    
    
    func productCell(productIInConfirmationTVC :ProductIInConfirmationTVC, indexPath :IndexPath){
        if let product = orderConfirmationObject!.data[indexPath.row] as? RProduct {
            productIInConfirmationTVC.rproduct = product
        }else if let product = orderConfirmationObject!.data[indexPath.row] as? Product {
            productIInConfirmationTVC.product = product

        }
        
    }
    
    
    
    func paymentCell(paymentConfirmationTVC :PaymentConfirmationTVC, indexPath :IndexPath){
        paymentConfirmationTVC.paymentMethod = (orderConfirmationObject!.data[indexPath.row] as! PaymentMethod)
        if isInvoice {
            paymentConfirmationTVC.selectedBackgorund()
        }
        
    }
    
    
    
    func addressCell(addressConfirmationTVC :AddressConfirmationTVC, indexPath :IndexPath){
        
        addressConfirmationTVC.address = (orderConfirmationObject!.data[indexPath.row] as! Address)
        
        if isInvoice {
            addressConfirmationTVC.checkBoxView.removeTarget(nil, action: nil, for: .allEvents)
             addressConfirmationTVC.checkBoxView.isUserInteractionEnabled = false
        }
    }
    
    
    
    func shippingMethodCell(shippingMethodConfirmationTVC :ShippingMethodConfirmationTVC, indexPath :IndexPath){
        shippingMethodConfirmationTVC.shippingMethod = (orderConfirmationObject!.data[indexPath.row - 1] as! ShippingMethod)
        
        if isInvoice {
            shippingMethodConfirmationTVC.checkBoxView.removeTarget(nil, action: nil, for: .allEvents)

             shippingMethodConfirmationTVC.checkBoxView.isUserInteractionEnabled = false
            
        }
        
        
    }
    
    
    
    
    
}







extension OrderCellDetailsTVC : UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        confirmationTV.deselectRow(at: indexPath, animated: true)
        if isInvoice {
            return
        }
        switch orderConfirmationObject?.type {
            case .addressCell:
                if indexPath.row == orderConfirmationObject!.data.count {
                    //showAddressVC
                    return
                }
                
                unselectAllAddress()
                let address = (orderConfirmationObject!.data[indexPath.row] as! Address)
                address.isDefult = true
                
                confirmationTV.reloadData()
                refreshSelected?()

            case .shippingMethodCell:
                if indexPath.row == 0 {
                    return
                }
                
                unselectAllShipmentMethod()
                let shippingMethod = (orderConfirmationObject!.data[indexPath.row - 1] as! ShippingMethod)
                shippingMethod.isSelected = true
                confirmationTV.reloadData()
//                confirmationTV.reloadRows(at: [indexPath], with: .automatic)

                refreshSelected?()

            case .paymentCell:
                unselectAllPayment()
                let paymentMethod = (orderConfirmationObject!.data[indexPath.row] as! PaymentMethod)
                paymentMethod.isSelected = true
                confirmationTV.reloadData()
                refreshSelected?()

                break
        default :
            break
        }
        
    }
    
    
    func unselectAllAddress(){
        orderConfirmationObject!.data.forEach { (data) in
            let address = data as! Address
            address.isDefult = false
        }
    }
    
    
    
    func unselectAllPayment(){
        orderConfirmationObject!.data.forEach { (data) in
                   let paymentMethod = data as! PaymentMethod
                   paymentMethod.isSelected = false
               }
    }
    
    
    func unselectAllShipmentMethod(){
        orderConfirmationObject!.data.forEach { (data) in
            let shippingMethod = data as! ShippingMethod
            shippingMethod.isSelected = false
        }
    }
    
}






extension UITableViewCell {

    var superTableView: UITableView? {

        var view = superview

        while view != nil && !(view is UITableView) {
            view = view?.superview
        }

        return view as? UITableView
    }
}



