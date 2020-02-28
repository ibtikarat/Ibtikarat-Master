//
//  OrderDialogVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 20/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

protocol  SortedDialogVCDelegate {
    func dialogDissmised()
}


class SortedDialogVC: UIViewController {
    
    
    static let _default = "_default"
    static let created_atDesc = "created_atDesc"
    static let created_atAsc = "created_atAsc"
    static let priceDesc = "priceDesc"
    static let priceAsc = "priceAsc"
 
    @IBOutlet weak var created_atDesc :UIView!
    @IBOutlet weak var created_atAsc :UIView!
    @IBOutlet weak var priceHighToLow:UIView!
    @IBOutlet weak var priceLowToHigh:UIView!
    var inputViews :[UIView] = []
    
    
    var delegate :SortedDialogVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputViews = [created_atDesc,created_atAsc,priceHighToLow,priceHighToLow,priceLowToHigh]
        // Do any additional setup after loading the view.
        addGesterToAll()

        created_atDesc.tag = 1
        created_atAsc.tag = 2
        priceHighToLow.tag = 3
        priceLowToHigh.tag = 4
        unCheckAll()

        switch AppDelegate.shared.sortedBy {
            case "created_atDesc":
                checkView(view: created_atDesc)
                
            case "created_atAsc":
                checkView(view: created_atAsc)
                
            case "priceDesc":
                checkView(view: priceHighToLow)
                
            case "priceAsc":
                checkView(view: priceLowToHigh)
                
            default:
                checkView(view: created_atDesc)
        }
        
        
        
    }
    
 
    func addGesterToAll(){
        inputViews.forEach { (v) in
            v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
        }
    }
    
   @objc func handleTapGesture(gesture : UITapGestureRecognizer)
    {
        
        let v = gesture.view!
        
        
  
        switch v.tag {
            case 1:
                AppDelegate.shared.sortedBy = SortedDialogVC.created_atDesc
            case 2:
                AppDelegate.shared.sortedBy = SortedDialogVC.created_atAsc
            
            case 3:
                AppDelegate.shared.sortedBy = SortedDialogVC.priceDesc
            
            case 4:
                AppDelegate.shared.sortedBy = SortedDialogVC.priceAsc
            
            default:
                AppDelegate.shared.sortedBy = SortedDialogVC._default
        }
        
        dismiss(animated: true) {
            self.delegate?.dialogDissmised()
        }

        
        unCheckAll()
        checkView(view: v)

     }
    
    
    
    func checkView(view :UIView){
        for v in view.subviews {
            
            if v is UICheckBox {
                (v as! UICheckBox).isChecked = true
            }else if v is UILabel{
                (v as! UILabel).textColor = UIColor.CustomColor.primaryColor
            }
        }
    }


     func unCheckView(view :UIView){
         for v in view.subviews {
             if v is UICheckBox {
                 (v as! UICheckBox).isChecked = false
             }else if v is UILabel{
                 (v as! UILabel).textColor = UIColor.black
             }
         }
     }

    
    
    
    func unCheckAll(){
        for v in inputViews {
            unCheckView(view :v)
        }
    }
    
}
