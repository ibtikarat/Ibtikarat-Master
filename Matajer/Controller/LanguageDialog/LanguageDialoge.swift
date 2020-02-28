//
//  EditNameDialogVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 14/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
 
import MOLH


//enum EditGenderValidation{
//    case valid
//    case invalid(String)
//}




class LanguageDialoge: UIViewController {

 
    @IBOutlet weak var isArabicCheckBox: UICheckBox!
    @IBOutlet weak var isEnglishCheckBox: UICheckBox!

    var delegate :UpdateDeletagate?

    
    
    var gender :String = ""
    
    var isArabic :Bool {
        get{
            return AppDelegate.shared.language == "ar"
        }
    }
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        initViews()
     }
    
    
    
    func initViews(){
        isArabicCheckBox.isChecked = isArabic
        isEnglishCheckBox.isChecked = !isArabic
    }
 

 
    
    @IBAction func updateChanges(_ sender :UIButton){
        let languageSets = isArabicCheckBox.isChecked ?  "ar" : "en"
        
        if AppDelegate.shared.language != languageSets {
            MOLH.setLanguageTo(languageSets)
            MOLH.reset(transition: .transitionCrossDissolve)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
        
    
    
  
    
    
    @IBAction func arabicCheck(_ sender :Any){
        isArabicCheckBox.isChecked = true
        isEnglishCheckBox.isChecked = false
    }
    
    
    
    @IBAction func engilshCheck(_ sender :Any){
        isArabicCheckBox.isChecked = false
        isEnglishCheckBox.isChecked = true
    }
    
    
    
//
//
//    func validationInput() -> EditGenderValidation{
//
//        return .valid
//    }
    
    
}
