//
//  OrderDetailsVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 29/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class OrderDetailsVC: UIViewController {
    @IBOutlet weak var ordersTV :UITableView!
    
    
    @IBOutlet weak var quantityLbl:UILabel!
    @IBOutlet weak var totalPriceLbl:UILabel!
    
    var pageOfTaps :OrderPageOfTabs = .new
    
    
    var totalPrice :String! = "0"
    var products :[Product] = []
    
    var orderID :String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        registerCell()
        ordersTV.dataSource = self
        ordersTV.delegate = self
        
        self.edgesForExtendedLayout = UIRectEdge()
        self.extendedLayoutIncludesOpaqueBars = false
        
        
        setBackTitle(title: "order_details".localized)
        
        
        
  
        
        if products.isEmpty {
            startRquestOrderDetails(orderId: orderID)
        }
        initData()
        
    }
    
    
    func initData(){
        quantityLbl.text = products.count.description
        totalPriceLbl.text = totalPrice.valueWithCurrency
        
    }
    
    
    func startRquestOrderDetails(orderId :String){
              API.ORDER_DETAILS.startRequest(showIndicator: true,nestedParams: orderId) { (Api, statusResult) in
                  if statusResult.isSuccess {
                      let data = statusResult.data
                      let orderData = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                      
                      let order = try! JSONDecoder().decode(Order.self, from: orderData)
                      
                      self.products = order.products
                      self.pageOfTaps = OrderPageOfTabs(rawValue: order.status)!
                      self.totalPrice = order.grandTotal
                      self.initData()
                      self.ordersTV.reloadData()
                  }else{
                      self.showBunnerAlert(title: "", message: statusResult.errorMessege)
                  }
              }
          
    }
    
    func registerCell(){
        ordersTV.register(UINib(nibName: "OrderProductTVC", bundle: nil), forCellReuseIdentifier: "OrderProductTVC")
    }
}



extension OrderDetailsVC  :UITableViewDataSource ,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderProductTVC") as!  OrderProductTVC
        cell.product = products[indexPath.row]
        
        cell.addReputation.tag = indexPath.row
        cell.addReputation.addTarget(self, action: #selector(showReputation), for: .touchUpInside)
        
        
        
        cell.reOrder.tag = indexPath.row
        cell.reOrder.addTarget(self, action: #selector(reOrderAction), for: .touchUpInside)
        
        
        if pageOfTaps != .new && pageOfTaps != .processing && pageOfTaps != .delivering && pageOfTaps != .rejected  {
            cell.addReputation.isHidden = false
        }else{
            cell.addReputation.isHidden = true
        }
        
        
        if pageOfTaps == .completed  {
            cell.reOrder.isHidden = false
        }else{
            cell.reOrder.isHidden = true
        }
        
        
        
        
        return cell
    }
    
    @objc func showReputation(_ button :UIButton){
        
        var product = products[button.tag]
        let vc :RateProductVC = self.storyboard!.instanceVC()
        vc.selecteProduct = product
        
        self.navigationController?.pushViewController(vc,animated: true)
    }
    
    
    
    
    
    
    
    @objc func reOrderAction(_ sender:UIButton){
        //delegate?.event()
        let product = products[sender.tag]
        
        showCustomAlert(title: "", message: "do_you_want_to_add_the_product_to_cart".localized, okTitle: "add_to_cart".localized, cancelTitle: "cancel".localized , color: UIColor.lightGray) { (status) in
            
            if status {
                RealmHelper.addToCart(product: product)
                self.showOkAlert(title: "", message: "تم اضافة المنتج في السلة".localized)
            }
        }
        
    }

}


