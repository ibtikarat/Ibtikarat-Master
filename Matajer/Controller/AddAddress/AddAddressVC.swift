//
//  AddAddressVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 08/10/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
protocol ChangeMapDelegate {
    func mapChanged(address :Address?)
}


enum AddressValidation{
    case valid
    case invalid(String)
}

class AddAddressVC: UIViewController {
    
    @IBOutlet weak var editLbel: UIButton!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var officeNameTF: BottomLineTextFeild!
    @IBOutlet weak var cityTF: BottomLineTextFeild!
    @IBOutlet weak var addressTF: BottomLineTextFeild!
    @IBOutlet weak var mobileNumberTF: BottomLineTextFeild!
    @IBOutlet weak var isDefaultCB: UICheckBox!
    
    
    var isUpdate = false
    
    var address :Address? {
        didSet{
            isUpdate = (address?.id != 0)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //               self.edgesForExtendedLayout = UIRectEdge()
        //               self.extendedLayoutIncludesOpaqueBars = false
        
        addressLbl.text = ""
        mobileNumberTF.addTarget(self, action: #selector(mobileNumberChange), for: UIControl.Event.editingChanged)
        initData()
        
        setBackTitle(title: "delivary_address".localized)
        
        
        
    }
    
    
    
    
    
    func initData() {
        if address != nil{
            addressLbl.text = "\(address!.region) ," + address!.addressDetails
            
            if (address?.phone?.isEmpty)! {
                if (MatajerUtility.loadUser()!.mobile.contains("+966")){
                    mobileNumberTF.text = MatajerUtility.loadUser()!.mobile.dropFirst(4).description
                }else{
                    if MatajerUtility.loadUser()?.mobile.first == "0" {
                        mobileNumberTF.text = MatajerUtility.loadUser()?.mobile.dropFirst().description
                    }else{
                        mobileNumberTF.text = MatajerUtility.loadUser()?.mobile
                    }
                }
            }else{
                if address?.phone?.first == "0" {
                    mobileNumberTF.text = address!.phone!.dropFirst().description
                }else{
                    mobileNumberTF.text = address?.phone
                }
            }
            
            officeNameTF.text = address?.title
            addressTF.text = address?.addressDetails
            cityTF.text = address?.region
            isDefaultCB.isChecked = address?.isDefult ?? false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    
    private func startReqestAddAddress(){
        var params = [String:String]()
        params["title"] = officeNameTF.text!
        params["region"] = cityTF.text!
        params["details"] =  addressTF.text!
        params["lat"] = address!.latitude.description
        params["lng"] = address!.longitude.description
        params["phone"] = mobileNumberTF.text!
        params["is_default"] = isDefaultCB.isChecked ? "1" : "0"
        
        
        if  self.navigationController is AddressNVC{
            params["is_default"] = "1"
        }
        
        
        API.ADD_ADDRESS.startRequest(showIndicator: true,params: params) { (Api, statusResult) in
            if statusResult.isSuccess {
                self.showOkAlert(title: "", message: statusResult.message){
                    
                    if  self.navigationController is AddressNVC{
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    }else{
                        self.pop()
                        self.navigationController?.popViewController(animated: false)
                    }
                }
            }else{
                self.showBunnerAlert(title: "", message: statusResult.errorMessege)
            }
        }
    }
    
    
    
    private func startReqestUpdateAddress(){
        var params = [String:String]()
        params["title"] = officeNameTF.text!
        params["region"] = cityTF.text!
        params["details"] =  addressTF.text!
        params["lat"] = address!.latitude.description
        params["lng"] = address!.longitude.description
        params["phone"] = mobileNumberTF.text!
        params["is_default"] = isDefaultCB.isChecked ? "1" : "0"
        
        
        if  self.navigationController is AddressNVC{
            params["is_default"] = "1"
        }
        
        API.UPDATE_ADDRESS.startRequest(showIndicator: true,nestedParams: address!.id!.description ,params: params) { (Api, statusResult) in
            if statusResult.isSuccess {
                self.showOkAlert(title: "", message: statusResult.message){
                    
                    if  self.navigationController is AddressNVC{
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    }else{
                        self.pop()
                    }
                }
            }else{
                self.showBunnerAlert(title: "", message: statusResult.errorMessege)
            }
        }
    }
    
    
    
    
    @IBAction func changeMap(_ sender :UIButton){
        if isUpdate {
            let vc :MapAddressVC = self.storyboard!.instanceVC()
            vc.changeMapDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.pop()
        }
    }
    
    
    
    func validationInput() -> AddressValidation{
        
        if officeNameTF.text!.isEmpty {
            return .invalid("you_must_enter_office_name".localized)
        }
        
        if cityTF.text!.isEmpty {
            return .invalid("you_must_enter_city".localized)
        }
        
        
        if addressTF.text!.isEmpty {
            return .invalid("you_must_enter_address".localized)
        }
        
        //
        if mobileNumberTF.text!.isEmpty || mobileNumberTF.text!.count != 9{
            return .invalid("you_must_enter_valid_mobile_number".localized)
        }
        
        return .valid
    }
    
    
    
    @IBAction func addAddress(_ sender :UIButton){
        
        switch validationInput() {
        case .invalid(let error):
            self.showBunnerAlert(title: "", message: error)
            
        case .valid:
            if isUpdate {
                startReqestUpdateAddress()
            }else{
                startReqestAddAddress()
            }
            break
        }
        
    }
    
    
    @objc func mobileNumberChange(_ sender :UITextField){
        checkMaxLength(textField: sender, maxLength: 9)
    }
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (textField.text!.count > maxLength) {
            textField.deleteBackward()
        }
    }
    
    
    
    
}



extension AddAddressVC :ChangeMapDelegate{
    func mapChanged(address: Address?) {
        let id = self.address!.id
        let title = self.address!.title
        let isDefault = self.address!.isdefult
        
        self.address = address
        self.address!.id = id
        self.address!.title = title
        self.address!.isdefult = isDefault
        
        if address == nil {
            addressLbl.text = ""
            mobileNumberTF.text = MatajerUtility.loadUser()?.mobile
            addressTF.text = ""
            cityTF.text = ""
        }else{
            initData()
        }
        
        isUpdate = true
    }
    
}
