//
//  MainTabBarVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 06/10/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import RealmSwift
class MainTabBarVC: UITabBarController ,UITabBarControllerDelegate{
    

    static let messageFormNotification =  NSNotification.Name("messageFormNotification")
    
    var isDark = true
    var hasNotch: Bool {
        let bottom = self.view.window?.safeAreaInsets.bottom ?? 0
        return Int(bottom) > 0
    }
    
    var token : NotificationToken?
    
    var currentIndexSelected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        if hasBottomSafeAreaInsets {
            tabBar.selectionIndicatorImage = nil //UIImage(named: "ic_inducator_line_notch")
        } else {
            tabBar.selectionIndicatorImage = nil //UIImage(named: "ic_inducator_line")
            
            //... don't have to consider notch
        }
        
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return  .lightContent
    }
    
 
    
    
    
    var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {

            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 24
        }
        return false
    }
    var hasBottomSafeAreaInsets: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {

            return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0 > 0
        }
        return false
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let counter = RealmHelper.countInCart()
        self.viewControllers![2].tabBarItem.badgeColor = UIColor.CustomColor.badgeColor
        self.viewControllers![2].tabBarItem.setBadgeTextAttributes([NSAttributedString.Key.font : UIFont(name: "BahijTheSansArabic-Plain", size: 13)], for: .normal)
        self.viewControllers![2].tabBarItem.setBadgeTextAttributes([NSAttributedString.Key.font : UIFont(name: "BahijTheSansArabic-Plain", size: 13)], for: .selected)
        self.viewControllers![2].tabBarItem.badgeValue = counter != 0 ? counter.description   : nil
        
  
     
        
        NotificationCenter.default.addObserver(forName: MainTabBarVC.messageFormNotification, object: nil, queue: nil) { (notification) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            self.cheakNotification()
                }
            }
        
        let realm = try! Realm()
        token = realm.observe { notification, realm in
            var counter = RealmHelper.countInCart()
            self.viewControllers![2].tabBarItem.badgeValue = counter != 0 ? counter.description   : nil
        }
        cheakNotification()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
 
                NotificationCenter.default.removeObserver(self, name:  MainTabBarVC.messageFormNotification, object: nil)
        token!.invalidate()
    }
    
    
    
    
    
    
    func cheakNotification(){
        let notification = AppDelegate.shared.openFromNotifications

        if notification.fromNotificaiton {
            if self.presentedViewController != nil {
                self.presentedViewController?.dismiss(animated: false){
                    self.handelNotification()
                    
                }
                
            }else{
                self.handelNotification()

            }
            
            AppDelegate.shared.openFromNotifications.fromNotificaiton = false

        }
        
        
    }
    
    
    
    
    func handelNotification(){
        let notification = AppDelegate.shared.openFromNotifications
            let type = notification.NotificationTypes
            let modelId = Int(notification.modelId)!
            switch type{
            case .bankTransfer:
                self.goToBankTransfere(orderId: modelId )
                break
                
            case .category:
                let cat = Category(id:  modelId, image: "", name: "")
                self.goToProductCategory(category: cat)
                break
                
            case .mainCategory:
                let cat = Category(id:  modelId, image: "", name: "")
                self.goToProductMainCategory(category: cat)
                
                break
                
            case .order:
                
                goToOrder(orderId : notification.modelId.description )
                break
                
            case .product:
                self.goToProductDetailsClicked(productId: modelId)
                break
                
            case .tradeMark:
                let tredMarks = TradeMark(id:  modelId, name: "", image: "")
                self.goToTreadMarks(tradeMark: tredMarks)
                break
                
            default:
                goToNotifications()
                break
            }
        
    }
    
    
    
    
    func goToOrder(orderId :String){
        selectedIndex = 4
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            let mainOrder :OrderDetailsVC  = self.storyboard!.instanceVC()
            mainOrder.orderID = orderId
            let navigationCont = self.viewControllers?.last as! UINavigationController

            navigationCont.pushViewController(mainOrder, animated: true)
        }
        
    }
    
    
    
    func goToBankTransfere(orderId : Int){
        let storyboard = UIStoryboard(name: "Main2", bundle: nil)
        let vc :BankTransferVC = storyboard.instanceVC()
        vc.orderId = orderId
        vc.isfromCheckOut = false
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false,pushing: true){}
    }
    
    func goToNotifications(){
        selectedIndex = 4
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            let notification :NotificationVC  = self.storyboard!.instanceVC()
            let navigationCont = self.viewControllers?.last as! UINavigationController

            navigationCont.pushViewController(notification, animated: true)
        }
        
//        performSegue(withIdentifier: "NotificationVC", sender: nil)
    }
    
    func goToProductDetailsClicked(productId :Int)  {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "OfferDetailsVC") as! OfferDetailsVC2
        
        let product = Product(id: productId, price: "0", isOffer: 0, priceAfterDiscount: "", sliderImage: "", suggestions: [], name: "", reviewsDescription: "", image: "", grandRate: 0.0, ratesCount: 0, images: [], specifications: [], colors: [], tradeMark: TradeMark(id: 0, name: "", image: ""), category: Category(id: 0, image: "", name: ""), rates: [])
        
        
        vc.selectedProduct = product
        self.present(vc, animated: false, pushing: true )
    }
    
    
    
    func goToProductCategory(category :Category){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "MarkaPageVC") as! MoreProductPageVC
        vc.subCategroy = category
        self.present(vc, animated: false,pushing: true, completion: nil)
    }
    
    func goToProductMainCategory(category :Category){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "MarkaPageVC") as! MoreProductPageVC
        vc.category = category
        
        self.present(vc, animated: false,pushing: true, completion: nil)
     }
    
    
    
    func goToTreadMarks(tradeMark :TradeMark){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "MarkaPageVC") as! MoreProductPageVC
        vc.tradeMark = tradeMark
        self.present(vc, animated: false,pushing: true, completion: nil)
    }
    
    
    
    
    
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
         let selectedIndex = self.selectedIndex
        if selectedIndex == currentIndexSelected{
            NotificationCenter.default.post(name: MainVC.goToFirstTapInHome, object: nil, userInfo: [:])
        }
        currentIndexSelected = selectedIndex
    }
    
    
    
}




extension UIImage {
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}




