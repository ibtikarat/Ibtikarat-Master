//
//  LunchScreenVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 17/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class LunchScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startReqestGetContents()
        
        
    }
    
    
   func initApp(appContent: AppContent){

        AppDelegate.shared.appContent = appContent
    
    let notification = AppDelegate.shared.openFromNotifications
    if notification.fromNotificaiton {
        let  mainTabBarVC =  self.storyboard!.instantiateViewController(withIdentifier: "MainTabBarVC")
               present(mainTabBarVC, animated: true, completion: nil)
    }else{
        let mainTabBarVC = self.storyboard!.instantiateViewController(withIdentifier: "MainTabBarVC")
        //mainTabBarVC.modalTransitionStyle = .crossDissolve
        self.present(mainTabBarVC, animated: true, completion: nil)
    }
    }
  
    
    
    func startReqestGetContents(){
           API.APP_CONTENTS.startRequest(showIndicator: false) { (api, statusResult) in
                   if statusResult.isSuccess {
                    let value = statusResult.data  as! [Any]
                            
                    let appContentData = try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                              
                    let items = try! JSONDecoder().decode([Item].self, from: appContentData)
                   
                    self.initApp(appContent: AppContent(items: items))
                   }else{
                    self.showOkAlert(title: "", message: statusResult.errorMessege)
                  }
               }
           }
    

}
