//
//  CustomNavBar.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 06/10/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class CustomNavBar: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //addBackgroundToBar()
        // Do any additional setup after loading the view.
        clearNavBar()

    }
     func clearNavBar(){
    
           
            navigationBar.isTranslucent = true
           navigationBar.setBackgroundImage(UIImage(), for: .default)
           navigationBar.shadowImage = UIImage()
       
           self.loadViewIfNeeded()
           self.navigationBar.layoutIfNeeded()
           self.view.setNeedsDisplay()
       }
     func addBackgroundToBar(){
            navigationBar.isTranslucent = true
           
           let image = imageWithSize(image: UIImage(named: "img_nav_background")!, scaledToSize: CGSize(width: self.view.frame.width, height: 203))
           navigationBar.setBackgroundImage(image, for: .default)
        
        navigationBar.tintColor  = UIColor.init(displayP3Red: 72, green: 86, blue: 92, alpha: 1)
         navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.red]

           navigationBar.shadowImage = UIImage()
           navigationBar.tintColor = UIColor.white

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
