//
//  UICheckBox.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 07/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit


class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
            self.sizeToFit()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
    
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
           for subview in subviews {
               if !subview.isHidden && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                   return true
               }
           }
           return false
       }
    
    
}
