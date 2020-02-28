//
//  MoreProductVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 10/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
enum PageProduct {
    case fromTradeMark,fromCategory,fromSubCategory
}



class MoreProductPageVC: UIViewController {

    @IBOutlet weak var orderView :UIView!
    @IBOutlet weak var filterView :UIView!
    
    @IBOutlet weak var backButtonTitleButton :UIButton!

    @IBOutlet weak var collectionView :UICollectionView!
    @IBOutlet weak var modeView :UIView!
    @IBOutlet weak var styleImage :UIImageView!

    var isGridViewMode = true
    
    
    var isFirstTime = true
    
 
    var products :[Product] = []
    
    
    var tradeMark :TradeMark?
    var category :Category?
    var subCategroy :Category?
    
    
    
     var refreshControl :UIRefreshControl = UIRefreshControl()

     //loadMore
     var isLoadMore = false
     var pageNumber = 2
    
    
    
    var pageProduct :PageProduct {
         get{
            
            if tradeMark != nil {
                return .fromTradeMark
            }
            
            if category != nil {
                return .fromCategory
            }
            
            
            if subCategroy != nil {
                return .fromSubCategory
            }
            
            return .fromSubCategory
         }
     }
     
    
    
    var objectId :Int {
        get{
            if let id = tradeMark?.id {
                return id
            }
            
            if let id = category?.id {
                return id
            }
            
            if let id = subCategroy?.id {
                return id
            }
            
            
            return -1
        }
    }
    
    var titleValue :String{
        get{
            if let value = tradeMark?.name {
                return value
            }
                       
            if let value = category?.name {
                return value
            }
            
            if let value = subCategroy?.name {
                return value
            }
            
            return ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        styleImage.image = isGridViewMode ?  #imageLiteral(resourceName: "ic_home_tab_menu") : #imageLiteral(resourceName: "ic_home_tab_menu_grid")

        backButtonTitleButton.setTitle(titleValue, for: .normal)
        
        
        orderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openOrderDialog) ))
         filterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openFilterVC) ))
         
        
        
        registerCollectioView()
        initData()
        initGestureRecognizerTap()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        startRequset()
    }
    
      
    
    
    
      @objc func openOrderDialog(){
           let storyboardDialog = UIStoryboard(name: "Dialogs", bundle: nil)
           let sortedDialogVC :SortedDialogVC = storyboardDialog.instanceVC()
           sortedDialogVC.delegate = self

           self.present(sortedDialogVC, animated: true, completion: nil)
       }
         
       
       
       @objc func openFilterVC(){
           let storyboardDialog = UIStoryboard(name: "Main2", bundle: nil)
           let sortedDialogVC :FilterByVC = storyboardDialog.instanceVC()
           
//
//          let nav = UINavigationController(rootViewController: sortedDialogVC)
//           nav.modalPresentationStyle = .fullScreen
//           nav.setNavigationBarHidden(true, animated: false)
        self.present(sortedDialogVC, animated: false,pushing: true, completion: nil)
       }
      
    
    
    
    
    func registerCollectioView(){
        collectionView.register(UINib(nibName: "OfferLargeCVC", bundle: .main), forCellWithReuseIdentifier: "OfferLargeCVC")
         collectionView.register(UINib(nibName: "OfferLargeRowCVC", bundle: .main), forCellWithReuseIdentifier: "OfferLargeRowCVC")
        
         refreshControl.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
         collectionView.refreshControl = refreshControl
         
         
    }
    

    @objc func refreshData(){
        pageNumber = 2
        isLoadMore = false

        refreshControl.beginRefreshing()
        startReqest(forPage: 1)
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

    func startRequset(){
        if isFirstTime {
            isFirstTime = !isFirstTime
            startReqest(forPage: 1)
        }
    }
    
    private func startReqest(forPage pageNumber:Int){
        let params = [String:String]() //s["page":pageNumber.description] //[String:String]() //
        
        
        if pageProduct == .fromTradeMark {
            API.PRODUCTS_BY_TRADE_MARK.startRequest(showIndicator: true,nestedParams: objectId.description ,params: params,completion: response)
        }
        
        if pageProduct == .fromCategory {
            API.PRODUCTS_BY_CATEGROY.startRequest(showIndicator: true,nestedParams: objectId.description ,params: params,completion: response)
        }
        
        
        if pageProduct == .fromSubCategory {
                  API.PRODUCTS_BY_SUB_CATEGROY.startRequest(showIndicator: true,nestedParams: objectId.description ,params: params,completion: response)
        }
    
    }

    func response(api :API,statusResult :StatusResult){
        refreshControl.endRefreshing()
        self.pageNumber = 2

        if statusResult.isSuccess {
            pageNumber = 2
            let value = statusResult.data as! [[String:Any]]
            if value.isEmpty {
                return
            }
            
            let productData = try! JSONSerialization.data(withJSONObject:value, options: .prettyPrinted)
            
            self.products = try! JSONDecoder().decode([Product].self, from: productData)
                        
            
            self.collectionView.reloadData()
        }else{
            print(statusResult.errorMessege)
        }
    }
    
}


extension MoreProductPageVC : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
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






//for load more
extension MoreProductPageVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY + 180)  > contentHeight - scrollView.frame.size.height {
            loadMoreDataFromServer()
        }
    }
    
    
    func loadMoreDataFromServer(){
        if !isLoadMore {
            isLoadMore.toggle()
             let params = ["page":pageNumber.description]
                
                if pageProduct == .fromTradeMark {
                      API.PRODUCTS_BY_TRADE_MARK.startRequest(showIndicator: false,nestedParams: objectId.description ,params: params,completion: responseLoadMore)
                  }
                  
                  if pageProduct == .fromCategory {
                      API.PRODUCTS_BY_CATEGROY.startRequest(showIndicator: false,nestedParams: objectId.description ,params: params,completion: responseLoadMore)
                  }
                  
                  
                  if pageProduct == .fromSubCategory {
                            API.PRODUCTS_BY_SUB_CATEGROY.startRequest(showIndicator: false,nestedParams: objectId.description ,params: params,completion: responseLoadMore)
                  }
            
            
        }
    }
    
    
    func responseLoadMore(api :API,statusResult :StatusResult){
        if statusResult.isSuccess {
            pageNumber += 1
            isLoadMore.toggle()
            
            let value = statusResult.data as! [[String:Any]]
            
            
            let productData = try! JSONSerialization.data(withJSONObject:value, options: .prettyPrinted)
            
            let products = try! JSONDecoder().decode([Product].self, from: productData)
            
            if !products.isEmpty {
                self.products.append(contentsOf: products)
            }else{
                isLoadMore = true
            }
            self.collectionView.reloadData()
        }else{
            print(statusResult.errorMessege)
        }
    }
    
    
}







extension MoreProductPageVC : SortedDialogVCDelegate {
    func dialogDissmised() {
        startReqest(forPage: 1)
    }
    
    
}
