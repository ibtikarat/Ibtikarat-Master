//
//  LineWithDotPageControl.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 04/01/2020.
//  Copyright © 2020 Abdullah Ayyad. All rights reserved.
//

import UIKit

class LineWithDotPageControl: UIPageControl {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard !subviews.isEmpty else { return }
        
        let spacing: CGFloat = 3
        
        let width: CGFloat = 16
        
        let height: CGFloat = 8
        
        var total: CGFloat = 0
        
        for (index,view) in subviews.enumerated() {
            view.layer.cornerRadius = 4

            if self.currentPage == index {
            view.frame = CGRect(x: total, y: frame.size.height / 2 - height / 2, width: width, height: height)
            total += width + spacing
            }else{
                view.frame = CGRect(x: total, y: frame.size.height / 2 - height / 2, width: height, height: height)
                
                total += height + spacing

            }
        }
        
        total -= spacing
        
        frame.origin.x = frame.origin.x + frame.size.width / 2 - total / 2
        frame.size.width = total
    }

}
