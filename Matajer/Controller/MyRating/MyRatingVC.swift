//
//  MyRatingVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 25/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class MyRatingVC: UIViewController {

    
     @IBOutlet weak var emptyView : UIView!
    @IBOutlet weak var ratingTV :UITableView!
    
    var ratings :[Rate] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        ratingTV.isHidden = true
        emptyView.isHidden = true
        //edgesForExtendedLayout = []

        // Do any additional setup after loading the view
        registerViewCells()
        initDataForCollections()
        //self.navigationController?.navigationBar.backItem?.title = "تقييماتي"

        self.setBackTitle(title: "my_rating".localized)
        self.edgesForExtendedLayout = UIRectEdge()
        self.extendedLayoutIncludesOpaqueBars = false
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
         startRequestGetRatings()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func registerViewCells(){
        ratingTV.register(UINib(nibName: "MyRatingTVC", bundle: .main), forCellReuseIdentifier: "MyRatingTVC")
    }
    
    func initDataForCollections(){
        ratingTV.dataSource = self
        ratingTV.delegate = self
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
     func startRequestGetRatings(){
            API.RATINGS.startRequest(showIndicator: true) { (api, statusResult) in
                    if statusResult.isSuccess {
                              let value = statusResult.data  as! [Any]
                               
                                
                               let ratingsData = try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                               
                               self.ratings = try! JSONDecoder().decode([Rate].self, from: ratingsData)
                        
                    
                        if self.ratings.isEmpty {
                                    self.showEmpty()
                                }else{

                                    self.hideEmpty()
                                }
                            self.ratingTV.reloadData()
                    }else{
                     self.showOkAlert(title: "", message: statusResult.errorMessege)
                   }
                }
            }
        
        
        func showEmpty(){
            self.view.bringSubviewToFront(emptyView)
            emptyView.isHidden = false
            ratingTV.isHidden = true
        }
        
        
        func hideEmpty(){
            self.view.bringSubviewToFront(ratingTV)
            emptyView.isHidden = true
            ratingTV.isHidden = false
        }
        
    




}

extension MyRatingVC  :UITableViewDataSource ,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRatingTVC") as!  MyRatingTVC
        cell.rating = ratings[indexPath.row]
        
        if  cell.rating!.images.isEmpty {
            cell.imageCollectionViews.visibility = .gone
        }
        
        return cell
    }
    
    
 
}
