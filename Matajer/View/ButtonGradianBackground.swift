//
//  ButtonGradianBackground.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 21/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class ButtonGradianBackground: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
         Drawing code
    }
    */

  
    override func layoutSubviews() {
        super.layoutSubviews()
                self.applyGradient(colours: [UIColor.CustomColor.primaryColor2,UIColor.CustomColor.primaryColor],gradientOrientation : GradientOrientation.horizontal)
    }
    
    
    override func awakeFromNib() {
        
        
//          self.applyGradient(colours: [UIColor.CustomColor.colorAccent, UIColor.CustomColor.colorPrimary],gradientOrientation : GradientOrientation.horizontal)
//
        
//        let layer = self.layer as! CAGradientLayer
//        layer.colors = [UIColor.CustomColor.colorAccent, UIColor.CustomColor.colorPrimary].map{$0.cgColor}
//        layer.startPoint = CGPoint(x: 0, y: 0.5)
//        layer.endPoint = CGPoint (x: 1, y: 0.5)
        
//        if (sef.isHorizontal) {
//            layer.startPoint = CGPoint(x: 0, y: 0.5)
//            layer.endPoint = CGPoint (x: 1, y: 0.5)
//        } else {
//            layer.startPoint = CGPoint(x: 0.5, y: 0)
//            layer.endPoint = CGPoint (x: 0.5, y: 1)
//        }
    }
    
   
    
    
}
