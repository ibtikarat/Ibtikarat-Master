//
//  CatProductCollectionViewCell.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 08/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class MarkaCVC: UICollectionViewCell {

    @IBOutlet weak var backgroundIV: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
      
    }
    
    
//
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        self.invalidateIntrinsicContentSize()
        backgroundIV.invalidateIntrinsicContentSize()
        
        backgroundIV.layer.cornerRadius = backgroundIV.frame.size.height / 2

        
        
      
    }

    
}
