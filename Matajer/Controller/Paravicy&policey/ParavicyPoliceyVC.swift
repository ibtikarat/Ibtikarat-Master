//
//  ParavicyPoliceyVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 08/10/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import WebKit
class ParavicyPoliceyVC: UIViewController {

    @IBOutlet weak var webView :WKWebView!
    @IBOutlet weak var progressView: UIProgressView!

    
    let urlValue = API.PRIVACY_POLICY_URL //"https://matajerapp.com/privacyPolicy"
    override func viewDidLoad() {
        super.viewDidLoad()

        setBackTitle(title: "terms_and_conditions".localized)

        self.edgesForExtendedLayout = UIRectEdge()
        self.extendedLayoutIncludesOpaqueBars = false
        // Do any additional setup after loading the view.
        
        
        self.webView.load(NSURLRequest(url: URL(string: urlValue)!) as URLRequest);
           self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil);
        
        
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
          if keyPath == "estimatedProgress" {

            self.progressView.progress = Float(self.webView.estimatedProgress);
              if self.webView.estimatedProgress != 1 {
                  progressView.isHidden = false
              }else{
                  progressView.isHidden = true
              }

              
          }
      }
      
      
      
      
      override func viewWillAppear(_ animated: Bool) {
         // self.navigationController?.setNavigationBarHidden(false, animated: false)
      }
      
      
      override func viewDidDisappear(_ animated: Bool) {
          //self.navigationController?.setNavigationBarHidden(false, animated: false)

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
