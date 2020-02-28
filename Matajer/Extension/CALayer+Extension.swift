//
//  String.swift
//  SmartSafty
//
//  Created by Abdullah Ayyad on 10/18/19.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation
import UIKit
extension CALayer {
    var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.cgColor
        }
        
        get {
            return UIColor(cgColor: self.borderColor!)
        }
    }
}




@IBDesignable extension UIView{
    

    
}
