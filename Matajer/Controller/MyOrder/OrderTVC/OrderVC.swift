//
//  OrderDetailsVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 29/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class OrderVC: UIViewController {
    @IBOutlet weak var ordersTV :UITableView!
    @IBOutlet weak var emptyView : UIView!

    var pageOfTaps :OrderPageOfTabs = .new

 
    var isFirstTime = true

    
    var orders = [Order]()
    
    let refresherControl = UIRefreshControl()
    
    var isLoadMore = false
    var pageNumber = 2
    
    
    var isNeedToRefresh = false
    override func viewDidLoad() {
        super.viewDidLoad()
            registerViewCells()
            initDataForCollections()
        // Do any additional setup after loading the view.
        
        refresherControl.addTarget(self, action: #selector(startRefresh), for: UIControl.Event.valueChanged)
          ordersTV.refreshControl = refresherControl
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        startRefreshRequset()
    }
    
   @objc func startRefresh(){
        refresherControl.beginRefreshing()
        startReqest(forPage: 1)
        pageNumber = 2
        isLoadMore = false
    }
    
    
    func registerViewCells(){
        ordersTV.register(UINib(nibName: "OrderTVC", bundle: .main), forCellReuseIdentifier: "OrderTVC")
    }
    
    func initDataForCollections(){
        ordersTV.dataSource = self
        ordersTV.delegate = self
    }
    
    
    func startRefreshRequset(){
        if isNeedToRefresh {
            isNeedToRefresh = !isNeedToRefresh
            startReqest(forPage: 1)
        }
    }

    
    
    func startRequset(){
        if isFirstTime {
            isFirstTime = !isFirstTime
            startReqest(forPage: 1)
        }
    }

    
    
       private func startReqest(forPage pageNumber:Int = 1){
           let params = [String:String]() //
           
           switch pageOfTaps{
           case .new:
                   API.ORDER_NEW.startRequest(showIndicator: true,params: params,completion: response)
           case .processing,.delivering:
                   API.ORDER_PROCESSING.startRequest(showIndicator: true,params: params,completion: response)
           case .completed:
                   API.ORDER_COMPLETED.startRequest(showIndicator: true,params: params,completion: response)
            case .rejected:
                    API.ORDER_REJECTED.startRequest(showIndicator: true,params: params,completion: response)
           }
          
       }
    
    
    
    func response(api :API,statusResult :StatusResult){
        refresherControl.endRefreshing()
        if statusResult.isSuccess {
            let value = statusResult.data as! [[String:Any]]
         
            
            let productData = try! JSONSerialization.data(withJSONObject:value, options: .prettyPrinted)
            
            self.orders = try! JSONDecoder().decode([Order].self, from: productData)
                        
                if self.orders.isEmpty {
                        self.showEmpty()
                }else{
                    self.hideEmpty()
                }
            self.ordersTV.reloadData()
        }else{
            print(statusResult.errorMessege)
        }
    }

    
    
    
    func showEmpty(){
           self.view.bringSubviewToFront(emptyView)
           emptyView.isHidden = false
           ordersTV.isHidden = true
       }
       
       
       func hideEmpty(){
           self.view.bringSubviewToFront(ordersTV)
           emptyView.isHidden = true
           ordersTV.isHidden = false
       }
    
    
    
}




extension OrderVC  :UITableViewDataSource ,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTVC") as!  OrderTVC
        
          
//                switch pageOfTaps{
//                    case .new:
//                        cell.stepper.steps = 1
//                    case .processing,.delivering:
//                        cell.stepper.steps = 2
//                    case .completed:
//                        cell.stepper.steps = 3
//                     case .rejected:
//                        cell.stepper.steps = 0
//                }
        
        
        cell.selectionStyle = .none
        
        cell.invoiceBtn.tag = indexPath.row
        cell.invoiceBtn.addTarget(self, action: #selector(showInvoice), for: .touchUpInside)
        
        
        cell.reOrderBtn.tag = indexPath.row
        cell.reOrderBtn.addTarget(self, action: #selector(reOrderAction), for: .touchUpInside)
             
        
        cell.bankTransferBtn.tag = indexPath.row
        cell.bankTransferBtn.addTarget(self, action: #selector(attachmentPaymentTransfer), for: .touchUpInside)
        
          if pageOfTaps != .new || pageOfTaps != .processing {
                  cell.reOrderBtn.isHidden = false
              }else{
                  cell.reOrderBtn.isHidden = true
              }
        
        cell.order = orders[indexPath.row]
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc :OrderDetailsVC = self.storyboard!.instanceVC()
        vc.products =  orders[indexPath.row].products
        vc.totalPrice = orders[indexPath.row].grandTotal
        vc.pageOfTaps = pageOfTaps
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showInvoice(_ sender:UIButton){
        //delegate?.event()
        let order = orders[sender.tag]
        
        let storyBoard = UIStoryboard(name: "Main2", bundle: nil)
        let vc :InvoiceVC = storyBoard.instanceVC()
        vc.order = order
        
        self.navigationController?.pushViewController(vc,animated: true)
    
    }
    
    
    @objc func attachmentPaymentTransfer(_ sender:UIButton){
         //delegate?.event()
        let order = orders[sender.tag]
        let vc :BankTransferVC = self.storyboard!.instanceVC()
        vc.orderId = order.id
        isNeedToRefresh = true
        self.navigationController?.pushViewController(vc,animated: true)
     }
    
    
    
    @objc func reOrderAction(_ sender:UIButton){
        //delegate?.event()
        let order = orders[sender.tag]
 
        
        showCustomAlert(title: "", message: "do_you_want_to_add_all_products_in_your_cart".localized, okTitle: "add_to_cart".localized, cancelTitle: "cancel".localized , color: UIColor.lightGray) { (status) in
            
            if status {
                order.products.forEach { (product) in
                    RealmHelper.addToCart(product: product)
                }
                
                self.showOkAlert(title: "", message: "all_products_added_in_cart".localized)
            }

        }

        

        //API.ORDER_REJECTED.startRequest(showIndicator: true,params: params,completion: response)

        
        
        
    }
    
    
    
}






//for load more
extension OrderVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY + 180)  > contentHeight - scrollView.frame.size.height {
            loadMoreDataFromServer()
        }
    }
    
    
    func loadMoreDataFromServer(){
        if !isLoadMore {
            isLoadMore.toggle()
             let params = ["page":pageNumber.description]
               switch pageOfTaps{
                case .new:
                        API.ORDER_NEW.startRequest(showIndicator: false,params: params,completion: responseLoadMore)
                case .processing,.delivering:
                        API.ORDER_PROCESSING.startRequest(showIndicator: false,params: params,completion: responseLoadMore)
                case .completed:
                        API.ORDER_COMPLETED.startRequest(showIndicator: false,params: params,completion: responseLoadMore)
                 case .rejected:
                         API.ORDER_REJECTED.startRequest(showIndicator: false,params: params,completion: responseLoadMore)
                }
            
        }
    }
    
    
    func responseLoadMore(api :API,statusResult :StatusResult){
        if statusResult.isSuccess {
            pageNumber += 1
            isLoadMore.toggle()
            
            let value = statusResult.data as! [[String:Any]]
            
            let markaData = try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            
            let orders = try! JSONDecoder().decode([Order].self, from: markaData)
            
            
            if !orders.isEmpty {
                self.orders.append(contentsOf: orders)
            }else{
                isLoadMore = true
            }
            self.ordersTV.reloadData()
        }else{
            print(statusResult.errorMessege)
        }
    }
    
    
}



