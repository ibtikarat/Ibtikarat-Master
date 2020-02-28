//
//  ProfileNVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 25/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class AddressNVC: UINavigationController,UINavigationControllerDelegate {
  override var preferredStatusBarStyle: UIStatusBarStyle {
       return .lightContent
   }
    let statusbarView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
            //addBackgroundToBar()
        // Do any additional setup after loading the view.
        //initStatusBar()

       // self.navigationBar.delegate = self
        self.delegate = self
        
//        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;

        //edgesForExtendedLayout = []
        self.view.backgroundColor = UIColor.CustomColor.grayDark
        self.navigationBar.tintColor = UIColor.white
        //clearNavBar()
        addBackgroundToBar()
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        addBackgroundToBar()

        //clearNavBar()
        //refreshBackground()

    }
    
    
    
    func clearNavBar(){

        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = UIColor.clear
   
        navigationBar.backgroundColor = UIColor.clear
        changeStatusBar(backgroundColor: UIColor.clear)
        
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
        changeStatusBar(backgroundColor: UIColor.CustomColor.grayDark)

        
        
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
