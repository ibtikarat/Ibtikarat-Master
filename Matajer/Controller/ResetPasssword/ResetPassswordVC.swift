//
//  ResetPassswordVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 25/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class ResetPassswordVC: UIViewController {

 @IBOutlet weak var codeTF :UITextField!

    @IBOutlet weak var passwordTF :UITextField!
    @IBOutlet weak var verifyPasswordTF :UITextField!
    
    @IBOutlet weak var chageScureType :UICheckBox!
    @IBOutlet weak var verifyScureType :UICheckBox!

    
    var email :String!
    override func viewDidLoad() {
        super.viewDidLoad()

         //passwordTF.text = "123123"
         //verifyPasswordTF.text = "123123"
        // Do any additional setup after loading the view.
        
        
        
    }
    
 
    @IBAction func changeTextFeildPasswordType(_ sender :UICheckBox){
        passwordTF.isSecureTextEntry = sender.isChecked
        verifyPasswordTF.isSecureTextEntry = sender.isChecked
        
        if sender == chageScureType {
            verifyScureType.isChecked = !sender.isChecked
        }
        
        if sender == verifyScureType {
            chageScureType.isChecked = !sender.isChecked
        }
        
        
        
    }
  
    
    @IBAction func registerRestPassword(_ sender :UIButton){
        startRegister()
    }
    
    
    
    func startRegister(){

          var params = [String:String]()

          params["email"] = email!
          params["code"] = codeTF.text!
          params["password"] = passwordTF.text!
          params["password_confirmation"] = verifyPasswordTF.text!
 
       
          
        API.RESET_PASSWORD.startRequest(showIndicator: true, params: params) { (Api,response) in
            if response.isSuccess {
                let value = response.data as! [String :Any]
                let userData = try! JSONSerialization.data(withJSONObject: value, options: [])
                let user = try! JSONDecoder().decode(User.self, from: userData)
                MatajerUtility.saveUser(user: user)
                
                self.showOkAlertWithComp(title: "", message: response.message) { (bool) in
                        self.startOver()
                }
            }else{
                self.showBunnerAlert(title: "", message: response.errorMessege)
            }
        }
    }
    
    
 
}
