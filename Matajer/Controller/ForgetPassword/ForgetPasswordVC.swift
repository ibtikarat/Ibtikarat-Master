//
//  ForgetPasswordVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 25/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class ForgetPasswordVC: UIViewController {

    
    @IBOutlet weak var emailTF :UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        //emailTF.text = "ab.ayyad@gmail.com"
        // Do any additional setup after loading the view.
    }
    
 
    @IBAction func sendPassword(_ sender :UIButton){
        sendVerificationToEamil()
    }
    
    
    
    func sendVerificationToEamil(){
        let email = emailTF.text!
        
        var params = [String:String]()
        params["email"] = email
 
          
        API.FORGOT.startRequest(showIndicator: true, params: params) { (Api,response) in
            if response.isSuccess {

                let vc :ResetPassswordVC = self.storyboard!.instanceVC()
                vc.email = email

                self.showOkAlertWithComp(title: "", message: response.message) { (bool) in
                     self.present(vc, animated: true, completion: nil)
                }

            }else{
                self.showBunnerAlert(title: "", message: response.errorMessege)
            }
        }
    }
    
    
 
}
