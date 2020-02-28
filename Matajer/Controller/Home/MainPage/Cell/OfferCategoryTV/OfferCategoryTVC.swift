//
//  OfferCategoryTVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 09/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import Loady
class OfferCategoryTVC: UITableViewCell {

    //for suggestion
    @IBOutlet weak var moreButton :UIButton!

    @IBOutlet weak var inducatorImage :UIImageView!
    
    
    @IBOutlet weak var titleCategoryLbl :UILabel!
    @IBOutlet weak var collectionViews :UICollectionView!
    
    
    
    var offerClicked :((Product) ->())?
    var clickedAddToCart :((Product) ->())?
    var moreClicked :((Category) ->())?
    var addOrRemoveFavClicked :((Product,Int) ->())?
    
    
    var isProductDetails = false
    
    var category :Category?{
        didSet{
            let cat = category!
            titleCategoryLbl.text = cat.name
            products = cat.products!
            
            
            //check if suggestion
            if category?.id == -1 {
                moreButton.isHidden = true
                inducatorImage.isHidden = true
            }else{
                moreButton.isHidden = false
                inducatorImage.isHidden = false
            }
        }
    }
    
    var products :[Product] = [] {
        didSet{
            collectionViews.reloadData()
        }
    }
    
    
    
     override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        registerCell()
        reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func registerCell(){
        collectionViews.register(UINib(nibName: "OfferCVC", bundle: .main), forCellWithReuseIdentifier: "OfferCVC")
        
        collectionViews.register(UINib(nibName: "OfferBigCVC", bundle: .main), forCellWithReuseIdentifier: "OfferBigCVC")
    }
    
    func reloadData(){
        collectionViews.dataSource = self
        collectionViews.delegate = self

        collectionViews.reloadData()
    }
    
    
    
    @IBAction func moreClicked(_ sender :UIButton){
        moreClicked?(category!)
    }
}


extension OfferCategoryTVC :UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OfferCVC", for: indexPath) as! OfferCVC
        cell.product = products[indexPath.row]
        cell.addToCartButton.tag = indexPath.row
        cell.addToCartButton.addTarget(self, action: #selector(buttonClickedAddToCart), for: .touchUpInside)
      
        cell.addToFav.tag = indexPath.row
        cell.addToFav.addTarget(self, action: #selector(buttonClickedAddOrRemove), for: .touchUpInside)
       
        
        if isProductDetails {
            cell.contentView.layer.cornerRadius = 3
            cell.contentView.layer.borderColor = UIColor.CustomColor.textFeildBorder.cgColor
            cell.contentView.layer.borderWidth = 0.5
        }
        
        return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        offerClicked?(products[indexPath.row])
    }
    


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if isFirstRow{
//            return CGSize(width: 167, height: 316)
//        }else{
           return CGSize(width: 141, height: 346)
//        }
    }


    @objc func buttonClickedAddToCart(_ sender :UIButton){
        let btn = sender as! LoadyButton
        let product = self.products[sender.tag]

        self.clickedAddToCart?(product)

      
    }

    
    @objc func buttonClickedAddOrRemove(_ sender :UIButton){
         let product = products[sender.tag]
        addOrRemoveFavClicked?(product,sender.tag)
     }

    
    
}
