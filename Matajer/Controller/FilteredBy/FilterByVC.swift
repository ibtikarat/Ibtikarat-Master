//
//  FilterByVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 21/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class FilterItem {
    var id :Int  = 0
    var name :String  = ""
    
    
    var isSelected = false
    
    
    init(id :Int,name :String){
        self.id = id
        self.name = name
    }
}

class FilterObject {
    var key :String  = ""
    var value :String  = ""
    
    var item: [FilterItem] = []
    
    var isRating = false
    var isSingleChoice = false

    init(key :String,value :String,data :[String:Any]){
        self.key = key
        self.value = value
        self.item = getFilterItem(value: data, keyName: self.key)
    }
    
    
    init(key :String,value :String,isRating :Bool){
          self.key = key
          self.value = value
        
          self.isRating = isRating
        self.item = []
        self.item.append(FilterItem(id: 1, name: "1"))
        self.item.append(FilterItem(id: 2, name: "2"))
        self.item.append(FilterItem(id: 3, name: "3"))
        self.item.append(FilterItem(id: 4, name: "4"))
        self.item.append(FilterItem(id: 5, name: "5"))
      }
    
    
 
    
    func getFilterItem(value :[String:Any], keyName:String)->[FilterItem]{
          var filterItems = [FilterItem]()
          let items = value[keyName] as! [[String:Any]]
          for item in items{
              let id = item["id"] as! Int
              let name = item["name"] as! String
              let filterItem = FilterItem(id: id, name: name)
              filterItems.append(filterItem)
          }
          
          return filterItems
      }
    
    
    func cleaerItemFilter(){
        item.forEach { (filterItem) in
            filterItem.isSelected = false
        }
    }
    
    var selectedItemName :String{
        get{
            var itemNames :String = ""
            
            getSelectedItem.forEach { (filterItem) in
                itemNames.append(filterItem.name + ", ")
            }
            
            
            return itemNames
        }
    }
    
    
    
    var getSelectedItem :[FilterItem]{
        get{
            var items: [FilterItem] = []
            self.item.forEach { (filterItem) in
                if filterItem.isSelected {
                    items.append(filterItem)
                }
            }
            return items
        }
    }
    
    
    var getIDsArrayJson :String{
        get{
            var json :[String] = []
            
            getSelectedItem.forEach { (filterItem) in
                json.append(filterItem.id.description)
            }
            
            guard let data = try? JSONSerialization.data(withJSONObject: json, options: []) else {
                return ""
            }
            
            return String(data: data, encoding: String.Encoding.utf8) ?? ""
         }
    }
}

class FilterByVC: UIViewController {

    
    var filterObjects = [FilterObject]()
    
    @IBOutlet weak var filterTV :UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterTV.dataSource = self
        filterTV.delegate = self
        // Do any additional setup after loading the view.
        
        startReqest()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.filterTV.reloadData()

    }
    
        private func startReqest(){
            
 
            API.FILTER_ITEMS.startRequest(showIndicator: true,completion: response)
            
        }

        func response(api :API,statusResult :StatusResult){
            if statusResult.isSuccess {
                let value = statusResult.data as! [String:Any]
                let mainCategories = FilterObject(key: "main_categories", value: "product_category".localized, data: value)
                
                let categories = FilterObject(key: "categories", value: "category".localized, data: value)
                let tradeMarks = FilterObject(key: "tradeMarks", value: "trade_marks".localized, data: value)
                let colors = FilterObject(key: "colors", value: "colors".localized, data: value)

                
                let ratings = FilterObject(key: "ratings", value: "ratings".localized, isRating: true)

                
                self.filterObjects.append(mainCategories)
                self.filterObjects.append(categories)
                self.filterObjects.append(tradeMarks)
                self.filterObjects.append(colors)
                self.filterObjects.append(ratings)
                
                
                
                self.filterTV.reloadData()
                
            }else{
                self.showOkAlert(title: "", message: statusResult.errorMessege)
            }
        }
    
    
        
      @IBAction func goToResult(_ sender :UIButton){
          let vc :FilterResultVC = self.storyboard!.instanceVC()
          vc.filterObjects = filterObjects
        self.present(vc, animated: false,pushing: true, completion: nil)
      }
    
  
    @IBAction func resetAllItemFilter(_ sender :UIButton){
        filterObjects.forEach { (filterObject) in
            filterObject.cleaerItemFilter()
        }
    
        filterTV.reloadData()
        
    }
      
 

    
    

}



extension FilterByVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTVC") as! FilterTVC
        cell.filterObject = filterObjects[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let filterObject  = filterObjects[indexPath.row]
        
        
       
            let vc :FilterItemVC = self.storyboard!.instanceVC()
            vc.filterObject = filterObjects[indexPath.row]
            vc.filterObjects = filterObjects
            self.navigationController?.pushViewController(vc, animated: true)
            
        

        
        
   
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
