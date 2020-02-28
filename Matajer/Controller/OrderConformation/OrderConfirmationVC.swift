//
//  OrderConfirmationVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 26/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

import goSellSDK

enum OrderConfirmationObjectValidation{
    case valid
    case invalid(String)
}



class SectionTitle {
    
}

class OrderConfirmationObject {
    var type :ConfirmationType  = .productCell
    var title :String = ""
    var data :[Any] = []
    
    enum ConfirmationType :String {
        case productCell = "ProductIInConfirmationTVC"
        case paymentCell = "PaymentConfirmationTVC"
        case addressCell = "AddressConfirmationTVC"
        case shippingMethodCell = "ShippingMethodConfirmationTVC"
    }
    
    
    init(title :String ,data :[Any], type :ConfirmationType){
        self.type = type
        self.data = data
        self.title = title
    }
}

class OrderConfirmationVC: UIViewController {
    
    @IBOutlet weak var orderConfirmationTV :UITableView!
    
    
    @IBOutlet weak var couponTF: UITextField! {
        didSet{
            if AppDelegate.shared.language == "ar" {
                couponTF.textAlignment = .right
            }else{
                couponTF.textAlignment = .left
            }
            
            couponTF.setLeftPaddingPoints(18)
            couponTF.setRightPaddingPoints(18)
        }
    }
    
    @IBOutlet weak var totalLbl: UILabel!
    
    @IBOutlet weak var cashOnDeliveryLbl: UILabel!
    @IBOutlet weak var cashOnDeliveryTextLbl: UILabel!
    
    @IBOutlet weak var finalPriceTextLabel: UILabel!
    @IBOutlet weak var delivaryLbl: UILabel!
    @IBOutlet weak var delivaryTextLbl: UILabel!
    
    @IBOutlet weak var couponLbl: UILabel!
    @IBOutlet weak var couponTextLbl: UILabel!
    
    @IBOutlet weak var taxTextLabel: UILabel!
    @IBOutlet weak var finalTaxLbl: UILabel!
    @IBOutlet weak var taxLbl: UILabel!
    
    
    var arrayObjects :[OrderConfirmationObject] = []
    
    
    var products = [RProduct]()
    var addresses = [Address]()
    var shippingMethods = [ShippingMethod]()
    var paymentMethods = PaymentMethod.getAllPaymentMethod()
    
    
    var selectedAddress :Address?
    var selectedShippingMethods :ShippingMethod?
    var selectedPaymentMethod :PaymentMethod?
    var selectedCoupon :Coupon?
    var taxData: OrderTax?
    //    var orderResult: OrderResult?
    
    
    var isInvoice = false
    var totalWihtTax :Decimal = 0
    var totalProductsPrice: Double = 0
    var cardTokenized = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderConfirmationTV.isHidden = true
        products = RealmHelper.getAllProductOld()
        
        registerViewCells()
        initDataSourceDataAndDelegate()
        
        
        initData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startRequestRequiredOrderData()
    }
    
    
    func initData(){
        let appContent = AppDelegate.shared.appContent
        
        totalProductsPrice =  RealmHelper.getTotalPrice()
        
        let tax = self.taxData?.taxPercentage ?? 0
        //        Double(appContent!.taxPercentage)!
        var taxPrice = (tax/100) * self.totalProductsPrice
        
        
        
        if totalProductsPrice.isInteger {
            totalLbl.text = String(totalProductsPrice).valueWithCurrency
        }else{
            totalLbl.text = String(format:"%.02f", totalProductsPrice).valueWithCurrency
        }
        
        
        if self.selectedPaymentMethod?.type == .cashOnDelivery {
            cashOnDeliveryLbl.text = appContent?.cashOnDeliveryCost.valueWithCurrency
            cashOnDeliveryTextLbl.visibility = .visible
            cashOnDeliveryLbl.visibility = .visible
            
        }else{
            cashOnDeliveryTextLbl.visibility = .gone
            cashOnDeliveryLbl.visibility = .gone
            cashOnDeliveryLbl.text = "0".valueWithCurrency
        }
        
        if selectedShippingMethods == nil || Double(selectedShippingMethods!.price)! == 0 {
            delivaryLbl.text = "-"
            delivaryTextLbl.visibility = .gone
            delivaryLbl.visibility = .gone
        }else{
            delivaryTextLbl.visibility = .visible
            delivaryLbl.visibility = .visible
            
            let paymentOnDelivaryPrice  = Double(selectedShippingMethods?.price ?? "0")!
            delivaryLbl.text = String(paymentOnDelivaryPrice).valueWithCurrency
        }
        
        
        
        if selectedCoupon != nil {
            couponTextLbl.visibility = .visible
            couponLbl.visibility = .visible
            if selectedCoupon?.type == "value" {
                couponLbl.text = "-\(selectedCoupon!.amount)".valueWithCurrency
                //                taxPrice =  (tax/100) * (self.totalProductsPrice - Double(selectedCoupon!.amount)!)
                taxPrice -=  (((tax/100) * self.totalProductsPrice) - (Double(selectedCoupon!.amount)!))
                
            }else{
                couponLbl.text = "%\(selectedCoupon!.amount)"
                let priceWithCoupon = taxPrice * (Double(selectedCoupon!.amount )! / 100)
                taxPrice -=  priceWithCoupon
                //                let priceWithCoupon = self.totalProductsPrice * (Double(selectedCoupon!.amount )! / 100)
                //                taxPrice =  priceWithCoupon * (tax/100)
            }
        }else{
            couponTextLbl.visibility = .gone
            couponLbl.visibility = .gone
            couponLbl.text = "-"
        }
        
        
        if (self.taxData?.haveTax ?? 0) == 1{
            finalPriceTextLabel.text = "Final total tax incl".localized
            taxTextLabel.visibility = .visible
            taxLbl.visibility = .visible
            if taxPrice.isInteger {
                taxLbl.text = String(taxPrice).valueWithCurrency
            }else{
                finalPriceTextLabel.text = "Final total".localized
                taxLbl.text = String(format:"%.02f", taxPrice).valueWithCurrency
            }
        }else{
            taxTextLabel.visibility = .gone
            taxLbl.visibility = .gone
            taxLbl.text = "-"
        }
        
        var totalForAll = 0.0
        totalForAll += totalProductsPrice
        
        
        if selectedCoupon != nil {
            if selectedCoupon?.type == "value" {
                totalForAll -= Double(selectedCoupon!.amount)!
            }else{
                totalForAll -= (totalForAll * (Double(selectedCoupon!.amount )! / 100))
            }
        }
        
        
        var totalWihtTax = totalForAll + (totalForAll * (tax / 100))
        
        
        
        totalForAll +=  Double(selectedShippingMethods?.price ?? "0") ?? 0
        totalWihtTax += Double(selectedShippingMethods?.price ?? "0") ?? 0
        
        
        if self.selectedPaymentMethod?.type == .cashOnDelivery {
            totalForAll += Double(appContent?.cashOnDeliveryCost ?? "0")!
            totalWihtTax += Double(appContent?.cashOnDeliveryCost ?? "0")!
        }
        
        //      if you want to calculate with delivery price uncomment this line
        //        if totalForAll.isInteger {
        //            totalLbl.text = String(format:"%.0f", totalForAll).valueWithCurrency
        //        }else{
        //            totalLbl.text = String(format:"%.02f", totalForAll).valueWithCurrency
        //        }
        //
        //
        
        
        if totalWihtTax.isInteger {
            finalTaxLbl.text = String(format:"%.0f", totalWihtTax).valueWithCurrency
        }else{
            finalTaxLbl.text = String(format:"%.02f", totalWihtTax).valueWithCurrency
        }
        
        
        
        
        
        
    }
    
    
    
    func registerViewCells(){
        // orderConfirmationTV.register(UINib(nibName: "OrderCellDetailsTVC", bundle: .main), forCellReuseIdentifier: "OrderCellDetailsTVC")
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
        arrayObjects.removeAll()
        
        arrayObjects.append(OrderConfirmationObject(title: "cart".localized, data: products, type: .productCell))
        
        arrayObjects.append(OrderConfirmationObject(title: "payment_methods".localized, data: paymentMethods, type: .paymentCell))
        
        selectedAddress =  addresses.filter({return $0.isDefult}).first
        
        arrayObjects.append(OrderConfirmationObject(title: "delivary_address".localized, data: addresses.filter({return $0.isDefult}), type: .addressCell))
        
        arrayObjects.append(OrderConfirmationObject(title: "shipment_methods".localized, data: shippingMethods, type: .shippingMethodCell))
        
        orderConfirmationTV.isHidden = false
        
        orderConfirmationTV.reloadData()
    }
    
    
    
    
    
    //    func startRequestGetAllShippingMethods(){
    //        API.SHIPPING_METHODS.startRequest(showIndicator: true) { (api, statusResult) in
    //            if statusResult.isSuccess {
    //                let value = statusResult.data  as! [Any]
    //
    //                let ShippingMethodData = try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
    //
    //                self.shippingMethods = try! JSONDecoder().decode([ShippingMethod].self, from: ShippingMethodData)
    //
    //
    //                self.initDataForCollections()
    //
    //
    //
    //            }else{
    //                self.showBunnerAlert(title: "", message: statusResult.errorMessege)
    //            }
    //        }
    //    }
    //
    //
    //
    //
    //    private func startReqestMyAddressAddress(){
    //        API.MY_ADDRESS.startRequest(showIndicator: true) { (Api, statusResult) in
    //            if statusResult.isSuccess {
    //                let value = statusResult.data  as! [Any]
    //
    //
    //                let addressData = try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
    //
    //                self.addresses = try! JSONDecoder().decode([Address].self, from: addressData)
    //
    //
    //                self.startRequestGetAllShippingMethods()
    //            }else{
    //                self.showBunnerAlert(title: "", message: statusResult.errorMessege)
    //            }
    //        }
    //
    //    }
    
    private func startRequestRequiredOrderData(){
        API.ADD_ORDER_REQUIRED_DATA.startRequest(showIndicator: true) { (api, statusResult) in
            if statusResult.isSuccess {
                guard let value = statusResult.data  as? [String:Any] else {
                    return
                }
                
                let OrderData = try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                
                let order = try! JSONDecoder().decode(OrderContent.self, from: OrderData)
                
                self.shippingMethods = order.shippingMethods
                self.addresses = order.deliveryAddress
                self.taxData = order.taxData
                
                
                self.initDataForCollections()
                
                self.initData()
                
            }else{
                self.showBunnerAlert(title: "", message: statusResult.errorMessege)
            }
        }
    }
    
    
    
    
    @IBAction func startCheckCopon(_ sender :UIButton){
        if !couponTF.text!.isEmpty {
            startReqestCheckCopone(conpone: couponTF.text!)
        }
    }
    
    
    private func startReqestCheckCopone(conpone:String){
        var params  = [String:String]()
        params["promo_code"] = conpone
        params["grand_products_prices"] = self.totalProductsPrice.description
        
        API.COUPON.startRequest(showIndicator: true,params:params) { (Api, statusResult) in
            if statusResult.isSuccess {
                let value = statusResult.data
                let couponData = try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                self.selectedCoupon = try! JSONDecoder().decode(Coupon.self, from: couponData)
                self.initData()
                self.showBunnerAlert(title: "", message: statusResult.message,backgroundColor: UIColor.CustomColor.bunnerGreenBackgroundColor)
                
            }else{
                self.showBunnerAlert(title: "", message: statusResult.errorMessege)
            }
        }
    }
    
    
    
    
    func refreshSelected(){
        
        selectedAddress = addresses.first(where: {$0.isDefult})
        selectedShippingMethods = shippingMethods.first(where: {$0.isSelected})
        selectedPaymentMethod = paymentMethods.first(where: {$0.isSelected})
        
        
        
        initData()
    }
    
    
    
    func startReqeustAddOrder(){
        
        var params = [String:String]()
        params["payment_method"] = selectedPaymentMethod!.type.rawValue
        params["coupon_id"] = selectedCoupon?.id.description ?? ""
        params["user_address_id"] = selectedAddress!.id!.description
        params["shipping_method_id"] = selectedShippingMethods!.id!.description
        params["products"] = RealmHelper.getProductJson()
        
//        if self.selectedPaymentMethod?.type == .online {
//            //            let storyboard = UIStoryboard(name: "Main2", bundle: nil)
//            //            let vc :CardVC = storyboard.instanceVC()
//            //            vc.params = params
//            //            vc.modalPresentationStyle = .fullScreen
//            //            self.present(vc, animated: true){}
//            //
//            self.startTapPayment()
//            
//            return
//        }
//
        
        
        API.ORDER.startRequest(showIndicator: true,params:params) { (Api, statusResult) in
            if statusResult.isSuccess {
                let value = statusResult.data as! [String:Any]
                //self.showOkAlert(title: "", message: statusResult.message)
                
                RealmHelper.removeAllProduct()
                
                if self.selectedPaymentMethod?.type != .bank || self.selectedPaymentMethod?.type == .online {
                    let id = value["id"] as! Int
                    let orderNo = value["order_number"] as? String ?? ""

                    let storyboard = UIStoryboard(name: "Dialogs", bundle: nil)
                    let vc :SuccessOrderVC = storyboard.instanceVC()
                    vc.id = id
                    vc.orderNo = orderNo
                    self.present(vc, animated: true){}
                    
                }else{
                    let id = value["id"] as! Int
                    let orderNo = value["order_number"] as? String ?? ""
                    let storyboard = UIStoryboard(name: "Dialogs", bundle: nil)
                    let vc :SuccessOrderVC = storyboard.instanceVC()
                    vc.id = id
                    vc.orderNo = orderNo
                    vc.isNeedTransfer = true
                    self.present(vc, animated: true){}
                    
                }
                
                //                else if self.selectedPaymentMethod?.type == .online {
                //                }
                
            }else{
                self.showBunnerAlert(title: "", message: statusResult.errorMessege)
            }
        }
        
        
    }
    
    
    
    @IBAction func startOrderRequest(_ sender :UIButton){
        
        
        switch validationInput() {
        case .invalid(let error):
            self.showBunnerAlert(title: "", message: error)
        case .valid:
            //  self.showCustomAlert(title: "", message:"do_you_want_to_confirm_the_request".localized, okTitle: "confirm".localized, cancelTitle: "later".localized, color: UIColor.lightGray) { (status) in
            // if status{
            self.startReqeustAddOrder()
            //   }
            // }
            
            break
        }
    }
    
    
    func validationInput() -> OrderConfirmationObjectValidation{
        
        if selectedAddress == nil {
            return .invalid("you_must_select_address".localized)
        }
        
        if selectedShippingMethods == nil  {
            return .invalid("you_must_select_shipping_methods".localized)
        }
        
        if selectedPaymentMethod == nil  {
            return .invalid("you_must_seleect_payment_method".localized)
        }
        
        return .valid
    }
    
    
    
}



extension OrderConfirmationVC  :UITableViewDataSource {
    
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
                cell.isChangeAddress = addresses.count >= 2
                
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










extension OrderConfirmationVC : UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isInvoice {
            return
        }
        let type = arrayObjects[indexPath.section].type
        let data = arrayObjects[indexPath.section].data
        switch type {
        case .addressCell:
            if indexPath.row == data.count {
                //showAddressVC
                return
            }
            
            unselectAllAddress()
            let address = (data[indexPath.row] as! Address)
            address.isDefult = true
            
            tableView.reloadData()
            refreshSelected()
            
        case .shippingMethodCell:
            if indexPath.row == 0 {
                return
            }
            
            unselectAllShipmentMethod()
            let shippingMethod = (data[indexPath.row - 1] as! ShippingMethod)
            shippingMethod.isSelected = true
            tableView.reloadData()
            //                confirmationTV.reloadRows(at: [indexPath], with: .automatic)
            
            refreshSelected()
            
        case .paymentCell:
            unselectAllPayment()
            
            let paymentMethod = (data[indexPath.row] as! PaymentMethod)
            paymentMethod.isSelected = true
            tableView.reloadData()
            refreshSelected()
            
            break
        default :
            break
        }
        
    }
    
    
    func unselectAllAddress(){
        addresses.forEach { (data) in
            let address = data as! Address
            address.isDefult = false
        }
    }
    
    
    
    func unselectAllPayment(){
        paymentMethods.forEach { (data) in
            let paymentMethod = data as! PaymentMethod
            paymentMethod.isSelected = false
        }
    }
    
    
    func unselectAllShipmentMethod(){
        shippingMethods.forEach { (data) in
            let shippingMethod = data as! ShippingMethod
            shippingMethod.isSelected = false
        }
    }
    
}




//payment methods

extension OrderConfirmationVC : SessionDataSource,SessionDelegate  {
    
    var customer: Customer?{
        
        return newCustomer
    }
    
    var newCustomer: Customer {
        
        let user = MatajerUtility.loadUser()!
        
        
        let emailAddress = try! EmailAddress(emailAddressString: user.email)
        
        let phoneNumber = try! PhoneNumber(isdNumber: "966", phoneNumber: user.mobile)
        
        
        return try! Customer(emailAddress:  emailAddress,
                             phoneNumber:   phoneNumber,
                             firstName:     user.name,
                             middleName:    nil,
                             lastName:      nil)
    }
    
    
    var currency: Currency? {
        
        return .with(isoCode: "SAR")
    }
    
    
    var mode: TransactionMode{
        return TransactionMode.purchase
    }
    
    
    func startTapPayment(){
        let sandBoxSecretKey = "sk_test_ZR2oeW3OBPbiGz8N1MsUAYjr"
        let yourProductionSecretKey = "sk_live_F8oth4iYVKzvlmkcNJBf0jIQ"
        
        
        GoSellSDK.reset()
        let secretKey = SecretKey(sandbox: sandBoxSecretKey, production: yourProductionSecretKey)
        GoSellSDK.secretKey = secretKey
        GoSellSDK.mode = .sandbox
        GoSellSDK.language = AppDelegate.shared.language
        
        let session  = Session()
        
        session.dataSource = self
        session.delegate = self
        
        
        session.start()
        
    }
    
    
    //delegate
    func sessionIsStarting(_ session: SessionProtocol) {
        self.showIndicator()
    }
    
    func sessionHasStarted(_ session: SessionProtocol) {
        self.hideIndicator()
    }
    
    
    func sessionHasFailedToStart(_ session: SessionProtocol) {
        self.showBunnerAlert(title: "", message: "the payment session has failed")
    }
    
    func sessionCancelled(_ session: SessionProtocol) {
        
    }
    
    func cardTokenized(_ token: Token, on session: SessionProtocol, customerRequestedToSaveTheCard saveCard: Bool) {
        
    }
    
    func cardTokenizationFailed(with error: TapSDKError, on session: SessionProtocol) {
        self.showBunnerAlert(title: "", message: error.localizedDescription)
        
    }
    
}
