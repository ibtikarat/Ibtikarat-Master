//
//  SearchResult.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 20/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class FilterResultVC: UIViewController {
         @IBOutlet weak var backButtonTitleButton :UIButton!

        @IBOutlet weak var collectionView :UICollectionView!
        @IBOutlet weak var modeView :UIView!
        @IBOutlet weak var styleImage :UIImageView!

        @IBOutlet weak var emptyView :UIView!
    
 
    
        var isGridViewMode = true
        
        
        var isFirstTime = true
        
     
        var products :[Product] = [] {
            didSet{
//                numberOfProductLbl.text = products.count.description
            }
        }
        var pageNumber = 1
        
        
        
    
        
        var searchValue :String = ""
    
        var filterObjects = [FilterObject]()

    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Do any additional setup after loading the view.
            styleImage.image = isGridViewMode ?  #imageLiteral(resourceName: "ic_home_tab_menu") : #imageLiteral(resourceName: "ic_home_tab_menu_grid")

            backButtonTitleButton.setTitle("search_result".localized, for: .normal)
            
            
           
            
            registerCollectioView()
            initData()
            initGestureRecognizerTap()
            startRequset()
        }
    
    
    
  
    
    
 
    
    
        
        func registerCollectioView(){
            collectionView.register(UINib(nibName: "OfferLargeCVC", bundle: .main), forCellWithReuseIdentifier: "OfferLargeCVC")
             collectionView.register(UINib(nibName: "OfferLargeRowCVC", bundle: .main), forCellWithReuseIdentifier: "OfferLargeRowCVC")
        }
        
        
        func initData(){
            collectionView.delegate = self
            
            collectionView.dataSource = self
            collectionView.collectionViewLayout.invalidateLayout()
        }
        
        func initGestureRecognizerTap(){
            let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(viewModeTap))
            modeView.addGestureRecognizer(singleTapGesture)
        }
        
        
        @objc func viewModeTap(_ sender :UITapGestureRecognizer){
            isGridViewMode = !isGridViewMode
            
            
            styleImage.image = isGridViewMode ?  #imageLiteral(resourceName: "ic_home_tab_menu") : #imageLiteral(resourceName: "ic_home_tab_menu_grid")
            collectionView.reloadData()
        }
        
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //        collectionView.collectionViewLayout.invalidateLayout()
    //    }
        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */

        func startRequset(){
            if isFirstTime {
                isFirstTime = !isFirstTime
                startReqest(forPage: pageNumber)
            }
        }
        
        private func startReqest(forPage pageNumber:Int){
            
            var params = [String:String]()
                params["main_categories"] = getIDsOfFilter(key :"main_categories")
                params["categories"] = getIDsOfFilter(key :"categories")
                params["tradeMarks"] = getIDsOfFilter(key :"tradeMarks")
                params["colors"] = getIDsOfFilter(key :"colors")
                params["ratings"] = getIDsOfFilter(key :"ratings")

            API.PRODUCTS_FILTER.startRequest(showIndicator: true,params: params,completion: response)
            
        }

        func response(api :API,statusResult :StatusResult){
            if statusResult.isSuccess {
                let value = statusResult.data as! [[String:Any]]
            
            
                let productData = try! JSONSerialization.data(withJSONObject:value, options: .prettyPrinted)
                
                self.products = try! JSONDecoder().decode([Product].self, from: productData)
                            
                
                             if self.products.isEmpty {
                                                self.showEmpty()
                                            }else{
                                                self.hideEmpty()
                                            }
                self.collectionView.reloadData()
            }else{
 
                self.showOkAlert(title: "", message: statusResult.errorMessege)
            }
        }
    
    
    
    
    
    func showEmpty(){
        self.view.bringSubviewToFront(emptyView)
        emptyView.isHidden = false
        collectionView.isHidden = true
    }
    
    
    func hideEmpty(){
        self.view.bringSubviewToFront(collectionView)
        emptyView.isHidden = true
        collectionView.isHidden = false
    }
    
    
    
    func getIDsOfFilter(key :String) -> String{
        var ids = ""
        filterObjects.forEach { (filterObject) in
            if filterObject.key == key{
                ids = filterObject.getIDsArrayJson
                return
            }
        }
        
        return ids
    }
    
    
        
    }








    extension FilterResultVC : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return products.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            var cell : OfferCVC? = nil
            
            if isGridViewMode{
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OfferLargeCVC", for: indexPath) as! OfferCVC
            }else{
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OfferLargeRowCVC", for: indexPath) as! OfferCVC
            }
                      
                       cell?.product = products[indexPath.row]
            
                       cell?.addToCartButton.tag = indexPath.row
                       cell?.addToFav.addTarget(self, action: #selector(addOrRemoveFavClicked), for: .touchUpInside)
                       
                       cell?.addToCartButton.tag = indexPath.row
                       cell?.addToCartButton.addTarget(self, action: #selector(clickedAddToCart), for: .touchUpInside)
            
            return cell!

        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            //return CGSize(width: 100, height: 1000)
    //
            if isGridViewMode {
                let padding: CGFloat =  16
                let collectionViewSize = collectionView.frame.size.width - padding
                collectionView.invalidateIntrinsicContentSize()
                return CGSize(width: collectionViewSize/2 - 5, height: 346)
            }else{
                let padding: CGFloat =  4
                let collectionViewSize = collectionView.frame.size.width - padding
                collectionView.invalidateIntrinsicContentSize()
                return CGSize(width: collectionView.frame.size.width - 5, height: 174)
            }
        }

        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
              let vc = self.storyboard!.instantiateViewController(withIdentifier: "OfferDetailsVC") as! OfferDetailsVC2
            vc.selectedProduct = products[indexPath.row]
            self.present(vc, animated: false, pushing: true )
             
        }
        
        
        
        
        
        
        
        
        
        @objc func clickedAddToCart(_ sender :UIButton)  {
            let product = products[sender.tag]
               self.addToCart(product: product)
        }
           
           
        @objc func addOrRemoveFavClicked(_ sender :UIButton){
            let product = products[sender.tag]

            if !MatajerUtility.isLogin() {
                self.collectionView.reloadData()

                                self.signIn()
                                return
                            }
            
            
               if product.isFavorite {
                   startReqestRemoveFavorate(product:product)
                   
               }else{
                   startReqestAddFavorate(product:product)
               }
           }
           
           
           

               private func startReqestRemoveFavorate(product :Product){
           //        {id}/favorite
                   API.REMOVE_FAVORITES.startRequest(showIndicator: false,nestedParams: product.id.description + "/favorite"  ) { (Api, statusResult) in
                       if statusResult.isSuccess {
                            
                           product.isFavorite = false
                           
                           self.collectionView.reloadData()
                       }else{
                           self.showOkAlert(title: "", message: statusResult.errorMessege)
                           self.collectionView.reloadData()

                       }
                   }
               }
           
           
               private func startReqestAddFavorate(product :Product){
                   var params = [String:String]()
                   params["product_id"] = product.id.description
                   API.ADD_FAVORITES.startRequest(showIndicator: false,params: params ) { (Api, statusResult) in
                       if statusResult.isSuccess {
                            
                           product.isFavorite = true
                           
                         
                           self.collectionView.reloadData()
                       }else{
                           self.showOkAlert(title: "", message: statusResult.errorMessege)
                           self.collectionView.reloadData()
                       }
                   }
               }
           
        
        
        
    }




extension FilterResultVC : SortedDialogVCDelegate {
    func dialogDissmised() {
        startReqest(forPage: pageNumber)
    }
    
    
}
