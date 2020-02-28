//
//  FavoriteCV.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 10/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class FavoriteCV: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBOutlet weak var collectionView :UICollectionView!
    @IBOutlet weak var emptyView :UIView!
    @IBOutlet weak var textForEmptyLbl :UILabel!
    @IBOutlet weak var buttonLogin :UIButton!

    
    var favoraites :[Product] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyView.isHidden = true
        collectionView.isHidden = true
        // Do any additional setup after loading the view.
        registerCollectioView()
        initData()
        
        buttonLogin.isHidden = true

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if !MatajerUtility.isLogin() {
            showEmpty()

            textForEmptyLbl.text = "you_must_be_logged_in_to_view_products_in_favorites".localized
            buttonLogin.isHidden = false
        }else{
            startReqestFavorate()
            buttonLogin.isHidden = true

        }
        
    }
    
    func registerCollectioView(){
        collectionView.register(UINib(nibName: "FavoriteCVC", bundle: .main), forCellWithReuseIdentifier: "FavoriteCVC")
        
    }
    
    
    func initData(){
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    private func startReqestFavorate(){
        API.MY_FAVORITES.startRequest(showIndicator: true) { (Api, statusResult) in
            if statusResult.isSuccess {
                let value = statusResult.data  as! [Any]
                
                
                let productData = try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                
                self.favoraites = try! JSONDecoder().decode([Product].self, from: productData)
                
                if self.favoraites.isEmpty {
                                   self.showEmpty()
                               }else{
                                   self.hideEmpty()
                               }
                self.collectionView.reloadData()
            }else{
                self.showOkAlert(title: "", message: statusResult.errorMessege)
            }
        }
    }
    
    
    
    private func startReqestremoveFavorate(product :Product){
//        {id}/favorite
        API.REMOVE_FAVORITES.startRequest(showIndicator: true,nestedParams: product.id.description + "/favorite"  ) { (Api, statusResult) in
            if statusResult.isSuccess {
                 
                self.startReqestFavorate()
                
                self.showOkAlert(title: "", message: statusResult.message)

                self.collectionView.reloadData()
            }else{
                self.showOkAlert(title: "", message: statusResult.errorMessege)
            }
        }
    }
    
    
    
    func showEmpty(){
        self.view.bringSubviewToFront(emptyView)
        emptyView.isHidden = false
        collectionView.isHidden = true
        textForEmptyLbl.text = "no_products_in_favorites".localized

    }
    
    
    func hideEmpty(){
        self.view.bringSubviewToFront(collectionView)
        emptyView.isHidden = true
        collectionView.isHidden = false
    }
    
    
    
    
}


extension FavoriteCV : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoraites.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCVC", for: indexPath) as! FavoriteCVC
        cell.product = favoraites[indexPath.row]
        
        cell.addToCartButton.tag = indexPath.row
        cell.addToCartButton.addTarget(self, action: #selector(actionAddToCart), for: .touchUpInside)
        
        
        cell.removeToFav.tag = indexPath.row
        cell.removeToFav.addTarget(self, action: #selector(actionRmoveFav), for: .touchUpInside)
        
        cell.clickedAddToCart = clickedAddToCart

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat =  4
        let collectionViewSize = collectionView.frame.size.width - padding
        collectionView.invalidateIntrinsicContentSize()
        return CGSize(width: collectionView.frame.size.width - 5, height: 170)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "OfferDetailsVC") as! OfferDetailsVC2
        
        vc.selectedProduct = favoraites[indexPath.row]

        self.present(vc, animated: false, pushing: true )
    }
    
    
    @objc func actionAddToCart(_ sender :UIButton){
                
        let product = favoraites[sender.tag]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OfferDetailsVC") as! OfferDetailsVC2
        vc.selectedProduct = product
        
        self.present(vc, animated: false, pushing: true )
    }
       
    
    
    
    
    @objc func actionRmoveFav(_ sender :UIButton){
                
        let product = favoraites[sender.tag]

        
        self.startReqestremoveFavorate(product: product)
        
        
    }
       
    
      func clickedAddToCart(product :Product)  {
             self.addToCart(product: product)
         }
}



