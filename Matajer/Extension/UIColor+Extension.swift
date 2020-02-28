//
//  UIColor.swift
//  Tammweel
//
//  Created by ayyad on 10/15/17.
//  Copyright © 2017 businesssuite.com. All rights reserved.
//

import UIKit

extension UIColor{

    

    
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    
    struct CustomColor {
        static let primaryColor = UIColor(named: "primaryColor")! 
        static let colorAccent =  UIColor(named: "accentColor")!
        static let primaryColor2 =  UIColor(named: "primaryColor2")!
        static let badgeColor = UIColor(named: "badgeColor")!
        static let grayDark =  UIColor(rgb:0x49565C)
        static let grayDark2 = UIColor(rgb:0x4A4A4A)
        static let grayLight =  UIColor(rgb:0xBFBFBF)
        static let textFeildBorder =  UIColor(rgb: 0xE6E6E6)
        static let background =  UIColor(rgb: 0xFAFAFA)
        static let bunnerRedBackgroundColor =  UIColor(rgb: 0xc62828)
        static let bunnerGreenBackgroundColor =  UIColor(rgb: 0x2e7d32)


    }
    
    
}
