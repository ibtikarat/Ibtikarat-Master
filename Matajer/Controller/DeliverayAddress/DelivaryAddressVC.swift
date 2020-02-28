//
//  DelivaryAddressVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 25/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class DelivaryAddressVC: UIViewController {
    @IBOutlet weak var addressTV :UITableView!
    @IBOutlet weak var addAddressBtn :UIButton!
    @IBOutlet weak var emptyView :UIView!

    var addresses = [Address]()
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyView.isHidden = true
        addAddressBtn.isHidden = true
        //edgesForExtendedLayout = []

        // Do any additional setup after loading the view.
        registerViewCells()
        initDataForCollections()
        
        
               self.edgesForExtendedLayout = UIRectEdge()
               self.extendedLayoutIncludesOpaqueBars = false
        
        
        
//
//       navigationItem.backBarButtonItem = UIBarButtonItem(title: "vvvvvvv", style: .plain, target: nil, action: nil)

        //self.navigationController?.navigationBar.backItem?.title = "عنــوان التوصيل"

        setBackTitle(title: "delivary_address".localized)
    }
    
     override func viewWillAppear(_ animated: Bool) {
//           self.navigationController?.navigationBar.backItem?.title = "عنــوان التوصيل"
//        self.title = ""
        emptyView.isHidden = true
        addAddressBtn.isHidden = true
        
        
        
        startReqestAddress()
       }
    
    func registerViewCells(){
        addressTV.register(UINib(nibName: "DelivaryAddressTVC", bundle: .main), forCellReuseIdentifier: "DelivaryAddressTVC")
    }
    
    func initDataForCollections(){
        addressTV.dataSource = self
        addressTV.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addAddressBtn.applyGradient(colours: [UIColor.CustomColor.primaryColor2,UIColor.CustomColor.primaryColor],gradientOrientation :
            .horizontal)
    }
 
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    private func startReqestAddress(){
           API.MY_ADDRESS.startRequest(showIndicator: true) { (Api, statusResult) in
               if statusResult.isSuccess {
                  let value = statusResult.data  as! [Any]
                   
                    
                   let addressData = try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                   
                   self.addresses = try! JSONDecoder().decode([Address].self, from: addressData)
                          
                
                
                if self.addresses.isEmpty {
                    self.emptyView.isHidden = false
                    self.view.bringSubviewToFront(self.emptyView)
                }else{
                    self.addAddressBtn.isHidden = false
                    self.view.bringSubviewToFront(self.addressTV)
                    self.view.bringSubviewToFront(self.addAddressBtn)
                }
              
                  self.addressTV.reloadData()
               }else{
                self.showOkAlert(title: "", message: statusResult.errorMessege)
               }
           }
       }
      
    
    
    
    
    private func startReqestDeleteAddress(address :Address){
        API.REMOVE_ADDRESS.startRequest(showIndicator: true,nestedParams: address.id!.description) { (api, statusResult) in
             if statusResult.isSuccess {
                    self.showOkAlert(title: "", message: statusResult.message){
                        self.startReqestAddress()
                    }
                    }else{
                    self.showOkAlert(title: "", message: statusResult.errorMessege)
                }
        }
        
    }
    
    
    private func startReqestUpdateAddress(address :Address){
        var params = [String:String]()
        params["title"] = address.title
        params["region"] = address.region
        params["details"] =  address.addressDetails
        params["lat"] = address.latitude.description
        params["lng"] = address.longitude.description
        params["phone"] = address.phone?.description
            params["is_default"] = "1"

        API.UPDATE_ADDRESS.startRequest(showIndicator: true,nestedParams: address.id!.description ,params: params) { (Api, statusResult) in
            if statusResult.isSuccess {
                if  self.navigationController is AddressNVC{
                        //self.navigationController?.dismiss(animated: true, completion: nil)
                        self.navigationController?.didTapCloseButton(self)
                }else{
                    self.addresses.forEach { (address) in
                        address.isDefult = false
                    }
                    address.isDefult = true
                    self.addressTV.reloadData()
                }
            }else{
                self.showBunnerAlert(title: "", message: statusResult.errorMessege)
            }
        }
    }


}


extension DelivaryAddressVC  :UITableViewDataSource ,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DelivaryAddressTVC") as!  DelivaryAddressTVC
        
        cell.address = addresses[indexPath.row]
        cell.deleteAddressAction = deleteAddress
        cell.updateAddressAction = updateAddress
        return cell
    }
    
    func updateAddress(address :Address){
        let vc :AddAddressVC = self.storyboard!.instanceVC()
        vc.address = address
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //if self.navigationController! is AddressNVC {
            let address = addresses[indexPath.row]
            self.startReqestUpdateAddress(address: address)
        //}
    }
    
    func deleteAddress(address :Address){
        self.showCustomAlert(title: "", message: "are_you_sure_want_to_delete_your_address".localized, okTitle: "cancel".localized, cancelTitle: "delete".localized) { (bool) in
            
            if !bool {
                self.startReqestDeleteAddress(address: address)
            }
        }
     }
}


