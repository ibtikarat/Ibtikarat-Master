//
//  UIBarButtonItem.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 26/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

extension UIBarButtonItem  {

    static func backButtonTitle(image: UIImage = #imageLiteral(resourceName: "ic_inducator_forward"), title: String = "Back", target: Any,action: Selector) -> UIBarButtonItem {
        
           let button = UIButton()

            var image  = image
            if   AppDelegate.shared.language == "ar" {
                image = UIImage(named: "ic_end_back")!
                //image =  image.withTintColor(UIColor.white)
                button.setImage(image, for: .normal)
                button.tintColor = UIColor.white
                if #available(iOS 13, *){
                    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
                }else{
                    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: -10)
                    button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
                }

            }else{
                image = UIImage(named: "ic_start_back")!
                //image =  image.withTintColor(UIColor.white)
                 button.setImage(image, for: .normal)
                button.tintColor = UIColor.white
                if #available(iOS 13, *){
                    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
                }else{
                    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
                    button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
                }

            }

        
            // button.frame.size.width = 200
             button.addTarget(target, action: action, for: .touchUpInside)
             button.setTitle(title, for: .normal)
                
        
 
             //button.imageVerticalAlignment = .center
             //button.imageHorizontalAlignment = .start
            button.setTitleColor(UIColor.white, for: .normal)
              button.sizeToFit()
              button.translatesAutoresizingMaskIntoConstraints = false
             
          
//              let stackView = UIStackView(frame: CGRect(x: 100, y: 0, width: 150, height: 30))
        
//              stackView.addSubview(button)
//              stackView.sizeToFit()
          
//              NSLayoutConstraint.activate([
//                            button.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
//                            button.centerYAnchor.constraint(equalTo: stackView.centerYAnchor)
//              ])
             return UIBarButtonItem(customView: button)
         }
    
    
    
}
