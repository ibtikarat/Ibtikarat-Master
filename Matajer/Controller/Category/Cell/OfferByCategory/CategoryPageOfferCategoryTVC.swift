//
//  OfferCategoryTVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 09/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class CategoryPageOfferCategoryTVC: UITableViewCell {

    
    var offerClicked :((Product) ->())?
    var clickedAddToCart :((Product) ->())?
    var clickedAddToFav :((Product) ->())?
    var clickedShowMoreProduct :((Category) ->())?

    
    var width :CGFloat = 0
    
    
    
    
    var category :Category! {
        didSet{
            self.collectionViews.reloadData()
        }
    }
    
    @IBOutlet weak var collectionViews :UICollectionView! {
        didSet {
//            flow.minimumLineSpacing = 8.0
//            flow.estimatedItemSize = CGSizeMake(155.0, 66.0)
//            flow.scrollDirection = .Vertical
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerCell()
//
//        reloadData()
        collectionViews.isScrollEnabled = false
        setupCell()
         reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func registerCell(){
        collectionViews.register(UINib(nibName: "OfferCVC", bundle: .main), forCellWithReuseIdentifier: "OfferCVC")
        collectionViews.register(UINib(nibName: "LoadMoreCVC", bundle: .main), forCellWithReuseIdentifier: "LoadMoreCVC")
    }
    
    func reloadData(){
        collectionViews.dataSource = self
        collectionViews.delegate = self

    }
    
    
    func setupCell() {
        contentView.setNeedsLayout()
    }
//
    
    override func layoutSubviews() {
        super.layoutSubviews()

        
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        collectionViews.layoutIfNeeded()

        collectionViews.frame = CGRect(x: 0.0, y: 0.0, width: width, height: CGFloat(MAXFLOAT))
        
        

        return collectionViews.collectionViewLayout.collectionViewContentSize
    }
//
    
    
    
}


extension CategoryPageOfferCategoryTVC :UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.products!.count == 5 ? 6 : category.products!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 5{
            //show cell more product
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadMoreCVC", for: indexPath) as! LoadMoreCVC
                cell.contentView.layer.cornerRadius = 3
                cell.contentView.layer.borderColor = UIColor.CustomColor.textFeildBorder.cgColor
                cell.contentView.layer.borderWidth = 0.5
            return cell
        }
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OfferCVC", for: indexPath) as! OfferCVC
        cell.contentView.layer.cornerRadius = 3
        cell.contentView.layer.borderColor = UIColor.CustomColor.textFeildBorder.cgColor
        cell.contentView.layer.borderWidth = 0.5
        cell.product = category.products![indexPath.row]
        
        cell.addToCartButton.tag = indexPath.row
        cell.addToCartButton.addTarget(self, action: #selector(addToCart), for:             .touchUpInside)
        
        
        
        cell.addToFav.tag = indexPath.row
        cell.addToFav.addTarget(self, action: #selector(addToFav), for:             .touchUpInside)
        
        
        
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            collectionView.invalidateIntrinsicContentSize()

            let padding: CGFloat = 15
            let collectionViewSize = collectionView.frame.size.width - padding
            
             return CGSize(width: collectionViewSize/2 , height: 346)
      
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 5{
            showMoreProduct()
            return
        }
        
        
        let products = category.products
        offerClicked?(products![indexPath.row])
    }
    
    
    
    @objc func addToCart(_ sender :UIButton){
        var product = category.products![sender.tag]
        clickedAddToCart?(product)
    }
    
    
    
      @objc func addToFav(_ sender :UIButton){
          var product = category.products![sender.tag]
          clickedAddToFav?(product)
      }
    
    
    @objc func showMoreProduct(){
       clickedShowMoreProduct?(category)
    }
    
    
    
}
