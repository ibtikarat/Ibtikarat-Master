//
//  NotificationVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 25/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
enum NotificationTypes:String {
    case category,product,tradeMark,mainCategory,bankTransfer,order,other
}



class NotificationVC: UIViewController {
    
    @IBOutlet weak var notificationTV : UITableView!
    @IBOutlet weak var emptyView : UIView!
    
    
    var notfications :[Notification] = []
    
    
    var refreshControl :UIRefreshControl = UIRefreshControl()
    
    //loadMore
    var isLoadMore = false
    var pageNumber = 2
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationTV.isHidden = true
        emptyView.isHidden = true
        
        //self.navigationController?.navigationBar.backItem?.title = "الاشعارات"
        //self.navigationController?.navigationBar.topItem?.title = "الاشعارات"
        
        //edgesForExtendedLayout = []
        
        self.edgesForExtendedLayout = UIRectEdge()
        self.extendedLayoutIncludesOpaqueBars = false
        
        // Do any additional setup after loading the view.
        registerViewCells()
        initDataForCollections()
        
        
        if MatajerUtility.isLogin() {
            startRequestGetUserNotfications()
        }else{
            startRequestGetPublicNotfications()
        }
        
        
        setBackTitle(title: "notification".localized)
        
        
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
        notificationTV.refreshControl = refreshControl
        
        
        
        
    }
    
    
    
    @objc func refreshData(){
        pageNumber = 2
        isLoadMore = false
        
        refreshControl.beginRefreshing()
        if MatajerUtility.isLogin() {
            startRequestGetUserNotfications()
        }else{
            startRequestGetPublicNotfications()
        }
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.navigationBar.backItem?.title = "الاشعارات"
    }
    
    
    func registerViewCells(){
        notificationTV.register(UINib(nibName: "NotiticationTVC", bundle: .main), forCellReuseIdentifier: "NotiticationTVC")
    }
    
    func initDataForCollections(){
        notificationTV.dataSource = self
        notificationTV.delegate = self
        
    }
    
    
    
    
    
    
    func startRequestGetUserNotfications(){
        API.ALL_NOTIFICATIONS.startRequest(showIndicator: true) { (api, statusResult) in
            self.refreshControl.endRefreshing()
            
            if statusResult.isSuccess {
                let value = statusResult.data  as! [Any]
                
                
                let bankAccountData = try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                
                self.notfications = try! JSONDecoder().decode([Notification].self, from: bankAccountData)
                
                
                if self.notfications.isEmpty {
                    self.showEmpty()
                }else{
                    self.hideEmpty()
                }
                self.notificationTV.reloadData()
            }else{
                self.showOkAlert(title: "", message: statusResult.errorMessege)
            }
        }
    }
    
    
    
    func startRequestGetPublicNotfications(){
        API.ALL_NOTIFICATIONS.startRequest(showIndicator: true) { (api, statusResult) in
            self.refreshControl.endRefreshing()
            if statusResult.isSuccess {
                let value = statusResult.data  as! [Any]
                
                
                let bankAccountData = try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                
                self.notfications = try! JSONDecoder().decode([Notification].self, from: bankAccountData)
                
                
                if self.notfications.isEmpty {
                    self.showEmpty()
                }else{
                    self.hideEmpty()
                }
                self.notificationTV.reloadData()
            }else{
                self.showOkAlert(title: "", message: statusResult.errorMessege)
            }
        }
    }
    
    
    
    
    func showEmpty(){
        self.view.bringSubviewToFront(emptyView)
        emptyView.isHidden = false
        notificationTV.isHidden = true
    }
    
    
    func hideEmpty(){
        self.view.bringSubviewToFront(notificationTV)
        emptyView.isHidden = true
        notificationTV.isHidden = false
    }
    
}

extension NotificationVC  :UITableViewDataSource ,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notfications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotiticationTVC") as!  NotiticationTVC
        
        cell.notification = notfications[indexPath.row]
        return cell
    }
    
    
}






//for load more
extension NotificationVC {
    
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
            
            if MatajerUtility.isLogin() {
                API.ALL_NOTIFICATIONS.startRequest(showIndicator: false,params: params,completion: responseLoadMore)
            }else{
                API.ALL_NOTIFICATIONS.startRequest(showIndicator: false,params: params,completion: responseLoadMore)
            }
        }
    }
    
    
    func responseLoadMore(api :API,statusResult :StatusResult){
        if statusResult.isSuccess {
            pageNumber += 1
            isLoadMore.toggle()
            
            let value = statusResult.data as! [[String:Any]]
            
            
            let notficationData = try! JSONSerialization.data(withJSONObject:value, options: .prettyPrinted)
            
            let notfications = try! JSONDecoder().decode([Notification].self, from: notficationData)
            
            if !notfications.isEmpty {
                self.notfications.append(contentsOf: notfications)
            }else{
                isLoadMore = true
            }
            self.notificationTV.reloadData()
        }else{
            print(statusResult.errorMessege)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var notification = notfications[indexPath.row]
        
        if MatajerUtility.isLogin() {
            if !notification.isSeen {
            API.SET_NOTIFICATION.startRequest(nestedParams:"\(notification.id)"){ _,_ in
                    notification._isSeen = 1
                    tableView.reloadData()
                }
            }
        }
        
        
        
        let type = NotificationTypes(rawValue: notification.model ?? "other")
        switch type{
            case .bankTransfer:
                goToBankTransfere(orderId: notification.modelId ?? 0)
                break
                
            case .category:
                let cat = Category(id:  notification.modelId ?? 0, image: "", name: "")
                goToProductCategory(category: cat)
                break
                
            case .mainCategory:
                let cat = Category(id:  notification.modelId ?? 0, image: "", name: "")
                goToProductMainCategory(category: cat)
                
                break
                
            case .order:
                goToOrder(orderId : notification.modelId?.description ?? "0" )
                break
                
            case .product:
                goToProductDetailsClicked(productId: notification.modelId ?? 0)
                break
 
            case .tradeMark:
                let tredMarks = TradeMark(id:  notification.modelId ?? 0, name: "", image: "")
                goToTreadMarks(tradeMark: tredMarks)
                break
 
            default:
                break
        }
    }
        
        
        
        
    func goToOrder(orderId: String){
            let mainOrder :OrderDetailsVC  = self.storyboard!.instanceVC()
            mainOrder.orderID = orderId
            self.navigationController?.pushViewController(mainOrder, animated: true)
        }
        
        
        
    func goToBankTransfere(orderId : Int){
            let storyboard = UIStoryboard(name: "Main2", bundle: nil)
            let vc :BankTransferVC = storyboard.instanceVC()
            vc.orderId = orderId
            vc.isfromCheckOut = false
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true){}
        }
        
    
    
    func goToProductDetailsClicked(productId :Int)  {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "OfferDetailsVC") as! OfferDetailsVC2
        
        let product = Product(id: productId, price: "0", isOffer: 0, priceAfterDiscount: "", sliderImage: "", suggestions: [], name: "", reviewsDescription: "", image: "", grandRate: 0.0, ratesCount: 0, images: [], specifications: [], colors: [], tradeMark: TradeMark(id: 0, name: "", image: ""), category: Category(id: 0, image: "", name: ""), rates: [])
        
        
        vc.selectedProduct = product
        self.present(vc, animated: false, pushing: true )
    }
    
    
    
    func goToProductCategory(category :Category){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "MarkaPageVC") as! MoreProductPageVC
            vc.subCategroy = category
            self.present(vc, animated: true, completion: nil)
    }
    
    func goToProductMainCategory(category :Category){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "MarkaPageVC") as! MoreProductPageVC
        vc.category = category
            self.present(vc, animated: true, completion: nil)
    }
    
    
    
    func goToTreadMarks(tradeMark :TradeMark){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "MarkaPageVC") as! MoreProductPageVC
        vc.tradeMark = tradeMark
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
        
}


