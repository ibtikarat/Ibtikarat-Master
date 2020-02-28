//
//  MarketPageVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 14/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class MarketPageVC: UIViewController {
    @IBOutlet weak var collectionCategoryCV :UICollectionView!

    var marka :[TradeMark] = []
    
    var isFirstTime = true
    
    
    var isLoadMore = false
    var pageNumber = 2
    var refreshControl :UIRefreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerViewCells()
        initDataForCollections()
        // Do any additional setup after loading the view.

        
    }
    

    
    func registerViewCells(){
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
        collectionCategoryCV.refreshControl = refreshControl
        
        collectionCategoryCV.register(UINib(nibName: "MarkaCVC", bundle: .main), forCellWithReuseIdentifier: "MarkaCVC")
    }
    
    
    @objc func refreshData(){
          pageNumber = 2
            isLoadMore = false
          refreshControl.beginRefreshing()
          startReqestMarka(forPage: 1)
      }
      
    
    
    
    func initDataForCollections(){
        collectionCategoryCV.dataSource = self
        collectionCategoryCV.delegate = self

        collectionCategoryCV.collectionViewLayout.invalidateLayout()

        
        
    }
    
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    func startRequset(){
        if isFirstTime {
            isFirstTime = !isFirstTime
            startReqestMarka()
        }
    }
    
    
    private func startReqestMarka(forPage pageNumber :Int = 1){
         API.TAB_BRANDS.startRequest(showIndicator: true) { (Api, statusResult) in
            self.refreshControl.endRefreshing()

            if statusResult.isSuccess {
                let value = statusResult.data  as! [[String:Any]]
                 
                          
                 let markaData = try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                 
                 self.marka = try! JSONDecoder().decode([TradeMark].self, from: markaData)
                             
                
                self.collectionCategoryCV.reloadData()
                self.loadMoreDataFromServer()
             }else{
                 print(statusResult.errorMessege)
             }
         }
     }
    
    
}




extension MarketPageVC: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return marka.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MarkaCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "MarkaCVC", for: indexPath) as! MarkaCVC
        cell.marka = marka[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
  
            let padding: CGFloat =  16
            let collectionViewSize = collectionView.frame.size.width - padding
            collectionView.invalidateIntrinsicContentSize()
        
        
        
            return CGSize(width: collectionViewSize/4 - 18, height: ((collectionViewSize/4) - 8 ) * 1.2)
    }
    
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "MarkaPageVC") as! MoreProductPageVC
        
            vc.tradeMark = marka[indexPath.row]
            self.present(vc, animated: true, completion: nil)
        
    }
}






//for load more
extension MarketPageVC {
    
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
          
            API.TAB_BRANDS.startRequest(showIndicator: false,params: params,completion: responseLoadMore)
            
        }
    }
    
    
    func responseLoadMore(api :API,statusResult :StatusResult){
        if statusResult.isSuccess {
            pageNumber += 1
            isLoadMore.toggle()
            
            let value = statusResult.data as! [[String:Any]]
            
            let markaData = try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            
            let marka = try! JSONDecoder().decode([TradeMark].self, from: markaData)
            
            
            if !marka.isEmpty {
                self.marka.append(contentsOf: marka)
            }else{
                isLoadMore = true
            }
            self.collectionCategoryCV.reloadData()
        }else{
            print(statusResult.errorMessege)
        }
    }
    
    
}



