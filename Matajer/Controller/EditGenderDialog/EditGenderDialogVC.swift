//
//  EditNameDialogVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 14/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
 



enum EditGenderValidation{
    case valid
    case invalid(String)
}




class EditGenderDialogVC: UIViewController {

 
    @IBOutlet weak var isMaleCheckBox: UICheckBox!
    @IBOutlet weak var isFemaleCheckBox: UICheckBox!

    var delegate :UpdateDeletagate?

    
    
    var gender :String = ""
    
    var isMale :Bool {
        get{
            if gender.isEmpty {
                return true
            }
            return gender == "male"
        }
    }
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        initViews()
     }
    
    
    
    func initViews(){
        isMaleCheckBox.isChecked = isMale
        isFemaleCheckBox.isChecked = !isMale
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
        params["gender"] =  isMaleCheckBox.isChecked ? "male" : "female"
        
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
    
    
    
    @IBAction func maleCheck(_ sender :Any){
        isMaleCheckBox.isChecked = true
        isFemaleCheckBox.isChecked = false
    }
    
    
    
    @IBAction func femaleCheck(_ sender :Any){
        isMaleCheckBox.isChecked = false
        isFemaleCheckBox.isChecked = true
    }
    
    
    
    
    
    func validationInput() -> EditGenderValidation{
        
        return .valid
    }
    
    
}
