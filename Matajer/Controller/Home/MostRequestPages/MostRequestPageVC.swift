//
//  MostRequestVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 10/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
enum PageOfTabs {
    case mostRequset,offers,recentlyArrived
}


class MostRequestPageVC: UIViewController {
    
    @IBOutlet weak var orderView :UIView!
    @IBOutlet weak var filterView :UIView!
    @IBOutlet weak var collectionView :UICollectionView!
    @IBOutlet weak var modeView :UIView!
    @IBOutlet weak var styleImage :UIImageView!
    
    var isGridViewMode = true
    var pageOfTaps :PageOfTabs = .mostRequset
    
    
    var isFirstTime = true
    
    
    var isSorted = false
    
    var products :[Product] = []
    
    
    var refreshControl :UIRefreshControl = UIRefreshControl()

    //loadMore
    var isLoadMore = false
    var pageNumber = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        styleImage.image = isGridViewMode ?  #imageLiteral(resourceName: "ic_home_tab_menu") : #imageLiteral(resourceName: "ic_home_tab_menu_grid")
        
        
        orderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openOrderDialog) ))
        filterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openFilterVC) ))
        
        
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
        collectionView.refreshControl = refreshControl
        
        
        
        registerCollectioView()
        initData()
        initGestureRecognizerTap()
        
    }
    
    
    @objc func refreshData(){
        pageNumber = 2
        isLoadMore = false

        refreshControl.beginRefreshing()
        startReqest(forPage: 1)
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
      
//        let nav = UINavigationController(rootViewController: sortedDialogVC)
//        nav.modalPresentationStyle = .fullScreen
//        nav.setNavigationBarHidden(true, animated: false)
                
        self.present(sortedDialogVC, animated: false,pushing: true, completion: nil)
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
        let params = ["page":"1"] //[String:String]() //
        
        //        let nestedPrams = ""
        //        if !isSorted {
        //            nestedPrams = ""
        //        }
        switch pageOfTaps{
        case .mostRequset:
            API.TAB_MOST_ORDER.startRequest(showIndicator: true,params: params,completion: response)
        case .offers:
            API.TAB_OFFERS.startRequest(showIndicator: true,params: params,completion: response)
        case .recentlyArrived:
            API.TAB_RECENTLY_ARRIVED.startRequest(showIndicator: true,params: params,completion: response)
            
        }
        
        
    }
    
    func response(api :API,statusResult :StatusResult){
        refreshControl.endRefreshing()
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


extension MostRequestPageVC : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : OfferCVC? = nil
        
        if isGridViewMode{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OfferLargeCVC", for: indexPath) as! OfferCVC
            
            cell!.product = products[indexPath.row]
            
        }else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OfferLargeRowCVC", for: indexPath) as! OfferCVC
            
        }
        
        cell!.product = products[indexPath.row]
        
        
        cell!.addToCartButton.tag = indexPath.row
        cell!.addToCartButton.addTarget(self, action: #selector(clickedAddToCart), for: .touchUpInside)
        
        cell!.addToFav.tag = indexPath.row
        cell!.addToFav.addTarget(self, action: #selector(clickedAddToFav), for:.touchUpInside)
        
        
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
    
    
    
    @objc func clickedAddToCart(_ sender:UIButton)  {
        var product = products[sender.tag]
        self.addToCart(product: product)
    }
    
    
    @objc func clickedAddToFav(_ sender:UIButton)  {
        var product = products[sender.tag]
        
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
        API.REMOVE_FAVORITES.startRequest(showIndicator: false,nestedParams: product.id.description + "/favorite"  ) { (Api, statusResult) in
            if statusResult.isSuccess {
                
                product.isFavorite = false
                
                self.products.forEach { (suggestedProduct) in
                    if suggestedProduct.id == product.id {
                        suggestedProduct.isFavorite = product.isFavorite
                        return
                    }
                }
                
                
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
                
                self.products.forEach { (suggestedProduct) in
                    if suggestedProduct.id == product.id {
                        suggestedProduct.isFavorite = product.isFavorite
                        return
                    }
                }
                self.collectionView.reloadData()
            }else{
                self.showOkAlert(title: "", message: statusResult.errorMessege)
                self.collectionView.reloadData()
            }
        }
    }
    
    
    
}






extension MostRequestPageVC : SortedDialogVCDelegate {
    func dialogDissmised() {
        startReqest(forPage: pageNumber)
    }
    
    
}








//for load more
extension MostRequestPageVC {
    
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
            switch pageOfTaps{
            case .mostRequset:
                API.TAB_MOST_ORDER.startRequest(showIndicator: false,params: params,completion: responseLoadMore)
            case .offers:
                API.TAB_OFFERS.startRequest(showIndicator: false,params: params,completion: responseLoadMore)
            case .recentlyArrived:
                API.TAB_RECENTLY_ARRIVED.startRequest(showIndicator: false,params: params,completion: responseLoadMore)
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
