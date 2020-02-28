//
//  FilterItemRateVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 21/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class FilterItemRateVC: UIViewController {
    @IBOutlet weak var filterTV :UITableView!
       
    
    var filterObjects = [FilterObject]()

    var filterObject : FilterObject!
    
    
       override func viewDidLoad() {
           super.viewDidLoad()
           filterTV.dataSource = self
           filterTV.delegate = self
           // Do any additional setup after loading the view.
           
    
       }

    
    
      
    @IBAction func goToResult(_ sender :UIButton){
        let vc :FilterResultVC = self.storyboard!.instanceVC()
        vc.filterObjects = filterObjects
        self.present(vc, animated: false,pushing: true, completion: nil)
    }
    
}




extension FilterItemRateVC : UITableViewDataSource, UITableViewDelegate{
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return filterObject.item.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "FilterItemTVC") as! FilterItemTVC
         cell.filterItem = filterObject.item[indexPath.row]
         
         return cell
     }
     
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
         filterObject.item[indexPath.row].isSelected =  !filterObject.item[indexPath.row].isSelected
         
         tableView.reloadData()
     }
     
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 65
     }
}



