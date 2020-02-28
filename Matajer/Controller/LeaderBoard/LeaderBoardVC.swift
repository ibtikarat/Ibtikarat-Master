//
//  LeaderBoardVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 08/10/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

class LeaderBoardVC: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return  .default
    }
    
    
    
    @IBOutlet weak var webSiteView: UIView!
    @IBOutlet weak var ourServiceView: UIView!
    
    @IBOutlet weak var customerServiceView: UIView!
    @IBOutlet weak var appStoreView: UIView!
    
    
    var observer :Any!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTokenNotification()
        
        let webSiteTap = UITapGestureRecognizer(target: self, action: #selector(webSiteAction))
        webSiteView.addGestureRecognizer(webSiteTap)
        
        let ourServiceTap = UITapGestureRecognizer(target: self, action: #selector(ourServiceAction))
        ourServiceView.addGestureRecognizer(ourServiceTap)
        
        let customerServiceTap = UITapGestureRecognizer(target: self, action: #selector(customerServiceAction))
        customerServiceView.addGestureRecognizer(customerServiceTap)
        
        let appStoreViewTap = UITapGestureRecognizer(target: self, action: #selector(appStoreViewAction))
        appStoreView.addGestureRecognizer(appStoreViewTap)
        
        
        if MatajerUtility.isSubscribe() {
            Messaging.messaging().subscribe(toTopic: API.FIREBASE_SUBSCRIBE_iosArTopic) { error in
                if error == nil {
                    MatajerUtility.setIsSubscribe(subscribe: true)
                    print("Subscribed to iosArTopic topic")
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNeedsStatusBarAppearanceUpdate()
        
       observer =  NotificationCenter.default.addObserver(forName: MainTabBarVC.messageFormNotification, object: nil, queue: nil) { (notification) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                if AppDelegate.shared.openFromNotifications.fromNotificaiton {
                    self.appStoreViewAction()
                }                      }
        }
        
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(observer)
        
    }
    @objc func webSiteAction(){
        let appContent = AppDelegate.shared.appContent
        let websiteURL = "https://smartsafety.com.sa/" //appContent!.websiteURL
        if let link = URL(string: websiteURL) {
            //                 UIApplication.shared.open(link)
            openURLWebView(url: websiteURL)
            
        }
    }
    
    
    @objc func ourServiceAction(){
        let appContent = AppDelegate.shared.appContent
        let websiteURL =  "http://smartsafety.com.sa/services"
        if let link = URL(string: websiteURL) {
            //UIApplication.shared.open(link)
            openURLWebView(url: websiteURL)
        }
        
    }
    
    
    @objc func customerServiceAction(){
        let appContent = AppDelegate.shared.appContent
        let websiteURL = "http://smartsafety.com.sa/CustomerPortal"
        if let link = URL(string: websiteURL) {
            //                       UIApplication.shared.open(link)
            openURLWebView(url: websiteURL)
            
        }
        
    }
    
    @objc func appStoreViewAction(){
        let  vc =  self.storyboard!.instantiateViewController(withIdentifier: "MainTabBarVC")
        present(vc, animated: true, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func registerTokenNotification(){
        if !MatajerUtility.isLogin() {
            return
        }
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {

                self.startRequestForFCMToken(fcmToken:  result.token)
                
            }
            
        }
    }
    
    
    
    
    func startRequestForFCMToken(fcmToken :String){
        var params = [String:String]()
        params["fcm_token"] = fcmToken
        params["device_type"] = "ios"
        API.UPDATE_PROFILE.startRequest(showIndicator: false,  params: params) {
            (API, StatusResult) in
        }
    }
}
