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
 
class OfferDetailsVC: UIViewController {
    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var segmentioView: Segmentio!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var blackScreen: UIView!
    
    @IBOutlet weak var productDetails: UIView!
    
    //nave
    @IBOutlet weak var navBar: UIImageView!
    @IBOutlet weak var menuItemStack: UIStackView!
    @IBOutlet weak var backImage: UIImageView!
    
    @IBOutlet weak var sliderHeight: NSLayoutConstraint!
    @IBOutlet weak var transparentHeight: NSLayoutConstraint!
    
    
    
    //title
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var reatingLbl: UILabel!
    @IBOutlet weak var offerLbl: UILabel!

    //data
    @IBOutlet weak var tabelViewContentHeight: NSLayoutConstraint!
    @IBOutlet weak var tabelViewContent: UITableView!
    
    
    
//    @IBOutlet weak var tabelViewContent: UITableView!

    
    
    var isDetails = true
    
    
    var selectedProduct :Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSlider()
        initSegmento()
        scrollView.delegate = self
        // Do any additional setup after loading the view.
       
        isDark = false
//        tableView.estimatedRowHeight = 0;

        registerViewCells()
        startRequestShowDetails()
       
        
        //tabelViewContent.estimatedRowHeight = 0
        tabelViewContent.rowHeight  = UITableView.automaticDimension
    }
    
    
    
    func registerViewCells(){
        
        tabelViewContent.register(UINib(nibName: "RatingMainTVC", bundle: .main), forCellReuseIdentifier: "RatingMainTVC")
        
           tabelViewContent.register(UINib(nibName: "ClientCommentTVC", bundle: .main), forCellReuseIdentifier: "ClientCommentTVC")
        
        
         tabelViewContent.register(UINib(nibName: "OfferDetailsTVC", bundle: .main), forCellReuseIdentifier: "OfferDetailsTVC")
        
        tabelViewContent.register(UINib(nibName: "OfferCategoryTVC", bundle: .main), forCellReuseIdentifier: "OfferCategoryTVC")
    }
    
    func initDataForCollections(){
        tabelViewContent.dataSource = self
        tabelViewContent.delegate = self
    }
    
    
    

    override func viewWillAppear(_ animated: Bool) {
        //title height -> 138 //button height -> 101
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
             let safeFrame = window.safeAreaLayoutGuide.layoutFrame
              let topPadding = safeFrame.minY
              let bottomPadding  = window.frame.maxY - safeFrame.maxY
          

            
            let bottomSize :CGFloat = 148 + 101
            sliderHeight.constant = self.view.frame.height - bottomSize - topPadding
            
            

            transparentHeight.constant =  -scrollView.frame.origin.y + (topPadding/2)
           // transparentHeight.constant = -scrollView.frame.origin.y //-(topPadding+20+bottomPadding)
        
            loadViewIfNeeded()
        }
    }
    
    func initSlider(){
//
//         let localSource = [BundleImageSource(imageString: "thumnil_img_slider2"), BundleImageSource(imageString: "thumnil_img_slider2"), BundleImageSource(imageString: "thumnil_img_slider2"), BundleImageSource(imageString: "thumnil_img_slider2")]
         
        
        
        
         slideshow.slideshowInterval = 5.0
        slideshow.pageIndicatorPosition = .init(horizontal: .left(padding: 24), vertical: .customBottom(padding: 8))
         slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
         
         let pageControl = UIPageControl()
         pageControl.currentPageIndicatorTintColor = UIColor.lightGray
         pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.9374084473, green: 0.2829045057, blue: 0, alpha: 1)
         slideshow.pageIndicator = pageControl
         
         // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
         slideshow.activityIndicator = DefaultActivityIndicator()
         slideshow.delegate = self
         
         // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
         //slideshow.setImageInputs(localSource)
         
         
     }
    
    
     func initSliderData(){
            var networkSources  = [SDWebImageSource]()
        for image in selectedProduct.images! {
            networkSources.append(SDWebImageSource(urlString: image.img ?? "http://www.google.com",placeholder: UIImage())!)
            }
          slideshow.setImageInputs(networkSources)
      }
      
     
    func initSegmento(){
            
            
            
            let segmentState = SegmentioStates(
                defaultState: SegmentioState(
                    backgroundColor: .clear,
                    titleFont: UIFont(name: "BahijTheSansArabic-SemiBold", size: 10)!,
                    titleTextColor: UIColor.black
                ),
                selectedState: SegmentioState(
                    backgroundColor: .clear,
                    titleFont: UIFont(name: "BahijTheSansArabic-Plain", size: 10)!,
                    titleTextColor: UIColor.CustomColor.primaryColor
                ),
                highlightedState: SegmentioState(
                    backgroundColor: .clear,
                    titleFont: UIFont(name: "BahijTheSansArabic-Plain", size: 10)!,
                    titleTextColor: UIColor.CustomColor.primaryColor
                )
            )
            
         let segmentioIndicatorOptions = SegmentioIndicatorOptions(type: .bottom, ratio: 1, height: 2, color: UIColor.CustomColor.primaryColor)
            
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
                title: "تفاصيل المنتج", image: nil
            )
            
            let item2 = SegmentioItem(
                title: "تقييمات المنتج", image: nil
            )
           
            
            segmentioView.setup(
                content: [item1 ,item2],
                style: SegmentioStyle.onlyLabel,
                options: options
            )
            
            
            
            segmentioView.valueDidChange = { [weak self] _, segmentIndex in

                self!.isDetails = segmentIndex == 0
                self?.tabelViewContent.reloadData()
                self!.fitTableViewHeight()
                
            }
            
            segmentioView.selectedSegmentioIndex = 0
            segmentioView.layer.borderColor = UIColor.white.cgColor
        }
    
    
    
    var isDark = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
            menuItemStackChangeItem(toDark: isDark)
            if isDark{
                navBar.isHidden = false
                menuItemStack.axis = .horizontal
            }else{
                navBar.isHidden = true
                menuItemStack.axis = .vertical
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
        API.PRODUCT_DETAILS.startRequest( showIndicator: true, nestedParams: "1") { (Api, statusResult) in
               if statusResult.isSuccess {
                         let value = statusResult.data as! [String:Any]
                         
                let productData = try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                self.selectedProduct = try! JSONDecoder().decode(Product.self, from: productData)
                self.initDataForCollections()
                self.fitTableViewHeight()

               }else{
                print(statusResult.errorMessege)
            }
    }
    }
 

    
    
    
    func fitTableViewHeight(){
        tabelViewContent.isScrollEnabled = false;

        tabelViewContent.reloadData()
         
        let size = tabelViewContent.contentSize

        self.tabelViewContentHeight.constant = tabelViewContent.contentSize.height
    }
}

//image slider
extension OfferDetailsVC: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {

    }
}




extension OfferDetailsVC :UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == self.scrollView {
        //parentViewMaxContentYOffset = scrollView.contentSize.height - scrollView.frame.height
        let parentViewMaxContentYOffset = scrollView.contentSize.height - scrollView.frame.height
        let alpha  :CGFloat = scrollView.contentOffset.y / parentViewMaxContentYOffset
        blackScreen.alpha = alpha
        
        
        
        if scrollView.contentOffset.y > productDetails.frame.origin.y  - 44{
                isDark = true
          }else{
                isDark = false
          }
        }
    }
    

    
    
}




extension OfferDetailsVC :UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if isDetails {
            return 1
            //return 2
        }
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isDetails {
            
            if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OfferDetailsTVC") as! OfferDetailsTVC
            
                   return cell
            }else{
                   let cell: OfferCategoryTVC = tableView.dequeueReusableCell(withIdentifier: "OfferCategoryTVC", for: indexPath) as! OfferCategoryTVC
                 
                    let category = Category(id: 0, image: "", name: "suggestion".localized)
                    category.products = selectedProduct.suggestions
                    cell.category = category
                
                return cell
            }
            
            
        }else{
        
            if indexPath.row == 0 {
                  let cell = tableView.dequeueReusableCell(withIdentifier: "RatingMainTVC") as! RatingMainTVC
         
                return cell
            }
        
               let cell = tableView.dequeueReusableCell(withIdentifier: "ClientCommentTVC") as! ClientCommentTVC
            return cell

        }
        
    }
    
    
}
