//
//  CardVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 26/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class CardVC: UIViewController {

    var params :[String:String] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func startOrderReqest(){
        
              API.ORDER.startRequest(showIndicator: true,params:params) { (Api, statusResult) in
                  if statusResult.isSuccess {
                      let value = statusResult.data as! [String:Int]
                         var id = value["id"] as! Int
                         //self.showOkAlert(title: "", message: statusResult.message)
                          RealmHelper.removeAllProduct()
                            let storyboard = UIStoryboard(name: "Dialogs", bundle: nil)
                              let vc :SuccessOrderVC = storyboard.instanceVC()
                                vc.id = id
                              self.present(vc, animated: false,pushing: true){}

                       }else{
                       self.showOkAlert(title: "", message: statusResult.errorMessege)
                  }
              }
              
              
          }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
