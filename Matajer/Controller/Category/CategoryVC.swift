//
//  CategoryVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 25/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class ExpandData {
    var isOpen : Bool = false
    var title :String = "title of brand"
    var product :[String] = Array.init(repeating: "product", count: 1)
}

class CategoryVC: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak  var categoryTV :UITableView!
    @IBOutlet weak  var expandedCategoryTV :UITableView!
    @IBOutlet weak  var brandCollectionView :UICollectionView!
    
    @IBOutlet weak var brandCollectionViewHeightConstratint: NSLayoutConstraint!
    var categories = [Category]()
    var expadedDataArray = [ExpandData]()
    var selectedCategory :Category = Category()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tempData()
        
        registerViewCells()
        initDataForCollections()
        startReqestCategory()
        // Do any additional setup after loading the view.
        
        
    }
    
    
    
    func registerViewCells(){
        categoryTV.register(UINib(nibName: "CategoryTVC", bundle: .main), forCellReuseIdentifier: "CategoryTVC")
        
        
        expandedCategoryTV.register(UINib(nibName: "CategoryPageOfferCategoryTVC", bundle: .main), forCellReuseIdentifier: "CategoryPageOfferCategoryTVC")
        expandedCategoryTV.register(UINib(nibName: "CategorySectionTVC", bundle: .main), forCellReuseIdentifier: "CategorySectionTVC")
        
        
        brandCollectionView.register(UINib(nibName: "MarkaCVC", bundle: .main), forCellWithReuseIdentifier: "MarkaCVC")
    }
    
    func initDataForCollections(){
        categoryTV.dataSource = self
        categoryTV.delegate = self
        categoryTV.allowsSelection = true
        
        expandedCategoryTV.dataSource = self
        expandedCategoryTV.delegate = self
        expandedCategoryTV.rowHeight = UITableView.automaticDimension
        
        
        
        brandCollectionView.dataSource = self
        brandCollectionView.delegate = self
        brandCollectionView.collectionViewLayout.invalidateLayout()
        
        
        
    }
    
    
    func tempData(){
        for _ in 0...20{
            categories.append(Category())
        }
        
        categories[0].isSelected = true
        
        
        for _ in 0...10{
            expadedDataArray.append(ExpandData())
        }
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    private func startReqestCategory(){
        API.MAIN_CATEGORY.startRequest(showIndicator: true) { (Api, statusResult) in
            if statusResult.isSuccess {
                let value = statusResult.data as! [Any]
                
                let categoriesData = try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                
                self.categories = try! JSONDecoder().decode([Category].self, from: categoriesData)
                
                if !self.categories.isEmpty {
                    self.categories[0].isSelected = true
                    self.selectedCategory = self.categories[0]
                    self.expandedCategoryTV.reloadData()
                    // self.startReqestCategoryDetails(byId: self.categories[0].id!)
                }
                DispatchQueue.main.async {
                        self.brandCollectionView
                            .reloadData()
                               self.view.layoutIfNeeded()
                               self.updateHeight()

                           }
 
                self.categoryTV.reloadData()
                
            }else{
                print(statusResult.errorMessege)
            }
        }
    }
    
    
    
    
    private func startReqestCategoryDetails(byId id:Int){
        API.CATEGORY_DETAILS.startRequest(showIndicator: true, nestedParams: id.description) { (Api, statusResult) in
            if statusResult.isSuccess {
                let value = statusResult.data as! [String :Any]
                
                let categoryData = try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                
                self.selectedCategory = try! JSONDecoder().decode(Category.self, from: categoryData)
                
                self.expandedCategoryTV.reloadData()
                
            }else{
                print(statusResult.errorMessege)
            }
        }
    }
    
    
    
    private func updateHeight(){
        var count = 0
        for cat in categories {
            if cat.isSelected {
                count = cat.tradeMarks!.count
            }
        }
     
        let height :CGFloat =  brandCollectionView.contentSize.height
        brandCollectionViewHeightConstratint.constant = height
        let headerHeight = expandedCategoryTV.tableHeaderView!
        headerHeight.frame.size.height = height
        expandedCategoryTV.tableHeaderView = headerHeight

        
        //        if count <= 4 {
//            brandCollectionViewHeightConstratint.co
//            let height :CGFloat =  159
//            brandCollectionViewHeightConstratint.constant = height
//            let headerHeight = expandedCategoryTV.tableHeaderView!
//            headerHeight.frame.size.height = height
//            expandedCategoryTV.tableHeaderView = headerHeight
//        }else{
//            let height :CGFloat =  263
//            brandCollectionViewHeightConstratint.constant = height
//            let headerHeight = expandedCategoryTV.tableHeaderView!
//            headerHeight.frame.size.height = height
//            expandedCategoryTV.tableHeaderView = headerHeight
//
//        }
        self.view.layoutIfNeeded()
        expandedCategoryTV.layoutIfNeeded()
        //
    }
    
}


//category and expand category
extension CategoryVC  :UITableViewDataSource ,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == categoryTV{
            return 1
        }
        return selectedCategory.productCategories!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == categoryTV{
            self.brandCollectionView.reloadData()
            
            return categories.count
        }
        
        
        /************************************
         *************************************
         *************************************
         *************************************/
        
        
        if tableView == expandedCategoryTV{
            if selectedCategory.productCategories![section].isOpen {
                return 2
            }else{
                return 1
            }
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == categoryTV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTVC",for: indexPath) as! CategoryTVC
            
            cell.category = categories[indexPath.row]
            return cell
        }
        
        /************************************
         *************************************
         *************************************
         *************************************/
        
        
        
        
        if tableView == expandedCategoryTV{
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CategorySectionTVC", for: indexPath) as! CategorySectionTVC
                
                cell.isExpand = selectedCategory.productCategories![indexPath.section].isOpen
                cell.titelLbl.text = selectedCategory.productCategories![indexPath.section].name
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryPageOfferCategoryTVC", for: indexPath) as! CategoryPageOfferCategoryTVC
                cell.width = tableView.contentSize.width
                //cell.setupCell()
                cell.category = selectedCategory.productCategories![indexPath.section]
                cell.offerClicked = offerClicked
                cell.clickedAddToCart = clickedAddToCart
                cell.clickedAddToFav = addOrRemoveFavClicked
                cell.clickedShowMoreProduct = clickedShowMoreProduct
                return cell
            }
            
            return UITableViewCell()
        }
        
        
        
        
        return UITableViewCell()
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == categoryTV{
            
            removeAllSelection()
            categories[indexPath.row].isSelected = true
            //self.startReqestCategoryDetails(byId: self.categories[indexPath.row].id!)
            selectedCategory = categories[indexPath.row]
            self.expandedCategoryTV.reloadData()
            
            DispatchQueue.main.async {
              tableView.reloadData()
                self.view.layoutIfNeeded()
                self.updateHeight()

            }

           
            
        }
        
        /************************************
         *************************************
         *************************************
         *************************************/
        
        if tableView == expandedCategoryTV{
            if selectedCategory.productCategories![indexPath.section].isOpen == true {
                selectedCategory.productCategories![indexPath.section].isOpen = false
                tableView.reloadSections(IndexSet.init(integer :indexPath.section), with: .none)
            }else{
                closeAll()
                tableView.reloadData()
                selectedCategory.productCategories![indexPath.section].isOpen = true
                tableView.reloadSections(IndexSet.init(integer :indexPath.section), with: .none)
            }
            
        }
    }
    
    func removeAllSelection(){
        categories.forEach { $0.isSelected = false }
    }
    
    
    func closeAll(){
        selectedCategory.productCategories!.forEach { $0.isOpen = false }
        //expadedDataArray.forEach { $0.isOpen = false }
    }
    
    
    
    //
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        if tableView == categoryTV{
    //            return UITableView.automaticDimension
    //
    //        }
    //
    //        /************************************
    //         *************************************
    //         *************************************
    //         *************************************/
    //
    //        if tableView == expandedCategoryTV{
    //            if expadedDataArray[indexPath.section].isOpen == true {
    //                guard let cell = tableView.cellForRow(at: indexPath) as? CategoryPageOfferCategoryTVC else{
    //                    return UITableView.automaticDimension
    //                }
    //                cell.setupCell()
    //
    //                return cell.collectionViews!.collectionViewLayout.collectionViewContentSize.height
    //            }else{
    //                return UITableView.automaticDimension
    //            }
    //        }
    //
    //        return 0
    //    }
    
    
    
    
    
    func offerClicked(product :Product)  {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "OfferDetailsVC") as! OfferDetailsVC2
        vc.selectedProduct = product
        self.present(vc, animated: false, pushing: true )
    }
    
    
    
    func clickedAddToCart(product :Product)  {
        self.addToCart(product: product)
    }
    
    
    func clickedShowMoreProduct(category :Category){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "MarkaPageVC") as! MoreProductPageVC
            vc.subCategroy = category
            self.present(vc, animated: true, completion: nil)
    }
    
    
    
    func addOrRemoveFavClicked(product :Product){
        if !MatajerUtility.isLogin() {
            self.expandedCategoryTV.reloadData()
            
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
                
                
                
                self.expandedCategoryTV.reloadData()
            }else{
                self.showOkAlert(title: "", message: statusResult.errorMessege)
                self.expandedCategoryTV.reloadData()
                
            }
        }
    }
    
    
    private func startReqestAddFavorate(product :Product){
        var params = [String:String]()
        params["product_id"] = product.id.description
        API.ADD_FAVORITES.startRequest(showIndicator: false,params: params ) { (Api, statusResult) in
            if statusResult.isSuccess {
                
                product.isFavorite = true
                
                self.expandedCategoryTV.reloadData()
            }else{
                self.showOkAlert(title: "", message: statusResult.errorMessege)
                self.expandedCategoryTV.reloadData()
            }
        }
    }
    
    
}






extension CategoryVC  :UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        for cat in categories {
            if cat.isSelected {
                return cat.tradeMarks!.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MarkaCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "MarkaCVC", for: indexPath) as! MarkaCVC
        var markas :[TradeMark]?
        for cat in categories {
            if cat.isSelected {
                markas = cat.tradeMarks
                break
            }
        }
        
        cell.marka = selectedCategory.tradeMarks![indexPath.row]
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var count = 0
        for cat in categories {
            if cat.isSelected {
                count = cat.tradeMarks!.count
            }
        }
        
        let padding: CGFloat =  16
        let collectionViewSize = collectionView.frame.size.width - padding
        collectionView.invalidateIntrinsicContentSize()
        let collectionViewSizeHeight = collectionView.frame.size.height - padding - 10
        collectionView.invalidateIntrinsicContentSize()
        
//        if count <= 4 {
            return CGSize(width: collectionViewSize/3 - 8, height: 100 )
//        }else{
//            return CGSize(width: collectionViewSize/3 - 8, height: (collectionViewSizeHeight/2) )
//        }
    }
    
    
    
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "MarkaPageVC") as! MoreProductPageVC
        
        vc.tradeMark =  selectedCategory.tradeMarks![indexPath.row]
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
}


 
