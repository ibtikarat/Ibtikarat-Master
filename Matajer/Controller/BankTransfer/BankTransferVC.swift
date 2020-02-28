//
//  BankTransferVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 08/10/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos

protocol BankTransferDelegate{
    func dismissed()
}



enum BankTransferValidation{
    case valid
    case invalid(String)
}


class BankTransferVC: UIViewController {
    @IBOutlet weak var bankTV :UITableView!
    
    @IBOutlet weak var view1Lbl :UILabel!
    @IBOutlet weak var view2Lbl :UILabel!
    
    @IBOutlet weak var skipBtn: UIButton!
    var bankAccounts = [BankAccount]()
    
    var bankAccountsName :[String]{
        get{
            var bankAccountsName = [String]()
            
            for bankAccount in bankAccounts {
                bankAccountsName.append(bankAccount.bankName!)
            }
            
            return bankAccountsName
        }
    }
    
    var selectedBankId : Int{
        get{
            var id  = 0
            for bankAccount in bankAccounts {
                if bankAccount.bankName  == bankTF.text! {
                    id = bankAccount.id
                }
            }
            
            return id
        }
    }
    
    var delegate :BankTransferDelegate?
    
    
    
    var images :[UIImage] = []
    
    
    var orderId :Int?
    
    var orderNo: String = ""
    
    var isfromCheckOut :Bool = false
    
    
    var hideFormShow :Bool {
        get{
            return orderId == nil
//            return false
        }
    }
    
    
    
    @IBOutlet weak var collectionView :UICollectionView!
    @IBOutlet weak var bankTF: BottomLineTextFeild!
    @IBOutlet weak var placeHolderNameTF: BottomLineTextFeild!
    @IBOutlet weak var orderNumberTF: BottomLineTextFeild!
    @IBOutlet weak var priceTF: BottomLineTextFeild!
    @IBOutlet weak var sendedDateTF: BottomLineTextFeild!
    
    @IBOutlet weak var userAccountNumberTF: BottomLineTextFeild!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge()
        self.extendedLayoutIncludesOpaqueBars = false
        
        if hideFormShow {
            bankTV.tableFooterView = nil
            
            setBackTitle(title: "banks_account".localized)
            
        }else{
            
            setBackTitle(title: "bank_transfer_confirmation".localized)
            
        }
        
        
        registerViewCells()
        initDataForCollections()
        // Do any additional setup after loading the view.
        
        view1Lbl.isHidden = false
        view2Lbl.isHidden = false
        
        
        if !isfromCheckOut{
            skipBtn.removeFromSuperview()
            skipBtn.isHidden = false
        }
        
        if !hideFormShow {
            if orderId != nil {
            self.orderNumberTF.text = "order_number_is".localized + " " + orderNo
            }else{
               self.orderNumberTF.isEnabled = true
            }
            
            self.sendedDateTF.addTarget(self, action: #selector(textFieldDidBeginEditing), for: UIControl.Event.editingDidBegin)
            
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startRequestGetBanksAccount()
    }
    
    func registerViewCells(){
        bankTV.register(UINib(nibName: "BankTVC", bundle: .main), forCellReuseIdentifier: "BankTVC")
        
        collectionView.register(UINib(nibName: "RateImagesCVC", bundle: nil), forCellWithReuseIdentifier: "RateImagesCVC")
    }
    
    func initDataForCollections(){
        bankTV.dataSource = self
        bankTV.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    
    
    
    
    func startRequestGetBanksAccount(){
        API.BANKS_ACCOUNTS.startRequest(showIndicator: true) { (api, statusResult) in
            if statusResult.isSuccess {
                let value = statusResult.data  as! [Any]
                
                let bankAccountData = try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                
                self.bankAccounts = try! JSONDecoder().decode([BankAccount].self, from: bankAccountData)
                
                self.bankTV.reloadData()
                
                if !self.hideFormShow {
                    UIPickerView().initlizePicker(withArrayData: self.bankAccountsName, textFild: self.bankTF)
                    
                }
            }else{
                self.showBunnerAlert(title: "", message: statusResult.errorMessege)
            }
        }
    }
    
    
    
    func startSendRequestAddBanksAccountTransfer(){
        
        
        
        
        var params = [String:String]()
        params["bank_account_id"] = selectedBankId.description
        params["number"] = userAccountNumberTF.text!
        params["amount"] = priceTF.text!
        params["account_owner_name"] =  placeHolderNameTF.text!
        params["date"] = sendedDateTF.text!
        
        
        var paramsData = [String:Data]()
        paramsData["photo"] = images[0].jpegData(compressionQuality: 0.3)
        
        
        API.ADD_BANKTRANSFER.startRequestWithFile(showIndicator: true,nestedParams:  "\(orderId!)/bankTransfer",params:params ,data: paramsData) { (api, statusResult) in
            if statusResult.isSuccess {
                self.showOkAlert(title: "", message: statusResult.message){
                    self.delegate?.dismissed()
                    if self.isfromCheckOut {
                        self.skipAction(self.skipBtn)
                        
                    }else{
                        self.pop()
                    }
                }
            }else{
                self.showBunnerAlert(title: "", message: statusResult.errorMessege)
            }
        }
    }
    
    
    
    
    
    @IBAction func skipAction(_ sender :UIButton){
           var topViewController :UIViewController = self
          
          while let presentingViewController =  topViewController.presentingViewController {
              topViewController = presentingViewController
              if topViewController is MainTabBarVC {
                  (topViewController as! MainTabBarVC).selectedIndex = 0
                  break
              }
              
          }
        //  topViewController.didTapCloseButton(<#T##sender: Any##Any#>)
        dismiss(animated: false, completion: nil)
    }
    
}





extension BankTransferVC  :UITableViewDataSource ,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bankAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankTVC") as!  BankTVC
        cell.bankAccount = bankAccounts[indexPath.row]
        return cell
    }
    
    
    
}



extension BankTransferVC :UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if !images.isEmpty{
            view1Lbl.isHidden = true
            view2Lbl.isHidden = true
            collectionView.isHidden = false
            
        }else{
            view1Lbl.isHidden = false
            view2Lbl.isHidden = false
            collectionView.isHidden = true
        }
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RateImagesCVC", for: indexPath) as! RateImagesCVC
        cell.imgView.image = images[indexPath.row]
        cell.backgroundColor = UIColor.black
        cell.imgView.contentMode = .scaleAspectFill
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 45, height: 45)
    }
    
}


extension BankTransferVC{
    
    @IBAction func getImagesFromGallary(){
        let vc = BSImagePickerViewController()
        vc.maxNumberOfSelections = 1
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
                                            
                                            // User selected an asset.
                                            // Do something with it, start upload perhaps?
        }, deselect: { (asset: PHAsset) -> Void in
            // User deselected an assets.
            // Do something, cancel upload?
        }, cancel: { (assets: [PHAsset]) -> Void in
            // User cancelled. And this where the assets currently selected.
        }, finish: { (assets: [PHAsset]) -> Void in
            // User finished with these assets
            
            self.images.removeAll()
            
            assets.enumerated().forEach { (offset ,phAssets) in
                self.fetchImage(asset: phAssets) { (image) in
                    
                    self.images.append(image!)
                    if  self.images.count == assets.count {
                        self.collectionView.reloadData()
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
    
    
    
    @IBAction func sendInformation(_ sender :UIButton){
        
        switch validationInput() {
        case .invalid(let error):
            self.showBunnerAlert(title: "", message: error)
            
        case .valid:
            startSendRequestAddBanksAccountTransfer()
            break
        }
    }
    
    
    
    
    func validationInput() -> BankTransferValidation{
        
        if bankTF.text!.isEmpty {
            return .invalid("you_must_enter_bank_name".localized)
        }
        
        if placeHolderNameTF.text!.isEmpty {
            return .invalid("you_must_enter_place_holder_name".localized)
        }
        
        
        if userAccountNumberTF.text!.isEmpty {
            return .invalid("you_must_enter_price".localized)
        }
        
        
        if sendedDateTF.text!.isEmpty {
            return .invalid("you_must_enter_date".localized)
        }
        
        
        if priceTF.text!.isEmpty {
            return .invalid("you_must_enter_price".localized)
        }
        
        if images.isEmpty{
            return .invalid("you_must_attachment_file".localized)
        }
        
        
        
        return .valid
    }
}






extension BankTransferVC {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.sendedDateTF = textField as! BottomLineTextFeild
        
        // Create a date picker for the date field.
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(updateDateField(sender:)), for: .valueChanged)
        
        // If the date field has focus, display a date picker instead of keyboard.
        // Set the text to the date currently displayed by the picker.
        textField.inputView = picker
        textField.text = formatDateForDisplay(date: picker.date)
        
        
    }
    
    
    // Called when the date picker changes.
    
    @objc func updateDateField(sender: UIDatePicker) {
        sendedDateTF?.text = formatDateForDisplay(date: sender.date)
    }
    
    
    // Formats the date chosen with the date picker.
    
    fileprivate func formatDateForDisplay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "yyyy-M-d"
        return formatter.string(from: date)
    }
}
