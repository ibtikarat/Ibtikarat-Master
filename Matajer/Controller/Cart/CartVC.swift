//
//  CartVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 24/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import RealmSwift
class CartVC: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    static var UPDATE_TOTAL_PRICE_OBSERVER = "update_total_price"
    
    @IBOutlet weak  var cartTV :UITableView!
    @IBOutlet weak var emptyView : UIView!
    @IBOutlet weak var informationView : UIView!


    @IBOutlet weak var completeOrderBtn :UIButton!
    
    
    @IBOutlet weak var totalPriceLbl :UILabel!
    @IBOutlet weak var quantityLbl :UILabel!

    
    
    var rProducts :Results<RProduct> = {
        return RealmHelper.getAllProduct()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerViewCells()
        initDataForCollections()
        
      
        initData()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        initData()
        //registerNotificationCenter()
    }
    
    
    
//
//    func registerNotificationCenter(){
//        NotificationCenter.default.addObserver(self, selector: #selector(updateTotalPrice), name: NSNotification.Name(CartVC.UPDATE_TOTAL_PRICE_OBSERVER), object: nil)
//    }
    
    
    func initData(){
        rProducts =  RealmHelper.getAllProduct()
        cartTV.isHidden = true
        emptyView.isHidden = true
        informationView.isHidden = true
        

        if self.rProducts.isEmpty {
                    self.showEmpty()
                }else{
                    self.hideEmpty()
                }
        
        
        cartTV.reloadData()
        
        var count = 0
        rProducts.forEach { (rProduct) in
            count += rProduct.quantity
        }
        
        quantityLbl.text = count.description
         
        let totalValue = RealmHelper.getTotalPrice()
         

        totalPriceLbl.text = Int(totalValue).description.valueWithCurrency
        
        
    
    }

    override func viewDidLayoutSubviews() {
                
         completeOrderBtn.applyGradient(colours: [UIColor.CustomColor.primaryColor2,UIColor.CustomColor.primaryColor],gradientOrientation : .horizontal)
    }
    
    func registerViewCells(){
        cartTV.register(UINib(nibName: "CartTVC", bundle: .main), forCellReuseIdentifier: "CartTVC")
        
     }
    
    func initDataForCollections(){
        cartTV.dataSource = self
        cartTV.delegate = self
        
    }
    
    
    
    func showEmpty(){
        self.view.bringSubviewToFront(emptyView)
        emptyView.isHidden = false
        cartTV.isHidden = true
        informationView.isHidden = true
    }
    
    
    func hideEmpty(){
        self.view.bringSubviewToFront(cartTV)
        self.view.bringSubviewToFront(informationView)
        emptyView.isHidden = true
        cartTV.isHidden = false
        informationView.isHidden = false
    }
    
 
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func completeOrder(_ sender :UIButton){
        if !MatajerUtility.isLogin() {
                self.signIn()
                 return
                }
        //performSegue(withIdentifier: "OrderConfirmationVC", sender: nil)
        let orderConfirmation :OrderConfirmationVC  = self.storyboard!.instanceVC()
        self.present(orderConfirmation, animated: false, pushing: true)
    }
}



extension CartVC  :UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rProducts.count
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTVC",for: indexPath) as! CartTVC
            cell.rProduct = rProducts[indexPath.row]
        cell.refreshProduct = refreshProduct

        cell.removeBtn.tag = indexPath.row
        cell.removeBtn.addTarget(self, action: #selector(deleteProduct), for: .touchUpInside)
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//              let vc = self.storyboard!.instantiateViewController(withIdentifier: "OfferDetailsVC")
//               self.present(vc, animated: true, completion: nil)
           
    }
     
    
 
    @objc func deleteProduct(_ sender :UIButton){
        let rProduct = rProducts[sender.tag]
        RealmHelper.delete(product: rProduct)
        self.cartTV.deleteRows(at: [IndexPath(row: sender.tag, section: 0)], with: .fade)
        initData()
    }
    
    
    func refreshProduct(){
        initData()
    }

    
    
//    @objc func updateTotalPrice(){
//        refreshProduct()
//    }
//
    
    
    
    
    
    @IBAction func goToMain(_ sender :Any){
        self.tabBarController?.selectedIndex = 0
    }
}

