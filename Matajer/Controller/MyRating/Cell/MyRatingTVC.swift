//
//  MyRatingTVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 25/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage
class MyRatingTVC: UITableViewCell {

    @IBOutlet weak var categorLbl: UILabel!
    
    @IBOutlet weak var productTitleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var priceWithCommissionLbl: UILabel!
    @IBOutlet weak var price: UILabel!
 
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var reat: CosmosView!
    
    @IBOutlet weak var imageCollectionViews: UICollectionView!
    
    
    @IBOutlet weak var imgView: UIImageView!

    
    var commistionPrice = " 500 ر.س" {
        didSet{
            if commistionPrice.isEmpty {
                price.text = commistionPrice
                return
            }
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string:commistionPrice)
              attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
              price.attributedText = attributeString
        }
    }
    
    
    
    
    var rating :Rate? {
        didSet{
            let rat = rating!

            if !rat.product!.priceAfterDiscountValue.isEmpty {
                  priceWithCommissionLbl.text = rat.product!.priceAfterDiscountValue
                  commistionPrice = rat.product!.priceValue
            }else{
              priceWithCommissionLbl.text = rat.product!.priceValue
              commistionPrice = ""
            }
            
            
            
            categorLbl.text = ""
            productTitleLbl.text = rat.product!.name
            descriptionLbl.text = rat.comment
            
            
            imageCollectionViews.reloadData()
            
            reat.rating = Double(rat.rateValue)
            dateLbl.text = rat.createdAt
            
            imgView.sd_setImage(with: URL(string: rat.product!.image), completed: nil)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        initData()
        
    }
    
    
    func initData(){
        
        imageCollectionViews.register(UINib(nibName: "RatingImageCVC", bundle: nil), forCellWithReuseIdentifier: "RatingImageCVC")
        
        imageCollectionViews.dataSource = self
        imageCollectionViews.delegate = self
    }

    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension MyRatingTVC : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rating!.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RatingImageCVC", for: indexPath) as! RatingImageCVC
     
        cell.imageValue = rating!.images[indexPath.row].img
        return cell
    }
    
    
}
