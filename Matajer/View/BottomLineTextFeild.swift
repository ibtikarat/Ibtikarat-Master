//
//  BottomLineTextFeild.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 21/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class BottomLineTextFeild: UITextField {
//
//    override func draw(_ rect: CGRect) {
//
//
//    }

    @IBInspectable var checkedImage :Bool = false {
        didSet{
            if checkedImage {
                setBottomBorder()
            }
        }
       
    }
    

    func setBottomBorder() {
        self.addTarget(self, action: #selector(selectedTextFeild), for: UIControl.Event.editingDidBegin)
       self.addTarget(self, action: #selector(deSelectedTextFeild), for: UIControl.Event.editingDidEnd)
        
        deSelectedTextFeild()
    }
    

    @objc func selectedTextFeild(){
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.CustomColor.primaryColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    
    @objc func deSelectedTextFeild(){
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.CustomColor.textFeildBorder.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    
    func setErrorLine(){
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.red.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    
}
