//
//  OfferDetailsVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 04/10/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import ImageSlideshow
import Segmentio
import CHIPageControl
//import ParallaxHeader
import MXParallaxHeader
class OfferDetailsVC2: UIViewController {
    
    
    
    @IBOutlet weak var slideshow: ImageSlideshow! = ImageSlideshow()
   
    @IBOutlet weak var segmentioView: Segmentio!
    @IBOutlet weak var segmentioView2: Segmentio!
    
    @IBOutlet weak var blackScreen: UIView!
    
    @IBOutlet weak var productDetails: UIView!
    
    //nave
    @IBOutlet weak var navBar: UIImageView!
    @IBOutlet weak var menuItemStack: UIStackView!
    @IBOutlet weak var backImage: UIImageView!
    
    //@IBOutlet weak var sliderHeight: NSLayoutConstraint!
    @IBOutlet weak var transparentHeight: NSLayoutConstraint?
    
    @IBOutlet weak var quantityBottomConstraint: NSLayoutConstraint?

    
    //title
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var reatingLbl: UILabel!
    @IBOutlet weak var offerLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    
    
    @IBOutlet weak var trasperantHeight: NSLayoutConstraint!
    
    @IBOutlet weak var favorateButton: UICheckBox!

    //data
 
    @IBOutlet weak var tabelViewContent: UITableView!
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var sizeView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    @IBOutlet weak var quantityCollectionView: UICollectionView!
   
    @IBOutlet weak var addToCartButton: UIButton!
    
 
    
    var isDetails = true
    var isShowingQuantity = false
    
    
    var selectedProduct :Product!
    
    var selectedQuantity = 1 {
        didSet{
            quantityLbl.text = selectedQuantity.description
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabelViewContent.isHidden = true
        self.bottomView.isHidden = true
        
        
//        let contentView = UIView()
//        contentView.backgroundColor = UIColor.red
//        tabelViewContent.parallaxHeader.view = slideshow
//        tabelViewContent.parallaxHeader.height = 400
//        tabelViewContent.parallaxHeader.minimumHeight = 0
//        tabelViewContent.parallaxHeader.mode = .fill

        //initSlider()
        initSegmento()
         // Do any additional setup after loading the view.
        initData()
        isDark = false
//        tableView.estimatedRowHeight = 0;

        registerViewCells()
       
        
        //tabelViewContent.estimatedRowHeight = 0
        tabelViewContent.rowHeight  = UITableView.automaticDimension
        
        
        favorateButton.addTarget(self, action: #selector(clickedAddToFav), for: UIControl.Event.touchUpInside)
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OfferDetailsVC2.didTap))
        slideshow.addGestureRecognizer(gestureRecognizer)
        
        
      
        if AppDelegate.shared.language == "en" {
                addToCartButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
            }
    }
    
    
     @objc func clickedAddToFav()  {
           self.addOrRemoveFavClicked(product: selectedProduct)
       }
       
       
       func addOrRemoveFavClicked(product :Product){
        if !MatajerUtility.isLogin() {
                    self.initData()

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
                        
                       self.initData()
                    //let row = ((self.selectedProduct.specifications?.count ?? 0) + 1)
                    //self.tabelViewContent.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
                   }else{
                       self.showOkAlert(title: "", message: statusResult.errorMessege)
                       self.initData()
                    //let row = ((self.selectedProduct.specifications?.count ?? 0) + 1)
                    //self.tabelViewContent.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
                   }
               }
           }
       
       
           private func startReqestAddFavorate(product :Product){
               var params = [String:String]()
               params["product_id"] = product.id.description
               API.ADD_FAVORITES.startRequest(showIndicator: false,params: params ) { (Api, statusResult) in
                   if statusResult.isSuccess {
                        
                       product.isFavorite = true
                    
                    //let row = ((self.selectedProduct.specifications?.count ?? 0) + 1)
                    //self.tabelViewContent.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)

                       self.initData()
                   }else{
                       self.showOkAlert(title: "", message: statusResult.errorMessege)
                                             self.initData()
                    //let row = ((self.selectedProduct.specifications?.count ?? 0) + 1)
                    //self.tabelViewContent.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
                   }
               }
           }
       
    
    

    override func viewDidAppear(_ animated: Bool) {
                startRequestShowDetails()
    }
    
    func registerViewCells(){
        
        tabelViewContent.register(UINib(nibName: "RatingMainTVC", bundle: .main), forCellReuseIdentifier: "RatingMainTVC")
        
           tabelViewContent.register(UINib(nibName: "ClientCommentTVC", bundle: .main), forCellReuseIdentifier: "ClientCommentTVC")
        
        
         tabelViewContent.register(UINib(nibName: "OfferDetailsTVC", bundle: .main), forCellReuseIdentifier: "OfferDetailsTVC")
        
        tabelViewContent.register(UINib(nibName: "OfferCategoryTVC", bundle: .main), forCellReuseIdentifier: "OfferCategoryTVC")
        
        tabelViewContent.register(UINib(nibName: "SpecificationTVC", bundle: .main), forCellReuseIdentifier: "SpecificationTVC")
        
        
        colorCollectionView.register(UINib(nibName: "SizeColorCVC", bundle: .main), forCellWithReuseIdentifier: "SizeColorCVC")
        sizeCollectionView.register(UINib(nibName: "SizeColorCVC", bundle: .main), forCellWithReuseIdentifier: "SizeColorCVC")
        quantityCollectionView.register(UINib(nibName: "SizeColorCVC", bundle: .main), forCellWithReuseIdentifier: "SizeColorCVC")

        
    }
    
    func initDataForCollections(){
        tabelViewContent.dataSource = self
        tabelViewContent.delegate = self
        
        colorCollectionView.dataSource = self
        sizeCollectionView.dataSource = self
        
        colorCollectionView.delegate = self
        sizeCollectionView.delegate = self
        
        
        quantityCollectionView.dataSource = self
        quantityCollectionView.delegate = self
        
        
    }
    
    
    

    override func viewWillAppear(_ animated: Bool) {

        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        trasperantHeight.constant = view.frame.height - (148 + 101 + 20 + bottom)
        
    
        tabelViewContent.layoutTableHeaderView()
        
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
             let safeFrame = window.safeAreaLayoutGuide.layoutFrame
              let topPadding = safeFrame.minY
              let bottomPadding  = window.frame.maxY - safeFrame.maxY
          

            
            let bottomSize :CGFloat = 148 + 101
      
            loadViewIfNeeded()
        }
    }
    
    func initSlider(){

        
        
         slideshow.slideshowInterval = 5.0
        slideshow.pageIndicatorPosition = .init(horizontal: .left(padding: 24), vertical: .customBottom(padding: 8))
         slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
         
         let pageControl = LineWithDotPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor(named: "primaryColor")
         pageControl.pageIndicatorTintColor = UIColor.lightGray
         slideshow.pageIndicator = pageControl
            slideshow.contentScaleMode = .scaleAspectFit
         // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
         slideshow.activityIndicator = DefaultActivityIndicator()
         slideshow.delegate = self
      
         
     }
    
    
     func initSliderData(){
        initSlider()

        var networkSources  = [SDWebImageSource]()
        networkSources.append(SDWebImageSource(urlString: selectedProduct.image ,placeholder: UIImage())!)
        for image in selectedProduct.images! {
            networkSources.append(SDWebImageSource(urlString: image.img! ,placeholder: UIImage())!)
            }
          slideshow.setImageInputs(networkSources)
      }
      
     
    func initSegmento(){
          
            
            
            let segmentState = SegmentioStates(
                defaultState: SegmentioState(
                    backgroundColor: .clear,
                    titleFont: UIFont(name: "SSTArabic-Medium", size: 12)!,
                    titleTextColor: UIColor.black
                ),
                selectedState: SegmentioState(
                    backgroundColor: .clear,
                    titleFont: UIFont(name: "SSTArabic-Medium", size: 12)!,
                    titleTextColor: UIColor.CustomColor.primaryColor
                ),
                highlightedState: SegmentioState(
                    backgroundColor: .clear,
                    titleFont: UIFont(name: "SSTArabic-Medium", size: 12)!,
                    titleTextColor: UIColor.CustomColor.primaryColor
                )
            )
        
        
        
            
        let segmentioIndicatorOptions = SegmentioIndicatorOptions(type: .bottom, ratio: 1, height: 2, color: UIColor.CustomColor.primaryColor2)
            
        let horizontalSeparatorOptions  = SegmentioHorizontalSeparatorOptions(type: .none, height: 0, color: .clear)
        let verticalSeparatorOptions = SegmentioVerticalSeparatorOptions(ratio: 0, color: .clear)
            
            let options = SegmentioOptions(
                 backgroundColor: UIColor.white ,
                segmentPosition: SegmentioPosition.fixed(maxVisibleItems: 5),
                scrollEnabled: false,
                indicatorOptions: segmentioIndicatorOptions,
                horizontalSeparatorOptions: horizontalSeparatorOptions,
                verticalSeparatorOptions: verticalSeparatorOptions,
                labelTextAlignment: .center,
                segmentStates: segmentState
            )
            
            
            
            let item1 = SegmentioItem(
                title: "product details".localized, image: nil
            )
            
            let item2 = SegmentioItem(
                title: "product reviews".localized, image: nil
            )
           
            
            segmentioView.setup(
                content: [item1 ,item2],
                style: SegmentioStyle.onlyLabel,
                options: options
            )
            
            
            segmentioView.selectedSegmentioIndex = 0
            segmentioView.layer.borderColor = UIColor.white.cgColor
        
        
        
            segmentioView2.setup(
                     content: [item1 ,item2],
                     style: SegmentioStyle.onlyLabel,
                     options: options
                 )
        
        
            segmentioView2.selectedSegmentioIndex = 0
            segmentioView.layer.borderColor = UIColor.white.cgColor
               
        

        
            segmentioView.valueDidChange = { [weak self] _, segmentIndex in

                self!.isDetails = segmentIndex == 0
                self?.tabelViewContent.reloadData()
                self!.segmentioView2.selectedSegmentioIndex = segmentIndex

                
            }
        
        
        
        
            segmentioView2.valueDidChange = { [weak self] _, segmentIndex in
                self!.segmentioView.selectedSegmentioIndex = segmentIndex
                 
                
            }
        }
    
    
    
    var isDark = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
            menuItemStackChangeItem(toDark: isDark)
            if isDark{
                navBar.isHidden = false
                menuItemStack.axis = .horizontal
                
                favorateButton.changeUnCheckTintColor = UIColor.white
            }else{
                navBar.isHidden = true
                menuItemStack.axis = .vertical
                favorateButton.changeUnCheckTintColor = UIColor.black

            }
        }
    }

    
    
    func menuItemStackChangeItem(toDark isDark :Bool){
        menuItemStack.subviews.forEach { (view) in
            if view is UIImageView {
                          (view as! UIImageView).tintColor = isDark ? UIColor.white : UIColor.black
                }
        }
        
        backImage.tintColor =  isDark ? UIColor.white : UIColor.black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isDark ? .lightContent : .default
    }

    func toggleAppearance() {
       isDark.toggle()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    //this class for click a button behind a transparent UIView
//    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        for subview in subviews {
//            if subview.frame.contains(point) {
//                return true
//            }
//        }
//        return false
//    }
//
    
    
    
    
    
    func startRequestShowDetails(){
        API.PRODUCT_DETAILS.startRequest( showIndicator: true, nestedParams: selectedProduct.id.description ) { (Api, statusResult) in
            self.tabelViewContent.isHidden = false
            self.bottomView.isHidden = false
               if statusResult.isSuccess {
                         let value = statusResult.data as! [String:Any]
                         
                let productData = try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                self.selectedProduct = try! JSONDecoder().decode(Product.self, from: productData)
                if !self.selectedProduct.colors!.isEmpty {
                    self.selectedProduct.colors?[0].isSelected = true
                }else{
                    self.colorView.visibility = .gone
                    self.tabelViewContent.layoutTableHeaderView()
                }
                
                if !self.selectedProduct.options!.isEmpty{
                    self.selectedProduct.options![0].contents![0].isSelected = true
                }else{
                    self.sizeView.visibility = .gone
                    self.sizeView.isHidden = true
                    self.tabelViewContent.layoutTableHeaderView()
                }
                
                self.initDataForCollections()
                self.initData()
                self.initSliderData()
               }else{
                self.showOkAlert(title: "", message: statusResult.errorMessege)
            }
    }
    }
 
    

    func initData(){
        self.titleLbl.text = selectedProduct.name
        self.categoryLbl.text = selectedProduct.category?.name
        self.priceLbl.text = selectedProduct.priceAfterDiscountValue.isEmpty ? selectedProduct.priceValue : selectedProduct.priceAfterDiscountValue
        self.offerLbl.isHidden = !selectedProduct.isOffer
        self.favorateButton.isChecked = selectedProduct.isFavorite
        self.reatingLbl.text = "(\(selectedProduct.ratesCounts?.total ?? 0)) \(selectedProduct.grandRate ?? 0)"
        
        self.quantityLbl.text = selectedQuantity.description
    }
    
    
    
    @IBAction func addCart(_ sender :UIButton){
        
        self.addToCart(product: selectedProduct,quantity: selectedQuantity)
    }
    
    
    
    
    
    @IBAction func shareProduct(_ sender :UIButton){
        let shareText = "\(selectedProduct.name)  \n \(selectedProduct.reviewsDescription.htmlAttributedString!.string) \n \("smart sayfty".localized)"

        let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])

        if UIDevice.current.userInterfaceIdiom == .pad {
            vc.popoverPresentationController?.sourceView =  self.view
        }

             present(vc, animated: true, completion: nil)
        
        }
    
    
    
   
    @IBAction func qunatityTaped(_ sender :Any){
        if isShowingQuantity {
            hideQunatity()
        }else{
            showQuantity()
        }
        isShowingQuantity.toggle()
    }
    
    
    func showQuantity(){
        
        quantityBottomConstraint?.constant = 0
        UIView.animate(withDuration: 0.5) {
                  self.view.layoutIfNeeded()

        }
    }
    
    
   @IBAction func hideQunatity(){
        quantityBottomConstraint?.constant = -100
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    func initPageConrol(){
//            let pageControl =
//              pageControl.numberOfPages = sliders.count
//              pageControl.set(progress: 0, animated: true)
//              pageControl.tintColor = UIColor.lightGray
//              pageControl.currentPageTintColor = #colorLiteral(red: 0.9374084473, green: 0.2829045057, blue: 0, alpha: 1)
//              pageControl.padding = 10
//              pageControl.radius = 2
//              pageControl.elementHeight = 4
      }
    
    
    
    
}

//image slider
extension OfferDetailsVC2: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {

    }
}




extension OfferDetailsVC2 :UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        
        if scrollView == self.tabelViewContent {

        let parentViewMaxContentYOffset = scrollView.contentSize.height - scrollView.frame.height
        let alpha  :CGFloat = scrollView.contentOffset.y / parentViewMaxContentYOffset
        blackScreen.alpha = alpha
        
        
            
            
               if segmentioView.frame.origin.y < (scrollView.contentOffset.y + 74){
                    segmentioView2.isHidden = false

               }else{
                     segmentioView2.isHidden = true
               }
               
            
  
        
        if scrollView.contentOffset.y > productDetails.frame.origin.y  - 80{
                isDark = true
          }else{
                isDark = false
          }
        }
    }
    

    
    
}




extension OfferDetailsVC2 :UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if isDetails {
            return (selectedProduct.specifications?.count ?? 0) + 2
        }
        return selectedProduct.rates!.count + 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isDetails {
            
            //for details
            if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OfferDetailsTVC") as! OfferDetailsTVC
                cell.descriptionProduct = selectedProduct.reviewsDescription
                cell.specificationLbl.isHidden = (selectedProduct.specifications?.count ?? 0) == 0
                   return cell
                
                
                
                //for sugeestion product
            }else if indexPath.row == ((selectedProduct.specifications?.count ?? 0) + 1){
                   let cell: OfferCategoryTVC = tableView.dequeueReusableCell(withIdentifier: "OfferCategoryTVC", for: indexPath) as! OfferCategoryTVC
                    cell.moreButton.isHidden = true
                    
                    cell.inducatorImage.isHidden = true
                let category = Category(id: -1, image: "", name: "suggestion".localized)
                    category.products = selectedProduct.suggestions
                    
                    cell.isProductDetails = true
                    cell.category = category
                    cell.offerClicked = offerClicked

                    cell.addOrRemoveFavClicked = addOrRemoveFavClicked
                    cell.clickedAddToCart = clickedAddToCart
                
                    
                    
                return cell
            }else{
                //for offer specification
                let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificationTVC") as! SpecificationTVC
                cell.indexPath = indexPath
                cell.specification = selectedProduct.specifications![indexPath.row - 1]
                return cell

            }
            
            
        }else{
        
            if indexPath.row == 0 {
                  let cell = tableView.dequeueReusableCell(withIdentifier: "RatingMainTVC") as! RatingMainTVC
                cell.avgValue = Double(selectedProduct.grandRate ?? 0.0)
                cell.rateCount = selectedProduct.ratesCounts
                return cell
            }else if indexPath.row == (selectedProduct.rates!.count + 1){
                   let cell: OfferCategoryTVC = tableView.dequeueReusableCell(withIdentifier: "OfferCategoryTVC", for: indexPath) as! OfferCategoryTVC
                    cell.moreButton.isHidden = true
                    cell.inducatorImage.isHidden = true
                let category = Category(id: -1, image: "", name: "suggestion".localized)
                    category.products = selectedProduct.suggestions
                    
                    cell.isProductDetails = true
                    cell.category = category
                    cell.offerClicked = offerClicked

                    cell.addOrRemoveFavClicked = addOrRemoveFavClicked
                    cell.clickedAddToCart = clickedAddToCart
                
                return cell
            }else{
        
               let cell = tableView.dequeueReusableCell(withIdentifier: "ClientCommentTVC") as! ClientCommentTVC
                cell.rating = selectedProduct.rates![indexPath.row - 1]
            return cell
            }

        }
        
        

        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == ((selectedProduct.specifications?.count ?? 0) + 1){
            return 386
        }else{
            return UITableView.automaticDimension
        }
        
        return UITableView.automaticDimension
    }
    
    
    
    func offerClicked(product :Product)  {
           let vc = self.storyboard!.instantiateViewController(withIdentifier: "OfferDetailsVC") as! OfferDetailsVC2
           vc.selectedProduct = product
                    self.present(vc, animated: false, pushing: true )
       }
       
    
    
    func clickedAddToCart(product :Product)  {
            self.addToCart(product: product)
        }
        
        
        func addOrRemoveFavClicked(product :Product,index :Int){
            if !MatajerUtility.isLogin() {
                
                self.signIn()
                return
            }
            
            if product.isFavorite {
                startReqestRemoveFavorate(product:product)
                
            }else{
                startReqestAddFavorate(product:product)
            }
        }
        
        
        

        
    
    
    
    
    
}



extension OfferDetailsVC2 :UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == quantityCollectionView {
            return  (selectedProduct.quantity ?? 0) < 10 ? (selectedProduct.quantity ?? 0) : 10
        }
        
        if collectionView == colorCollectionView {
            return selectedProduct.colors!.count
        }else{
            if !(selectedProduct.options?.isEmpty ?? false) {
                return selectedProduct.options![0].contents!.count
            }else{
                return 0
            }
        }
       }
       
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeColorCVC", for: indexPath) as! SizeColorCVC
                if collectionView == colorCollectionView {
                    cell.color = selectedProduct.colors![indexPath.row]
                }else if collectionView == quantityCollectionView{
                    cell.quantity = (indexPath.row + 1).description
                    if selectedQuantity == (indexPath.row + 1){
                        cell.selected()
                    }else{
                        cell.notSelected()
                    }
                }else{
                    cell.optionContent = selectedProduct.options![0].contents![indexPath.row]
                }
                return  cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         if collectionView == colorCollectionView {
            deselectAll(colors: selectedProduct.colors!)
            selectedProduct.colors![indexPath.row].isSelected = !selectedProduct.colors![indexPath.row].isSelected

         }else  if collectionView == sizeCollectionView {
            deselectAll(contents: selectedProduct.options![0].contents!)

            selectedProduct.options![0].contents![indexPath.row].isSelected =
            !selectedProduct.options![0].contents![indexPath.row].isSelected
         }else if collectionView == quantityCollectionView{
            selectedQuantity = indexPath.row + 1
            
        }

        collectionView.reloadData()
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         var size :CGSize! = CGSize()
         if collectionView == colorCollectionView {
            size = (selectedProduct.colors![indexPath.row].content! as NSString).size(withAttributes: [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
         }else  if collectionView == quantityCollectionView {
            
               return CGSize(width: size.width + 84 , height: 40)

         }else if collectionView == sizeCollectionView{
            size = ((selectedProduct.options![0].contents![indexPath.row].content ?? "" ) as NSString).size(withAttributes: [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        }
         
         return CGSize(width: size.width + 84 , height: 40)
         
     }
    
    
        func deselectAll(colors :[Color]){
            for color in colors {
                color.isSelected = false
            }
        }
    
        func deselectAll(contents :[OptionContent]){
             contents.forEach{$0.isSelected = false}
         }
    
    
    

    @objc func didTap() {
      slideshow.presentFullScreenController(from: self)
        
    }
    
    
    
    
    
    
    
    
    
  
    
    
    
    
}
