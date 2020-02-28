//
//  EditNameDialogVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 14/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
enum EditType {
    case name
    case phone
    case email
}



enum NamePhoneEmailValidation{
    case valid
    case invalid(String)
}




class EditNamePhoneEmailDialogVC: UIViewController {
    
    @IBOutlet weak var titleLbl :UILabel!
    @IBOutlet weak var inputTF :UITextField!
    
    var delegate :UpdateDeletagate?
    var type = EditType.name
    
    var data :String  = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    
    
    func initViews(){
        switch type {
        case .name:
            titleLbl.text = "full_name".localized
            inputTF.placeholder =  "full_name".localized
            inputTF.keyboardType = .default
            break
            
        case .phone:
            titleLbl.text = "mobile_number".localized
            inputTF.placeholder =  "mobile_number".localized
            inputTF.keyboardType = .asciiCapableNumberPad
            break
            
        case .email:
            titleLbl.text = "email".localized
            inputTF.placeholder =  "email".localized
            inputTF.keyboardType = .emailAddress
            break
        }
        
        
        inputTF.text = data
    }
    
    
    
    
    
    @IBAction func updateChanges(_ sender :UIButton){
        
        switch validationInput() {
        case .invalid(let error):
            self.showBunnerAlert(title: "", message: error)
            
        case .valid:
            startUpdateRequeset()
            break
        }
    }
    
    
    
    func startUpdateRequeset(){
        var params = [String:String]()
        let input = inputTF.text
        
        switch type {
        case .name:
            params["name"] = input
        
        case .phone:
            params["mobile"] = input
            
        case .email:
            params["email"] = input
        }
        
        API.UPDATE_PROFILE.startRequest(showIndicator: true,  params: params) { (Api, statusResult) in
            if statusResult.isSuccess {
                self.showOkAlert(title: "", message: statusResult.message){
                    let user = MatajerUtility.loadUser()
                    
                    let value = statusResult.data as! [String :Any]
                    let userData = try! JSONSerialization.data(withJSONObject: value, options: [])
                    let newUser = try! JSONDecoder().decode(User.self, from: userData)
                    newUser.apiToken = user?.apiToken
                    MatajerUtility.saveUser(user: newUser)
                    
                    self.dismiss(animated: true){
                        self.delegate?.didUpdate()
                    }
                }
            }else{
                self.showBunnerAlert(title: "", message: statusResult.errorMessege)
            }
        }
        
    }
    
    
    
    
    func validationInput() -> NamePhoneEmailValidation{
        
        if inputTF.text!.isEmpty {
            switch type {
            case .name:
                return .invalid("you_must_enter_first_name".localized)
        
            case .phone:
                return .invalid("you_must_enter_valid_mobile_number".localized)
                
            case .email:
                return .invalid("you_must_enter_valid_email".localized)
            }
        }
        
        
        if type == .phone {
            if  inputTF.text!.count != 10 {
                return .invalid("you_must_enter_valid_mobile_number".localized)
            }
        }
        
        
        
        if type == .email {
            if  inputTF.text!.isEmailValid {
                return .invalid("you_must_enter_valid_email".localized)
            }
        }
        
        
        return .valid
    }
    
    
}
