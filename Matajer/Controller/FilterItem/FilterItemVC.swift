//
//  FilterByVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 21/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit


class FilterItemVC: UIViewController {

    var filterObjects = [FilterObject]()

    var filterObject : FilterObject!
    
    @IBOutlet weak var filterTV :UITableView!
    
    
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



extension FilterItemVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterObject.item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filterItem = filterObject.item[indexPath.row]
        
        if filterObject.isRating {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterRateTVC") as! FilterRateTVC
            cell.filterItem = filterObject.item[indexPath.row]
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterItemTVC") as! FilterItemTVC
            cell.filterItem = filterObject.item[indexPath.row]
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       if filterObject.isSingleChoice{
            deselctAll(items: filterObject.item)
            filterObject.item[indexPath.row].isSelected =  !filterObject.item[indexPath.row].isSelected

       }else{
         filterObject.item[indexPath.row].isSelected =  !filterObject.item[indexPath.row].isSelected
        }
        tableView.reloadData()
    }
    
    
    func deselctAll(items: [FilterItem]){
        items.forEach { (filterItem) in
            filterItem.isSelected = false
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
