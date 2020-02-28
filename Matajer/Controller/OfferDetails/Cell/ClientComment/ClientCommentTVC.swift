//
//  MyRatingTVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 25/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import Cosmos
class ClientCommentTVC: UITableViewCell {

    
        @IBOutlet weak var usernameLbl: UILabel!
        
        @IBOutlet weak var commentLbl: UILabel!
    
    
       @IBOutlet weak var dateLbl: UILabel!
       
       @IBOutlet weak var reat: CosmosView!
       
       @IBOutlet weak var imageCollectionViews: UICollectionView!
       
    
    
    
      
         var rating :Rate? {
             didSet{
                 let rat = rating!
    
                 usernameLbl.text =  rat.username
                 
                 commentLbl.text = rat.comment
                 
                 reat.rating = Double(rat.rateValue)
                
               
                
                dateLbl.text = Date.changeFormat(dateString: rat.createdAt!)
                
                
                // dateLbl.text = rat.createdAt
                 
                if rat.images.isEmpty {
                    imageCollectionViews.visibility = .gone
                }else{
                    imageCollectionViews.visibility = .visible
                    imageCollectionViews.reloadData()
                }
             }
         }
         
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initData()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func initData(){
        
        imageCollectionViews.register(UINib(nibName: "ProductRatingImageCVC", bundle: nil), forCellWithReuseIdentifier: "ProductRatingImageCVC")
        
        imageCollectionViews.dataSource = self
        imageCollectionViews.delegate = self
    }

    
    
}




extension ClientCommentTVC : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rating!.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductRatingImageCVC", for: indexPath) as! ProductRatingImageCVC
     
        cell.imageValue = rating!.images[indexPath.row].img
        
        return cell
    }
    
    
}



