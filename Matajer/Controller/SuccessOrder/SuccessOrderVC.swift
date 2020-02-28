//
//  SuccessOrderVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 18/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class SuccessOrderVC: UIViewController {
    
    
    
    @IBOutlet weak var orderDescriptionLbl:UILabel!
    @IBOutlet weak var transfareBankBtn:UIButton!
    
    var id :Int = 0
    var orderNo : String = ""
    var isNeedTransfer = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let descriptionValue = "order_success_message".localized + " " + orderNo
        
        orderDescriptionLbl.text = descriptionValue
        // Do any additional setup after loading the view.
        
        if isNeedTransfer {
            transfareBankBtn.isHidden = false
        }else{
            transfareBankBtn.isHidden = true
        }
        
        
        
        
        
        self.view.applyGradient(colours: [UIColor.CustomColor.primaryColor2,UIColor.CustomColor.primaryColor],gradientOrientation : .horizontal)
    }
    
    
    
    @IBAction func goToMyOrder(_ sender :UIButton){
        
        
        var topViewController :UIViewController = self
        
        while let presentingViewController =  topViewController.presentingViewController {
            topViewController = presentingViewController
            if topViewController is MainTabBarVC {
                
                break
            }
            
        }
        
        topViewController.dismiss(animated: false) {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            (topViewController as! MainTabBarVC).selectedIndex = 4
            
            let orderVc :MainOrderVC = mainStoryboard.instanceVC()
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                
                ((topViewController as! MainTabBarVC).viewControllers?.last as! ProfileNVC).pushViewController(orderVc, animated: true)
                
            }
        }
        
        
        
        
        
    }
    
    
    @IBAction func goToHome(_ sender :UIButton){
        
        var topViewController :UIViewController = self
        
        while let presentingViewController =  topViewController.presentingViewController {
            topViewController = presentingViewController
            if topViewController is MainTabBarVC {
                (topViewController as! MainTabBarVC).selectedIndex = 0
                break
            }
            
        }
        topViewController.dismiss(animated: false, completion: nil)
        
    }
    
    
    
    
    
    
    @IBAction func bankTransfere(_ sender :UIButton){
        
        let storyboard = UIStoryboard(name: "Main2", bundle: nil)
        let vc :BankTransferVC = storyboard.instanceVC()
        vc.orderId = id
        vc.orderNo = orderNo
        vc.isfromCheckOut = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false,pushing: true){}
        
    }
}
