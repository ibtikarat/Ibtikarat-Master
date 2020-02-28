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
    
    
    @IBOutlet weak var titleLbl :UILabel!
    @IBOutlet weak var imageView :UIImageView!

    
    var marka :TradeMark? = nil {
        didSet{
            let mar = marka!
            titleLbl.text = mar.name
            imageView.sd_setImage(with: URL(string:mar.image!)!, completed: nil)
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
      
    }
    
    func setupView(){
        contentView.setNeedsLayout()
    }
    
//
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupView()
        self.invalidateIntrinsicContentSize()
        backgroundIV.invalidateIntrinsicContentSize()
        
        backgroundIV.layer.cornerRadius = (contentView.frame.size.width / 2 ) - 4
        print("contentView seize : " + "\(  self.contentView.frame.size)")
        print("backgroundIV seize : " + "\(  self.backgroundIV.frame.size)")

      
    }

    
}
