//
//  MainPageVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 09/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import Segmentio
import ImageSlideshow
import CHIPageControl
class MainPageVC: UIViewController {
    
    
    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var catCollectionView :UICollectionView!
    @IBOutlet weak var productCategoryTV :UITableView!
    @IBOutlet weak var  pageControl :CHIPageControlJaloro!
    

    
    
    var mainCategories :[Category] = []
    var mainCategoriesWithProduct :[Category] = []
    var suggested :[Product] = []
    var sliders :[Slider] = []


    var tableRefresher :UIRefreshControl = UIRefreshControl()
    
    
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.isHidden = true
        initSlider()
        registerViewCells()
        startRequestMain()
        //initDataForCollections()
    }
    
    
    
    func registerViewCells(){
        catCollectionView.register(UINib(nibName: "ProductCategoryCVC", bundle: .main), forCellWithReuseIdentifier: "ProductCategoryCVC")
        productCategoryTV.register(UINib(nibName: "OfferCategoryTVC", bundle: .main), forCellReuseIdentifier: "OfferCategoryTVC")
    }
    
    func initDataForCollections(){
        catCollectionView.dataSource = self
        catCollectionView.delegate = self
    
        productCategoryTV.dataSource = self
        productCategoryTV.delegate = self
        
        
        catCollectionView.reloadData()
        productCategoryTV.reloadData()
        
        
        tableRefresher.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
        productCategoryTV.refreshControl = tableRefresher
    }
    
    
    @objc func refreshData(){
        page = 1
        tableRefresher.beginRefreshing()
        startRequestMain()
    }
    
    
    
    func initSlider(){

  
        slideshow.slideshowInterval = 5.0
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        slideshow.pageIndicator = nil
    
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.delegate = self
        

     }
    
    func initSliderData(){
          var networkSources  = [SDWebImageSource]()
        
        if sliders.isEmpty {
            pageControl.visibility = .gone
            slideshow.visibility = .gone

            self.productCategoryTV.layoutTableHeaderView()
            return
        }
        
        
          for slide in sliders {
            networkSources.append(SDWebImageSource(urlString: slide.image ?? "http://www.google.com",placeholder: UIImage())!)
          }

        
        initPageConrol()
        slideshow.setImageInputs(networkSources)
    }
    
    
    
    func initPageConrol(){
        pageControl.isHidden = false

        
        if sliders.count == 1 {
            pageControl.visibility = .gone
            pageControl.isHidden = true
            pageControl.clipsToBounds = true
            self.productCategoryTV.layoutTableHeaderView()
            
        }
        
        pageControl.numberOfPages = sliders.count
            pageControl.set(progress: 0, animated: true)
            pageControl.tintColor = UIColor.lightGray
            pageControl.currentPageTintColor = #colorLiteral(red: 0.9374084473, green: 0.2829045057, blue: 0, alpha: 1)
            pageControl.padding = 10
            pageControl.radius = 2
            pageControl.elementHeight = 4
    }
    
    func startRequestMain(){
        let params = ["page":page]
        API.HOME.startRequest(showIndicator: true) { (Api, statusResult) in
            self.tableRefresher.endRefreshing()

            if statusResult.isSuccess {
                let value = statusResult.data as! [String:[Any]]
                
                let mainCategoryData = try! JSONSerialization.data(withJSONObject: value["main_categories"]!, options: .prettyPrinted)
                self.mainCategories = try! JSONDecoder().decode([Category].self, from: mainCategoryData)
                
                
                
                let categoriesData = try! JSONSerialization.data(withJSONObject: value["main_categories_with_products"]!, options: .prettyPrinted)
                self.mainCategoriesWithProduct = try! JSONDecoder().decode([Category].self, from: categoriesData)
                          
                
                
                let suggestedData = try! JSONSerialization.data(withJSONObject: value["suggested_products"]!, options: .prettyPrinted)
                self.suggested = try! JSONDecoder().decode([Product].self, from: suggestedData)
                          
                
                
                let sliderData = try! JSONSerialization.data(withJSONObject: value["slider"]!, options: .prettyPrinted)
                self.sliders = try! JSONDecoder().decode([Slider].self, from: sliderData)
                              
                let suggestion = Category(id: -1, image: "nil", name: "suggestion".localized)
                suggestion.products = self.suggested
                self.mainCategoriesWithProduct.insert(suggestion, at: 0)
                self.initDataForCollections()
                self.initSliderData()
            }else{
                self.showOkAlert(title: "", message: statusResult.errorMessege)
            }
        }
    }
    
    
}



//image slider
extension MainPageVC: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        pageControl.set(progress: page, animated: true)
        print("current page:", page)
    }
}



extension MainPageVC: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell :ProductCategoryCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCategoryCVC", for: indexPath) as! ProductCategoryCVC
        cell.category = mainCategories[indexPath.row]
        return cell
        
    }

    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let vc = self.storyboard!.instantiateViewController(withIdentifier: "MarkaPageVC") as! MoreProductPageVC
         
             vc.category = mainCategories[indexPath.row]
             self.present(vc, animated: false,pushing: true, completion: nil)

     }
     
    
    
}



extension MainPageVC: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainCategoriesWithProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OfferCategoryTVC = tableView.dequeueReusableCell(withIdentifier: "OfferCategoryTVC", for: indexPath) as! OfferCategoryTVC
        cell.category = mainCategoriesWithProduct[indexPath.row]
        cell.offerClicked = offerClicked
        cell.moreClicked = moreClicked
        cell.clickedAddToCart = clickedAddToCart
        cell.addOrRemoveFavClicked = addOrRemoveFavClicked
        return cell 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
            return 380
        
    }
    
    
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 //        let vc = self.storyboard!.instantiateViewController(withIdentifier: "OfferDetailsVC")
 //        self.present(vc, animated: true, completion: nil)
     }
    
    
    func offerClicked(product :Product)  {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "OfferDetailsVC") as! OfferDetailsVC2
        vc.selectedProduct = product
        //self.present(vc, animated: true, completion: nil)
        self.present(vc, animated: false, pushing: true )
    }
    
    
    func moreClicked(category :Category){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "MarkaPageVC") as! MoreProductPageVC
           
            vc.category = category
        self.present(vc, animated: false,pushing: true, completion: nil)
    }
    
    
    func clickedAddToCart(product :Product)  {
        self.addToCart(product: product)
    }
    
    
    func addOrRemoveFavClicked(product :Product,index :Int){
        if !MatajerUtility.isLogin() {
            self.productCategoryTV.reloadData()

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
                    
                    self.suggested.forEach { (suggestedProduct) in
                                           if suggestedProduct.id == product.id {
                                               suggestedProduct.isFavorite = product.isFavorite
                                               return
                                           }
                                       }
                    
                    
                    self.productCategoryTV.reloadData()
                }else{
                    self.showOkAlert(title: "", message: statusResult.errorMessege)
                    self.productCategoryTV.reloadData()

                }
            }
        }
    
    
        private func startReqestAddFavorate(product :Product){
            var params = [String:String]()
            params["product_id"] = product.id.description
            API.ADD_FAVORITES.startRequest(showIndicator: false,params: params ) { (Api, statusResult) in
                if statusResult.isSuccess {
                     
                    product.isFavorite = true
                    
                    self.suggested.forEach { (suggestedProduct) in
                        if suggestedProduct.id == product.id {
                            suggestedProduct.isFavorite = product.isFavorite
                            return
                        }
                    }
                    self.productCategoryTV.reloadData()
                }else{
                    self.showOkAlert(title: "", message: statusResult.errorMessege)
                    self.productCategoryTV.reloadData()
                }
            }
        }
    
}








