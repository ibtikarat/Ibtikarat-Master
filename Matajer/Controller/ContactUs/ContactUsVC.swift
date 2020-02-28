//
//  ContactUsVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 08/10/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

enum ContactUsValidation{
    case valid
    case invalid(String)
}


class ContactUsVC: UIViewController {

    
    @IBOutlet weak var fullNameTF :UITextField!
    @IBOutlet weak var mobileNumberTF :UITextField!
    @IBOutlet weak var emailTF :UITextField!
    @IBOutlet weak var descriptionTF :UITextField!
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.backItem?.title = "الاتصال بنا".localized
        self.edgesForExtendedLayout = UIRectEdge()
            self.extendedLayoutIncludesOpaqueBars = false
        // Do any additional setup after loading the view.
        
        mobileNumberTF.addTarget(self, action: #selector(mobileNumberChange), for: UIControl.Event.editingChanged)
        
        setBackTitle(title: "contact_us".localized)
        
        
        
        if MatajerUtility.isLogin() {
            let user = MatajerUtility.loadUser()!
            fullNameTF.text = user.name
            mobileNumberTF.text = user.mobile
            emailTF.text = user.email
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       // self.navigationController?.navigationBar.backItem?.title = "الاتصال بنا".localized
    }
    
 
    
    @IBAction func sendMessage(_ sender :UIButton){
        
        switch validationInput() {
            case .invalid(let error):
                 self.showBunnerAlert(title: "", message: error)

            case .valid:
                     startSendReqeust()
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
    

    func startSendReqeust(){
        var params = [String:String]()
        params["full_name"] = fullNameTF.text!
        params["phone"] = mobileNumberTF.text!
        params["email"] = emailTF.text!
        params["content"] = descriptionTF.text!
        
        API.CONTACT_US.startRequest(showIndicator: true,  params: params) { (Api, statusResult) in
            if statusResult.isSuccess {
                        self.showOkAlert(title: "", message: statusResult.message) {
                            if self.navigationController != nil {
                                self.pop()
                            }else{
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                }else{
                    self.showBunnerAlert(title: "", message: statusResult.errorMessege)
                }
        }
        
    }
    
     
     func validationInput() -> ContactUsValidation{
             
         if fullNameTF.text!.isEmpty {
                 return .invalid("you_must_enter_full_name".localized)
             }
         
        if mobileNumberTF.text!.isEmpty  || mobileNumberTF.text!.count != 10  {
                 return .invalid("you_must_enter_valid_mobile_number".localized)
             }
    
        if emailTF.text!.isEmpty || !emailTF.text!.isEmailValid {
                 return .invalid("you_must_enter_valid_email".localized)
             }
         
        if descriptionTF.text!.isEmpty {
                return .invalid("you_must_enter_description".localized)
            }
             
         return .valid
     }

}
