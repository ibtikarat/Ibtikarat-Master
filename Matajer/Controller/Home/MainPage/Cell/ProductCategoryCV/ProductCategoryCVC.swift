//
//  CatProductCollectionViewCell.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 08/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import SDWebImage
class ProductCategoryCVC: UICollectionViewCell {


    @IBOutlet weak var titleLbl :UILabel!
    @IBOutlet weak var imageView :UIImageView!

    
    
    var category :Category? = nil {
        didSet{
            let cat = category!
            titleLbl.text = cat.name
            imageView.sd_setImage(with: URL(string:cat.image!)!, completed: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
