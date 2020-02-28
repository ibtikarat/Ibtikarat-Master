//
//  ProfileNVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 25/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class ProfileNVC: UINavigationController,UINavigationControllerDelegate,UINavigationBarDelegate {
  override var preferredStatusBarStyle: UIStatusBarStyle {
       return .lightContent
   }
    let statusbarView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
            //addBackgroundToBar()
        // Do any additional setup after loading the view.
        //initStatusBar()
         
//        self.edgesForExtendedLayout = []
//         self.extendedLayoutIncludesOpaqueBars = false

        self.navigationBar.delegate = self
        self.delegate = self
        
//        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;

        //edgesForExtendedLayout = []
        self.view.backgroundColor = UIColor.CustomColor.grayDark
        self.navigationBar.tintColor = UIColor.white
        clearNavBar()
        
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        clearNavBar()
        refreshBackground()

    }
    
    
    
    func clearNavBar(){
 
        
         navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = UIColor.clear

        
        
   
        navigationBar.backgroundColor = UIColor.clear
        //changeStatusBar(backgroundColor: UIColor.clear)

        
        
        self.loadViewIfNeeded()
        self.navigationBar.layoutIfNeeded()
        self.view.setNeedsDisplay()
    }
    
    
    func addBackgroundToBar(){
         navigationBar.isTranslucent = true
        
        let image = imageWithSize(image: UIImage(named: "img_nav_background")!, scaledToSize: CGSize(width: self.view.frame.width, height: 203))
        navigationBar.setBackgroundImage(image, for: .default)
        navigationBar.backgroundColor = UIColor.CustomColor.grayDark
      navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.red]

        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = UIColor.white
        
        
        
        navigationBar.backgroundColor = UIColor.CustomColor.grayDark
        //changeStatusBar(backgroundColor: UIColor.CustomColor.grayDark)

        
        
       self.loadViewIfNeeded()
        self.navigationBar.layoutIfNeeded()
        self.view.setNeedsDisplay()
        
    }

    
    func imageWithSize(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
 
    func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        refreshBackground()
        
        return true
    }
 
    func refreshBackground() {
        
        if viewControllers.count == 1 {
            clearNavBar()
            setNavigationBarHidden(true, animated: false)

        }else if viewControllers.count == 2{
            addBackgroundToBar()
            setNavigationBarHidden(false, animated: false)
        }else{
            setNavigationBarHidden(false, animated: false)
        }
//        }else if viewControllers.count == 3{
//
//
//        }
 
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        refreshBackground()
        viewController.view.layoutIfNeeded()
        

    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let vc = super.popViewController(animated: animated)
        
         
        refreshBackground()

        return vc
    }
    
    
    
    func initStatusBar(){
         if #available(iOS 13.0, *) {
                   let app = UIApplication.shared
                   let statusBarHeight: CGFloat = app.statusBarFrame.size.height
                   
                   let statusbarView = UIView()
                    view.addSubview(statusbarView)
                   statusbarView.translatesAutoresizingMaskIntoConstraints = false
                   statusbarView.heightAnchor
                       .constraint(equalToConstant: statusBarHeight).isActive = true
                   statusbarView.widthAnchor
                       .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
                   statusbarView.topAnchor
                       .constraint(equalTo: view.topAnchor).isActive = true
                   statusbarView.centerXAnchor
                       .constraint(equalTo: view.centerXAnchor).isActive = true
                 
               }
    }
    
    func changeStatusBar(backgroundColor :UIColor){
            if #available(iOS 13.0, *) {
                 //navigationBar.backgroundColor = backgroundColor

                statusbarView.backgroundColor = UIColor.red
            } else{
                        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
                    statusBar?.backgroundColor = backgroundColor
                }
     }
}
