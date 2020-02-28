//
//  EditNameDialogVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 14/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
 



enum EditBirthDateValidation{
    case valid
    case invalid(String)
}




class EditBirthDateDialogVC: UIViewController {

    @IBOutlet weak var datePicker :UIDatePicker!
 
    var delegate :UpdateDeletagate?

    var date :String = ""
    let formate = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formate.dateFormat = "yyyy-MM-dd"
        formate.locale = Locale(identifier: "en")
        initViews()
     }
    
    
    
    func initViews(){
        
        if !date.isEmpty{
            let _date = formate.date(from: date)
            datePicker.date = _date ?? Date()
        }else{
            date = formate.string(from:  datePicker.date)
        }
    }
 

    
    @IBAction func pickerChange(_ sender: UIDatePicker) {
       date = formate.string(from:  sender.date)
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
         params["birthday"] =  date
        
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
    
    
    
    
    func validationInput() -> EditBirthDateValidation{
        
        return .valid
    }
    
    
}
