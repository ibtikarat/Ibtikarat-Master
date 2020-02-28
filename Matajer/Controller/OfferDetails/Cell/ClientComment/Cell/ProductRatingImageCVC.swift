//
//  RatingImageCVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 15/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import SDWebImage
class ProductRatingImageCVC: UICollectionViewCell {

    
    @IBOutlet weak var imgView :UIImageView!
    
    var imageValue :String? {
        didSet{
            imgView.sd_setImage(with: URL(string: imageValue!), completed: nil)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
