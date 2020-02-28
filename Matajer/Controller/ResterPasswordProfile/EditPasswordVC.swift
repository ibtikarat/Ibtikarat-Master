//
//  EditNameDialogVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 14/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
 

enum EditPasswrodValidation{
    case valid
    case invalid(String)
}




class EditPasswordVC: UIViewController {

    @IBOutlet weak var oldPasswordTF :UITextField!
    @IBOutlet weak var newPasswordTF :UITextField!
    @IBOutlet weak var confirmPasswordTF :UITextField!
 
    var delegate :UpdateDeletagate?
 
    var data :String  = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
     }
    
    
    
    func initViews(){

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
        params["old_password"] = oldPasswordTF.text!
        params["password"] = newPasswordTF.text!
        params["password_confirmation"] = confirmPasswordTF.text!
        
        API.UPDATE_PROFILE.startRequest(showIndicator: true,  params: params) { (Api, statusResult) in
            if statusResult.isSuccess {
                    self.showOkAlert(title: "", message: statusResult.message){
                        let user = MatajerUtility.loadUser()
                        
                        let value = statusResult.data as! [String :Any]
                        let userData = try! JSONSerialization.data(withJSONObject: value, options: [])
                        let newUser = try! JSONDecoder().decode(User.self, from: userData)
                        newUser.apiToken = user?.apiToken
                        MatajerUtility.saveUser(user: newUser)
                        
                         
                        self.pop()
                    }
                }else{
                    self.showBunnerAlert(title: "", message: statusResult.errorMessege)
                }
        }
        
    }
    
    
    
    
    func validationInput() -> EditPasswrodValidation{
            
        if oldPasswordTF.text!.isEmpty {
                return .invalid("you_must_enter_password".localized)
        }
        
        
    
    
        if newPasswordTF.text!.isEmpty {
                return .invalid("you_must_enter_new_password".localized)
            }
        
   


        if confirmPasswordTF.text! != newPasswordTF.text!{
                return .invalid("password_mismatch".localized)
            }
        
                
        
        return .valid
    }
    
    
}
