//
//  ProfileVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 21/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var addressBtn :UIButton!
    @IBOutlet weak var settingBtn :UIButton!
    @IBOutlet weak var orderBtn :UIButton!
    
    
    
    
    @IBOutlet weak var signInBtn :UIButton!
    @IBOutlet weak var nameLbl :UILabel!
    @IBOutlet weak var welcomeLbl :UILabel!

    
    @IBOutlet weak var settingTVC :UITableView!

    
    @IBOutlet weak var menuHorizental: UIView!
    
    @IBOutlet weak var countLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//       self.edgesForExtendedLayout = []
//        self.extendedLayoutIncludesOpaqueBars = false

        view.bringSubviewToFront(menuHorizental)

        // Do any additional setup after loading the view.
        self.countLbl.isHidden = true
        self.countLbl.text = ""
    }
    

    override func viewWillAppear(_ animated: Bool) {
//        self.navigationItem.title = ""
//        self.navigationController?.navigationBar.topItem?.title = ""
        updateName()
        getNotificationCount()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateName()
        
    }
    
    func getNotificationCount(){
        if MatajerUtility.isLogin() {
            API.UNREAD_NOTIFICATIONS.startRequest { (api, statusResult) in
                if statusResult.isSuccess {
                    guard let itemCount = statusResult.data as? Int else{
                        self.countLbl.isHidden = true
                        return
                    }
                    if itemCount == 0 {
                        self.countLbl.isHidden = true
                    }else{
                        self.countLbl.isHidden = false
                        self.countLbl.text = itemCount.description
                    }
                }else{
                    self.countLbl.isHidden = true
                }
            }
            
        }else{
            countLbl.isHidden = true
        }
    }
    
    func updateName(){
        if MatajerUtility.isLogin() {
            welcomeLbl.isHidden = true
            let user = MatajerUtility.loadUser()
            if (user?.name ?? "").isEmpty {
                nameLbl.text = "smart_safety".localized

                signInBtn.setTitle("member_since".localized + " " + user!.timeAgo  , for: .normal)

            }else{
                nameLbl.text =  user!.name
                
                signInBtn.setTitle("member_since".localized + " " + user!.timeAgo , for: .normal)
            }
        }else{
            welcomeLbl.isHidden = false
            nameLbl.text = "smart_safety".localized
        }
    }
    
    
    @IBAction func addressAction(_ sender :UIButton){
        if !MatajerUtility.isLogin() {
                self.signIn()
                return
            }
        performSegue(withIdentifier: "DelivaryAddressVC", sender: nil)
    }
    
    
    @IBAction func settingAction(_ sender :UIButton){
//        if !SmartSafetyUtility.isLogin() {
//                self.signIn()
//                return
//            }
        performSegue(withIdentifier: "SettingVC", sender: nil)
    }
    
    
    @IBAction func orderAction(_ sender :UIButton){
        if !MatajerUtility.isLogin() {
                self.signIn()
                return
            }
        performSegue(withIdentifier: "MainOrderVC", sender: nil)
    }
    
    
    
    @IBAction func notificationVCAction(_ sender :UIButton){
//        if !SmartSafetyUtility.isLogin() {
//                self.signIn()
//                return
//            }
        performSegue(withIdentifier: "NotificationVC", sender: nil)
    }
    
    
}
