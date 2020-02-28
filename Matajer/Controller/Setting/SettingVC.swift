//
//  SettingVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 08/10/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import Firebase
import StoreKit
import FirebaseInstanceID
import FirebaseMessaging

class SettingVC: UITableViewController {
    
    @IBOutlet weak var notificationSwitch:UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge()
        self.extendedLayoutIncludesOpaqueBars = false
        // Do any additional setup after loading the view.
        
        setBackTitle(title: "settings".localized)
        
        let user = MatajerUtility.loadUser()
        notificationSwitch.isOn = user?.isNotify ?? MatajerUtility.isSubscribe()
        
        
        if AppDelegate.shared.language == "ar"{
                  self.tableView.semanticContentAttribute = .forceRightToLeft
              }else{
                  self.tableView.semanticContentAttribute = .forceLeftToRight
              }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 3 {
                   //SKStoreReviewController.requestReview()
            let appContent = AppDelegate.shared.appContent

            if let url = URL(string: appContent?.appStore ?? "https://store.apple.com/" ){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            

        }
        
        
    }
    
    
    
    
    
    
    
    func startUpdateRequeset(){
        var params = [String:String]()
        params["allow_notifi"] =  notificationSwitch.isOn ? "1" : "0"
        
        API.UPDATE_PROFILE.startRequest(showIndicator: true,  params: params) { (Api, statusResult) in
            if statusResult.isSuccess {
                
                let user = MatajerUtility.loadUser()
                
                let value = statusResult.data as! [String :Any]
                let userData = try! JSONSerialization.data(withJSONObject: value, options: [])
                let newUser = try! JSONDecoder().decode(User.self, from: userData)
                newUser.apiToken = user?.apiToken
                
                MatajerUtility.saveUser(user: newUser)
                
                self.changeChannelSubscribtion()
                
            }else{
                self.notificationSwitch.isOn = !self.notificationSwitch.isOn
                self.showOkAlert(title: "", message: statusResult.errorMessege)
                self.changeChannelSubscribtion()
                
            }
        }
        
    }
    
    
    
    func changeChannelSubscribtion(){
        if !notificationSwitch.isOn {
            Messaging.messaging().unsubscribe(fromTopic: API.FIREBASE_SUBSCRIBE_iosArTopic){ error in
                if error == nil {
                    MatajerUtility.setIsSubscribe(subscribe: false)
                }
            }
        }else{
            Messaging.messaging().subscribe(toTopic: API.FIREBASE_SUBSCRIBE_iosArTopic){
                error in
                if error == nil {
                    MatajerUtility.setIsSubscribe(subscribe: true)
                }
            }
        }
    }
    
    
    
    @IBAction func switchChange(_ sender: UISwitch) {
        
        if MatajerUtility.isLogin() {
            startUpdateRequeset()
        }else{
            
           changeChannelSubscribtion()
            
        }
    }
    
    
    
    
    @IBAction func facebookClicked(_ sender: Any) {
        let appContent = AppDelegate.shared.appContent
        let websiteURL = appContent!.facebook
        openWebSiteAction(url: websiteURL)
    }
    
    
    
    @IBAction func twitterClicked(_ sender: Any) {
        let appContent = AppDelegate.shared.appContent
        let websiteURL = appContent!.twitter
        openWebSiteAction(url: websiteURL)
    }
    
    
    
    @IBAction func instgramClicked(_ sender: Any) {
        let appContent = AppDelegate.shared.appContent
                let websiteURL = appContent!.instagram
               openWebSiteAction(url: websiteURL)
    }
    
    
    
    @objc func openWebSiteAction(url :String){
        openURLWebView(url: url)

        if let link = URL(string: url) {
           // UIApplication.shared.open(link)
         }
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = super.tableView(tableView, cellForRowAt: indexPath)
           
            if indexPath.row == 2 {
                return cell
            }
            if let label = cell.textLabel, let id = label.accessibilityIdentifier, id.count > 0 {
               let key = id + ".text"
               let localizedString = NSLocalizedString(key, tableName: "Main", comment: "")
               if key != localizedString {
                   label.text = localizedString
                   
                   if AppDelegate.shared.language == "ar" {
                       label.textAlignment = .right
                   }else{
                       label.textAlignment = .left
                   }
               }
           }
           return cell
       }
    
    
    
  
}
