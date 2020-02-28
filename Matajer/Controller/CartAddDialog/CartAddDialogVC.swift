//
//  CartAddDialogVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 16/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import SDWebImage
class CartAddDialogVC: UIViewController {
    @IBOutlet weak var activityIndicatorView :UIActivityIndicatorView!
    
    @IBOutlet weak var productCollectionView :UICollectionView!
    
    //title
     @IBOutlet weak var titleLbl: UILabel!
     @IBOutlet weak var priceLbl: UILabel!
     @IBOutlet weak var imageView: UIImageView!
    
    
    var selectedProduct :Product!
    
    

 
    override func viewDidAppear(_ animated: Bool) {
        registerCell()
        startRequestShowDetails()
    }
    
    
    
    func initData(){
        self.titleLbl.text = selectedProduct.name
        self.priceLbl.text = selectedProduct.priceAfterDiscountValue.isEmpty ? selectedProduct.priceValue : selectedProduct.priceAfterDiscountValue
      //  self.imageView.sd_setImage(with: URL(string: selectedProduct.image), completed: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
       func startRequestShowDetails(){
        activityIndicatorView.startAnimating()
           API.PRODUCT_DETAILS.startRequest( showIndicator: false, nestedParams: selectedProduct.id.description ) { (Api, statusResult) in
            self.activityIndicatorView.stopAnimating()

                  if statusResult.isSuccess {
                            let value = statusResult.data as! [String:Any]
                            
                   let productData = try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                   self.selectedProduct = try! JSONDecoder().decode(Product.self, from: productData)
                   
//                    if !self.selectedProduct.colors?.isEmpty {
//                        self.selectedProduct.colors?[0].isSelected = true
//                    }
//
//                    if !self.selectedProduct.specifications?.isEmpty {
//                   self.selectedProduct.specifications?[0].isSelected = true
//                    }
                   self.initDataForCollections()
                   }else{
                   self.showOkAlert(title: "", message: statusResult.errorMessege)
               }
        }
       }
    
    func registerCell(){
         productCollectionView.register(UINib(nibName: "OfferCVC", bundle: .main), forCellWithReuseIdentifier: "OfferCVC")
 
     }
    
    
    
    func initDataForCollections(){
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
 
        
    }
    
    
    
    @IBAction func completeOrder(_ sender :UIButton){
        // dismissViewControllers()
//
     
        if true{
            
            dismiss(animated: true) {
                
                if AppDelegate.shared.viewController is MainTabBarVC {
                     (AppDelegate.shared.viewController as! MainTabBarVC).selectedIndex = 2
                }
            }
            
            return
        }
        
        
        
         var topViewController :UIViewController = self
            
             while let presentingViewController =  topViewController.presentingViewController {
                topViewController = presentingViewController
                    if topViewController is MainTabBarVC {
                        
                        break
                    }
            }
 
        topViewController.dismiss(animated: false) {
                        //let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            (topViewController as! MainTabBarVC).selectedIndex = 2
//
//                                let orderVc :MainOrderVC = mainStoryboard.instanceVC()
//                                DispatchQueue.main.asyncAfter(deadline: .now()) {
//
//                                    ((topViewController as! MainTabBarVC).viewControllers?.last as! ProfileNVC).pushViewController(orderVc, animated: true)
//
//                                }
        }
            
        self.dismiss(animated: true) {

        }
    }
    
 
    
//    func dismissViewControllers() {
//
//        guard let vc = self.presentingViewController else { return }
//
//        var topController = self.view.window!.rootViewController!
//
//        while let presentedViewController = topController.presentedViewController {
//            if topController == presentedViewController{
//                                  break
//                              }
//                topController = presentedViewController
//
//            if presentedViewController is MainTabBarVC{
//
//                    continue
//                }else{
//
//                    vc.dismiss(animated: true, completion: nil)
//                }
//        }
//
        
//        self.tabBarController?.selectedIndex = 4
//
//                       let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                       let orderVc :MainOrderVC = mainStoryboard.instanceVC()
//                           DispatchQueue.main.asyncAfter(deadline: .now()+1) {
//                               var profileNVC  = self.tabBarController!.viewControllers?.last as! ProfileNVC
//                                   profileNVC.pushViewController(orderVc, animated: true)
//
//                       }
       
//    }
    
    
}


extension CartAddDialogVC :UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedProduct.suggestions!.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OfferCVC", for: indexPath) as! OfferCVC
            cell.product = selectedProduct.suggestions![indexPath.row]
                
        cell.addToCartButton.tag = indexPath.row
        cell.addToCartButton.addTarget(self, action: #selector(clickedAddToCart), for: UIControl.Event.touchUpInside)
        return cell
    }
    


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

               return CGSize(width: 141, height: 346)

    }
 
    
     
     
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       weak var pvc = self.presentingViewController

        self.dismiss(animated: true) {
            let mainStory = UIStoryboard(name: "Main", bundle: .main)

            let vc = mainStory.instantiateViewController(withIdentifier: "OfferDetailsVC") as! OfferDetailsVC2
            vc.selectedProduct = self.selectedProduct.suggestions![indexPath.row]
                //.pvc!.present(vc, animated: true, completion: nil)
            pvc!.present(vc, animated: false, pushing: true )

        }
     }

    
    
  @objc func clickedAddToCart(_ sender :UIButton)  {
        weak var pvc = self.presentingViewController

        self.dismiss(animated: true) {
            pvc!.addToCart(product: self.selectedProduct.suggestions![sender.tag])
        }
    }
        
    
    
}
