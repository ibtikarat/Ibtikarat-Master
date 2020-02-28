//
//  SearchResult.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 20/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class SearchResultVC: UIViewController {
    @IBOutlet weak var backButtonTitleButton :UIButton!
    
    @IBOutlet weak var collectionView :UICollectionView!
    @IBOutlet weak var modeView :UIView!
    @IBOutlet weak var styleImage :UIImageView!
    
    @IBOutlet weak var emptyView :UIView!
    
    
    @IBOutlet weak var orderView :UIView!
    @IBOutlet weak var filterView :UIView!
    
    @IBOutlet weak var inputSearchTF: UITextField!
    
    var isGridViewMode = true
    
    
    var isFirstTime = true
    
    
    var products :[Product] = [] {
        didSet{
            //                numberOfProductLbl.text = products.count.description
        }
    }
    
    
    
    
    
    var searchValue :String = ""
    
    
    
    
    var refreshControl :UIRefreshControl = UIRefreshControl()
    
    //loadMore
    var isLoadMore = false
    var pageNumber = 2
    
    
override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        styleImage.image = isGridViewMode ?  #imageLiteral(resourceName: "ic_home_tab_menu") : #imageLiteral(resourceName: "ic_home_tab_menu_grid")
        
        backButtonTitleButton.setTitle("search_result".localized, for: .normal)
        
        inputSearchTF.text = searchValue
        
        inputSearchTF.delegate = self
        orderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openOrderDialog) ))
        filterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openFilterVC) ))
        
        
        self.inputSearchTF.rightView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchSelector)))
        
        
        
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
        
        
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
        collectionView.refreshControl = refreshControl

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
       // if isFirstTime {
         //   isFirstTime = !isFirstTime
            startReqest(forPage: 1)
        //}
    }
    
    private func startReqest(forPage pageNumber:Int){
        
        let params = ["q":searchValue,"page":"\(pageNumber)"]
        
        
        API.SEARCH.startRequest(showIndicator: true,params: params,completion: response)
        
    }
    
    func response(api :API,statusResult :StatusResult){
        refreshControl.endRefreshing()
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
    
    
    
    
}








extension SearchResultVC : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
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
        let mainStoryboard = UIStoryboard(name: "Main", bundle: .main)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "OfferDetailsVC") as! OfferDetailsVC2
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




extension SearchResultVC : SortedDialogVCDelegate {
    func dialogDissmised() {
        startReqest(forPage: pageNumber)
    }
    
    
}




extension SearchResultVC  {
    
    
    
    @objc func searchSelector(){
        textFieldShouldReturn(inputSearchTF)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchValue = textField.text!
        startRequset()
        textField.resignFirstResponder()
        return false
    }
}














//for load more
extension SearchResultVC {
    
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
            let params = ["q":searchValue,"page":pageNumber.description]
             API.SEARCH.startRequest(showIndicator: true,params: params,completion: responseLoadMore)
            
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



