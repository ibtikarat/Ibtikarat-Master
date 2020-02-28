//
//  AddAddToCartButton.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 03/01/2020.
//  Copyright © 2020 Abdullah Ayyad. All rights reserved.
//

import UIKit
import Loady
class AddToCartButton: LoadyButton {
 
    
    var image :UIImage?
  
   
    
    
    
    
    
    override func layoutSubviews() {
 
        super.layoutSubviews()
    
        if self.imageView!.image != nil {
            image = self.imageView!.image
        }

        
        self.contentEdgeInsets = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
          
    }
    
    
    override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        
        self.setAnimation(LoadyAnimationType.indicator(with:
                  .init(indicatorViewStyle: .light)))

        self.setImage(nil, for: .normal)

         self.startLoading()
              
    self.layoutIfNeeded()


        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.setImage(self.image, for: .normal)
             self.stopLoading()
            super.sendAction(action, to: target, for: event)
        }
        
      

    }
    
    override func sendActions(for controlEvents: UIControl.Event) {
        
        self.setAnimation(LoadyAnimationType.indicator(with:
            .init(indicatorViewStyle: .light)))
        
//        self.setAnimation(LoadyAnimationType.topLine())
              
        self.setImage(nil, for: .normal)

        self.startLoading()
        self.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.setImage(self.image, for: .normal)

                     self.stopLoading()
            super.sendActions(for: controlEvents)
        }
        
        
        
    }
    
    
    
    override func draw(_ rect: CGRect) {
         self.applyGradient(colours: [UIColor.CustomColor.primaryColor2,UIColor.CustomColor.primaryColor],gradientOrientation : GradientOrientation.horizontal)
        super.draw(rect)
        
        
       
    }

 
    
     
    
}
