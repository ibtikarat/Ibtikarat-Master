//
//  RateProductVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 18/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
import Cosmos


enum RateProductValidation{
    case valid
    case invalid(String)
}




class RateProductVC: UIViewController {

    
    
    @IBOutlet weak var collectionView :UICollectionView!
    
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var productDetailsLbl: UILabel!
    @IBOutlet weak var commissionPriceLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    
    @IBOutlet weak var commentTF :UITextField!
    @IBOutlet weak var rating :CosmosView!
    @IBOutlet weak var ratingLbl :UILabel!
    
    
    var selecteProduct:Product?
    
    
    
    var images :[UIImage] = []
    var isCalled = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
        setBackTitle(title: "rate_product".localized)

        initData()
    }
    
    
    var commistionPrice = "" {
          didSet{
              if commistionPrice.isEmpty {
                  priceLbl.text = commistionPrice
                  return
              }
              let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string:commistionPrice)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                priceLbl.attributedText = attributeString
              
          }
      }
      
    
    
    
    

 
    func initData(){
        
          
                    let pro = selecteProduct!
                   
                    if !pro.priceAfterDiscountValue.isEmpty {
                        commissionPriceLbl.text = pro.priceAfterDiscountValue
                        commistionPrice = pro.priceValue
                    }else{
                         commissionPriceLbl.text = pro.priceValue
                         commistionPrice = ""
                    }
                  
                    categoryLbl.text = pro.category?.name
                    productDetailsLbl.text = pro.name
 
                    productImg.sd_setImage(with: URL(string:pro.image)!, completed: nil)

           
        
        
        
        
        
        collectionView.dataSource = self
              collectionView.delegate = self

              collectionView.register(UINib(nibName: "RateImagesCVC", bundle: nil), forCellWithReuseIdentifier: "RateImagesCVC")
              
              
              
              rating.didTouchCosmos = {  rating in
                  self.ratingLbl.text = rating.description
              }

              
              self.edgesForExtendedLayout = UIRectEdge()
                 self.extendedLayoutIncludesOpaqueBars = false

              
        
        
    }
    
    func startRequestSendRate(productId id :Int){
        var params = [String:String]()
        params["rate_value"] = rating.rating.description
        params["comment"] = commentTF.text!
        
        var data = [String:Data]()
        images.enumerated().forEach { (offest,image) in
            let imageData = image.jpegData(compressionQuality: 0.3)
            data["images[\(offest)]"] = imageData
            
            
        }
        
        
        
        API.ADD_RATINGS.startRequestWithFile( showIndicator: true, nestedParams: "\(id)/rate"
        ,params: params, data: data) { (Api, statusResult) in
            if statusResult.isSuccess {
                                   self.showOkAlert(title: "", message: statusResult.message) {
                                       self.pop()
                                   }
                           }else{
                               self.showBunnerAlert(title: "", message: statusResult.errorMessege)
                           }
        }
    }
    
    
    
    
    @IBAction func getImagesFromGallary(){
        let vc = BSImagePickerViewController()
        vc.maxNumberOfSelections = 6
        
        vc.setNeedsStatusBarAppearanceUpdate()
        vc.cancelButton.tintColor = UIColor.white
        vc.albumButton.setTitleColor(UIColor.white, for: .normal)
        vc.editButtonItem.tintColor = UIColor.CustomColor.primaryColor
        vc.doneButton.isEnabled = true
        vc.albumButton.tintColor = UIColor.white

        vc.navigationBar.barTintColor = UIColor.CustomColor.grayDark
        vc.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.orange]
        vc.tabBarController?.tabBar.barTintColor = UIColor.brown
        vc.tabBarController?.tabBar.tintColor = UIColor.brown
 
        
        vc.modalPresentationStyle = .fullScreen
        
        bs_presentImagePickerController(vc, animated: true,
            select: { (asset: PHAsset) -> Void in
                vc.doneButton.isEnabled = true

                vc.doneButton.tintColor = UIColor.CustomColor.primaryColor

              // User selected an asset.
              // Do something with it, start upload perhaps?
            }, deselect: { (asset: PHAsset) -> Void in
              // User deselected an assets.
                vc.doneButton.isEnabled = true

                      vc.doneButton.tintColor = UIColor.CustomColor.primaryColor

              // Do something, cancel upload?
            }, cancel: { (assets: [PHAsset]) -> Void in
              // User cancelled. And this where the assets currently selected.
            }, finish: { (assets: [PHAsset]) -> Void in
              // User finished with these assets
                if self.isCalled {
                    return
                }
                
                self.isCalled = true
                self.images.removeAll()
                
                assets.enumerated().forEach { (offset ,phAssets) in
                    self.fetchImage(asset: phAssets) { (image) in
                        
                        self.images.append(image!)
                        if  self.images.count == assets.count {
                            self.collectionView.reloadData()
                            self.isCalled = false
                        }
                    }
                }
                
                
        }, completion: nil)
    }
    
    
    
    
 
    
    
    func fetchImage(asset: PHAsset, resizeMode: PHImageRequestOptionsResizeMode = .exact,  completion: @escaping (_ result: UIImage?) -> Void) {
        let manager = PHImageManager.default()

        let photoAsset = asset as! PHAsset
        var options: PHImageRequestOptions?
        switch resizeMode {
            case .exact:
                options = PHImageRequestOptions()
                options?.resizeMode = .exact
            case .none:
                options = nil
          default:
            break
        }
        
 
        manager.requestImage(for: photoAsset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options) { (image:UIImage?, _) in
             completion(image)
        }
    }
    
    
    
      @IBAction func sendMessage(_ sender :UIButton){
          
          switch validationInput() {
              case .invalid(let error):
                   self.showBunnerAlert(title: "", message: error)

              case .valid:
                startRequestSendRate(productId: selecteProduct!.id)
                  break
          }
      }
    
    
    
    
     func validationInput() -> RateProductValidation{
             
//         if commentTF.text!.isEmpty {
//                 return .invalid("you_must_add_comment".localized)
//        }
             
         return .valid
     }
    
    
    
    
    
    
}



extension RateProductVC :UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RateImagesCVC", for: indexPath) as! RateImagesCVC
        cell.imgView.image = images[indexPath.row]
        cell.imgView.contentMode = .scaleAspectFill
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 45, height: 45)
    }
    
}
