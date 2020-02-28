//
//  UIPickerView.swift
//  SmartSafty
//
//  Created by ayyad on 10/18/19.
//  Copyright © 2018 businesssuite.com. All rights reserved.
//

import Foundation
import UIKit
extension UIPickerView : UIPickerViewDelegate , UIPickerViewDataSource{
    private static let association = ObjectAssociation<NSObject>()
    private static let association2 = ObjectAssociation<NSObject>()

    
    private var pickerArray :[String]? {
        set {
            UIPickerView.association[self] = newValue as NSObject?
        }
        
        get {
            return UIPickerView.association[self] as? [String]
        }
    }
    
    
    private var textFeild :UITextField {
        set {
            UIPickerView.association2[self] = newValue as NSObject
        }
        
        get {
            return UIPickerView.association2[self] as! UITextField
        }
    }
    
    


    func initlizePicker(withArrayData:[String],textFild : UITextField){
        pickerArray = withArrayData
        
        self.textFeild = textFild
         //picker.tag = sender.tag
        self.dataSource = self
        self.delegate = self
        
        self.reloadInputViews()
        textFeild .inputView = self
        
        //setTitle(textField: sender)
    }
    
    
//    func initlizePicker(withArrayData:[String],lable : UIButton){
//        pickerArray = withArrayData
//        
//        textFeild = lable
//        //picker.tag = sender.tag
//        self.dataSource = self
//        self.delegate = self
//        
//        self.reloadInputViews()
//        lable.inputView = self
//        
//        //setTitle(textField: sender)
//    }
    
    
    
    

     public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
     
        return pickerArray!.count
        
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (textFeild.text?.isEmpty)! {
            textFeild.text = pickerArray?[0]
        }
        return pickerArray![row]
    }
    
    
    
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //var selectedValue = ""
            //selectedValue = pickerBankArray[row]
            //bankAccount?.text = selectedValue
        self.textFeild.text = pickerArray?[row]
        self.endEditing(false)
    }

    
    
    

    public final class ObjectAssociation<T: AnyObject> {
        
        private let policy: objc_AssociationPolicy
        
        /// - Parameter policy: An association policy that will be used when linking objects.
        public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
            
            self.policy = policy
        }
        
        /// Accesses associated object.
        /// - Parameter index: An object whose associated object is to be accessed.
        public subscript(index: AnyObject) -> T? {
            
            get { return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T? }
            set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
        }
    }
    
    
    
}


