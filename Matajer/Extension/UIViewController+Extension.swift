//
//  UIViewController.swift
//  SmartSafty
//
//  Created by Abdullah Ayyad on 10/18/19.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation
import UIKit
import SKActivityIndicatorView
import PopupDialog
import SVProgressHUD
import SystemConfiguration
import NotificationBannerSwift

extension UIViewController : UITextFieldDelegate {
    
    
    func showOkAlertLagacy(title :String, message :String,completion:@escaping (Bool) -> Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "ok".localized, style: UIAlertAction.Style.default) { (UIAlertAction) in
            if completion != nil {
                completion(true)
            }
        }
        
        
        alert.addAction(okAction)
        //canPerformAction;
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    func showBunnerAlert(title:String,message:String,backgroundColor :UIColor = UIColor.CustomColor.bunnerRedBackgroundColor , completion:(() -> Void)? = nil) {
        let banner = NotificationBanner(title: title, subtitle: message, style: .success)
                     banner.backgroundColor = backgroundColor
                     
                     let titleFont = UIFont(name: "SSTArabic-Medium", size: 13)
                     let bodyFont = UIFont(name: "SSTArabic-Medium", size: 12)
        
        banner.show(queuePosition: .front, bannerPosition: .top,queue: NotificationBannerQueue.init(maxBannersOnScreenSimultaneously: 1))
 
                     banner.applyStyling(cornerRadius: 4, titleFont: titleFont, titleColor: UIColor.white, titleTextAlign: NSTextAlignment.natural, subtitleFont: bodyFont, subtitleColor:  UIColor.white, subtitleTextAlign: NSTextAlignment.natural)
        
             banner.onTap = {
                completion?()
            }
    }
    
    func showOkAlert(title:String,message:String , completion:(() -> Void)? = nil) {
        
        // Create the dialog
        
        let popup = PopupDialog(title: title,
                                message: message,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn,
                                tapGestureDismissal: false,
                                panGestureDismissal: false,
                                hideStatusBar: false) {
        }
        
        let okButton = DefaultButton(title:  "ok".localized) {
            completion?()
            popup.dismiss()
        }
        
        popup.addButton(okButton)
        self.present(popup, animated: true, completion: nil)
    }
    
    func showCustomAlert(title:String,message:String,okTitle:String,cancelTitle:String,color :UIColor = UIColor.red ,completion:@escaping (Bool) -> Void) {
        
        // Create the dialog
        let popup = PopupDialog(title: title,
                                message: message,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn,
                                tapGestureDismissal: false,
                                panGestureDismissal: false,
                                hideStatusBar: false) {
        }
        
        let cancelButton = CancelButton(title: cancelTitle) {
            completion(false)
            popup.dismiss()
        }
        
        cancelButton.titleColor = UIColor.red
        
        let okButton = DefaultButton(title: okTitle) {
            completion(true)
        }
        
       
        popup.addButtons([okButton,cancelButton])
        
        
        self.present(popup, animated: true, completion: nil)
    }
    
    func showOkAlertWithComp(title:String,message:String,okTitle:String = "ok".localized ,completion:@escaping (Bool) -> Void) {
        
        // Create the dialog
        let popup = PopupDialog(title: title,
                                message: message,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn,
                                tapGestureDismissal: false,
                                panGestureDismissal: false,
                                hideStatusBar: false) {
        }
        
        let okButton = DefaultButton(title: okTitle) {
            completion(true)
        }
        
        popup.addButton(okButton)
        self.present(popup, animated: true, completion: nil)
    }
    //simple alert
    func showRetryInterntConnection(completion:@escaping (Bool)->Void) {
        showOkAlertWithComp(title: "connection_error".localized, message: "please_check_your_internet_connection".localized ,okTitle: "retry".localized, completion: completion)
    }
    
    func showAlertNoInternt() {
        showOkAlert(title: "", message: "please_check_your_internet_connection")
    }
    
    func isInterntConnected(completion:@escaping (Bool)->Void){
        guard isConnectedToNetwork() else {
            self.showRetryInterntConnection(completion: completion)
            return
        }
    }
    
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
//    func openRightMenu() {
//        panel?.openRight(animated: true)
//    }
//
//    func openLeftMenu() {
//        panel?.openLeft(animated: true)
//    }
//    
//    func centerVC(vc: UIViewController) {
//        _ = self.panel?.center(vc)
//    }
//
    func showIndicator() {
        //SKActivityIndicator.show("" ,userInteractionStatus: false)
        SVProgressHUD.show()
    }
    
  
    
    func hideIndicator() {
        //SKActivityIndicator.dismiss()
        SVProgressHUD.dismiss()

    }
    
    
    
    @IBAction func pop(){
        if self.navigationController is AddressNVC  && self.navigationController?.viewControllers.count == 1{
            self.dismiss(animated: true, completion: nil)
        }else{
        
        self.navigationController?.popViewController(animated: true)
        }

    }
    
    @IBAction func colse(){
        self.dismiss(animated: true)
    }
    
   
    
    
    
    @IBAction func singOut(){
        self.showCustomAlert(title: "logout".localized, message:"sign_out".localized, okTitle: "no".localized , cancelTitle:"logout".localized){ result in

                if  !result {
                    API.LOGOUT.startRequest(showIndicator: true) { (api, statusResult) in
                        if statusResult.isSuccess{
                                     MatajerUtility.logOut()
                            
                                               let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                               appDelegate.initLanguage()
                                               let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
                            let viewController :MainTabBarVC  = mainStoryBoard.instantiateViewController(withIdentifier: "MainTabBarVC") as! MainTabBarVC
                                               appDelegate.window?.rootViewController = viewController;
                        }else{
                            self.showOkAlert(title: "", message: statusResult.errorMessege)
                        }
                    }
                    
          

                }
            }
    }
    
    
    
    @IBAction func singOutWithPermently(message :String){
        self.showOkAlertWithComp(title: "", message: message, okTitle: "logout".localized) { (bool) in
                    MatajerUtility.logOut()

                   let appDelegate = UIApplication.shared.delegate as! AppDelegate

                    let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let viewController :MainTabBarVC  = mainStoryBoard.instantiateViewController(withIdentifier: "MainTabBarVC") as! MainTabBarVC
                   appDelegate.window?.rootViewController = viewController;
        }
       
    }
    
    
    
    
    
   @IBAction func signIn(){
        if !MatajerUtility.isLogin(){
        let loginStoryboard = UIStoryboard(name: "LoginRegistration", bundle: nil)
            let loginVC  = loginStoryboard.instantiateViewController(withIdentifier: "LoginRegistrationNAV")
        self.present(loginVC, animated: true, completion: nil)
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func instanceView<T: UIView>() -> T {
        
        guard let view = Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?.first as? T else {
            fatalError("Could not locate View with with identifier \(String(describing: T.self)) in Your Project.")
        }
        return view
    }
    
    
    
   @IBAction func startOver(){

    
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    let vc =  mainStoryboard.instantiateViewController(withIdentifier: "MainTabBarVC")
    
        self.present(vc, animated: true){
         }
     
    }
    
    
    
    
    func addToCart(product :Product, quantity :Int = 1){
        RealmHelper.addToCart(product: product, quantity : quantity)
        let storyboard = UIStoryboard(name: "Dialogs", bundle: nil)
        let vc :CartAddDialogVC = storyboard.instanceVC()
        vc.selectedProduct = product
        present(vc, animated: true, completion: nil)
    }
    
    
    
    
     
     
    func openURLWebView(url :String){
         let storyboard = UIStoryboard(name: "Main2", bundle: nil)
         let vc :WebVC = storyboard.instanceVC()
         vc.urlValue = url
        
        if self.navigationController != nil {
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            present(vc, animated: true, completion: nil)
        }
     }
    
    
    
    func setBackTitle(title :String){
        if #available(iOS 13, *) {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.backButtonTitle(title: title,target: self , action: #selector(pop))
        }else{
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.backButtonTitle(title: title,target: self , action: #selector(pop))
        }
    }
    
    
    
    
    
        open func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, pushing: Bool, completion: (() -> Void)? = nil) {
            
            if self.navigationController != nil {                self.navigationController?.pushViewController(viewControllerToPresent, animated: true)
            }else{
            
            
            if pushing {
                
                let transition = CATransition()
                transition.duration = 0.35
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromLeft
                transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                view.window?.layer.add(transition, forKey: kCATransition)
                viewControllerToPresent.modalPresentationStyle = .fullScreen
                self.present(viewControllerToPresent, animated: false, completion: completion)
                
            } else {
                self.present(viewControllerToPresent, animated: flag, completion: completion)
            }
                
            }
            
        }
        
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        if self.navigationController != nil && self.navigationController?.viewControllers.count != 1 {
         
                self.pop()
            
        }else{
              let transition = CATransition()
              transition.duration = 0.35
              transition.type = CATransitionType.push
              transition.subtype = CATransitionSubtype.fromRight
              transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
              self.view.window!.layer.add(transition, forKey: kCATransition)
              //presentedVC.view.window!.layer.add(transition, forKey: kCATransition)
          
          
          dismiss(animated: false, completion: nil)
          
       }
    }


}


