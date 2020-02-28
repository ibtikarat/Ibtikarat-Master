//
//  RegisterVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 25/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID

enum RegisterValidation{
    case valid
    case invalid(String)
}




class RegisterVC: UIViewController {
    
    
    @IBOutlet weak var nameTF :BottomLineTextFeild!
    
    @IBOutlet weak var mobileNumberTF :BottomLineTextFeild!
    @IBOutlet weak var emailTF :BottomLineTextFeild!
    @IBOutlet weak var passwordTF :BottomLineTextFeild!
    @IBOutlet weak var chageScureType :UICheckBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        emailTF.text = "ab.ayyad@gmail.com"
//        passwordTF.text = "123123"
        // Do any additional setup after loading the view.
        mobileNumberTF.addTarget(self, action: #selector(mobileNumberChange), for: UIControl.Event.editingChanged)
        
        
        
    }
    
    
    @IBAction func changeTextFeildPasswordType(_ sender :UICheckBox){
        passwordTF.isSecureTextEntry = sender.isChecked
    }
    
    
    @IBAction func registerAndAuth(_ sender :UIButton){
        switch validationInput() {
                case .invalid(let error):
                     self.showBunnerAlert(title: "", message: error)

                case .valid:
                         startRegister()
                    break
            }
        
    }
    
    
    @objc func mobileNumberChange(_ sender :UITextField){
        checkMaxLength(textField: sender, maxLength: 10)
    }
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (textField.text!.count > maxLength) {
            textField.deleteBackward()
        }
    }
    
    
    
    func startRegister(){
        
        var params = [String:String]()
        params["name"] = nameTF.text!
        params["email"] = emailTF.text!
        params["mobile"] = mobileNumberTF.text!
        params["password"] = passwordTF.text!
        params["fcm_token"] = "token"
        params["device_type"] = "ios"
        
        
        API.REGISTER.startRequest(showIndicator: true, params: params) { (Api,response) in
            if response.isSuccess {
                let value = response.data as! [String :Any]
                let userData = try! JSONSerialization.data(withJSONObject: value, options: [])
                let user = try! JSONDecoder().decode(User.self, from: userData)
                MatajerUtility.saveUser(user: user)
                self.registerTokenNotification()
                self.startOver()
            }else{
                self.showBunnerAlert(title: "", message: response.errorMessege)
            }
        }
    }
    
    
    
    
    @IBAction func showParavicyPoliceyVC(){
        let thumnil2 = UIStoryboard(name: "Main2", bundle: nil)
        let paravicyPoliceyVC :ParavicyPoliceyVC = thumnil2.instanceVC()
        self.navigationController!.pushViewController(paravicyPoliceyVC, animated: true)
//        present(paravicyPoliceyVC, animated: false,pushing: true, completion: nil)
        
    }
    
    
    
    
    
    func validationInput() -> RegisterValidation{
        
        if nameTF.text!.isEmpty {
            nameTF.setErrorLine()
            return .invalid("you_must_enter_first_name".localized)
        }
        
        
//        if lastNameTF.text!.isEmpty {
//            lastNameTF.setErrorLine()
//            
//            return .invalid("you_must_enter_last_name".localized)
//        }
        
        if emailTF.text!.isEmpty || !emailTF.text!.isEmailValid {
                   emailTF.setErrorLine()
                   return .invalid("you_must_enter_valid_email".localized)
        }
        
        
        if mobileNumberTF.text!.isEmpty  ||
            mobileNumberTF.text!.count != 10  {
            mobileNumberTF.setErrorLine()
            
            return .invalid("you_must_enter_valid_mobile_number".localized)
        }
        
       
        
        if passwordTF.text!.isEmpty {
            passwordTF.setErrorLine()
            return .invalid("you_must_enter_password".localized)
        }
        
        return .valid
    }
    
    
    
    
    
       func registerTokenNotification(){
           if !MatajerUtility.isLogin() {
               return
           }
           InstanceID.instanceID().instanceID { (result, error) in
                   if let error = error {
                     print("Error fetching remote instance ID: \(error)")
                   } else if let result = result {

                    
                       self.startRequestForFCMToken(fcmToken:  result.token)
                      
                       }
                       
                   }
                 }
           
       
       
       
       func startRequestForFCMToken(fcmToken :String){
           var params = [String:String]()
               params["fcm_token"] = fcmToken
                params["device_type"] = "ios"

           API.UPDATE_PROFILE.startRequest(showIndicator: false,  params: params) {
               (API, StatusResult) in
           }
       }
       
    
    
}
