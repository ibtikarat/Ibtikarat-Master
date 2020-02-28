//
//  LoginVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 25/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging


enum LoginValidation{
    case valid
    case invalid(String)
}



class LoginVC: UIViewController {

    
    @IBOutlet weak var emailTF :BottomLineTextFeild!
    @IBOutlet weak var passwordTF :BottomLineTextFeild!
    @IBOutlet weak var chageScureType :UICheckBox!

    override func viewDidLoad() {
        super.viewDidLoad()

//        emailTF.text = "ab.ayyad@gmail.com"
//        passwordTF.text = "123456"
        // Do any additional setup after loading the view.
    }
    

    
       @IBAction func changeTextFeildPasswordType(_ sender :UICheckBox){
           passwordTF.isSecureTextEntry = sender.isChecked
       }
       
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    @IBAction func singInAuth(_ sender :UIButton){
        switch validationInput() {
                       case .invalid(let error):
                            self.showBunnerAlert(title: "", message: error)
                            
                       case .valid:
                                startLogin()
                           break
                }
    }
    
    
    
    func startLogin(){
      
        
        let email = emailTF.text!
        let password = passwordTF.text!

        var params = [String:String]()
          params["email"] = email
          params["password"] = password
          params["device_type"] = "ios"
       
          
        API.LOGIN.startRequest(showIndicator: true, params: params) { (Api,response) in
            if response.isSuccess {
                let value = response.data as! [String :Any]
                let userData = try! JSONSerialization.data(withJSONObject: value, options: [])
                let user = try! JSONDecoder().decode(User.self, from: userData)
                MatajerUtility.saveUser(user: user)
                self.dismiss(animated: true){
                    self.registerTokenNotification()
                }
            }else{
                self.showBunnerAlert(title: "", message: response.errorMessege)
            }
        }
    }
    
    
 
    
    func validationInput() -> LoginValidation{
            
        if emailTF.text!.isEmpty || !emailTF.text!.isEmailValid {
            emailTF.setErrorLine()
                 return .invalid("you_must_enter_valid_email".localized)
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
                  //print("Remote instance ID token: \(result.token)")
        
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
