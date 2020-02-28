//
//  WebVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 11/12/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import WebKit
class WebVC: UIViewController {

    
    @IBOutlet weak var webView :WKWebView!
    @IBOutlet weak var progressView: UIProgressView!

    var urlValue = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.load(NSURLRequest(url: URL(string: urlValue)!) as URLRequest);
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil);

        // Do any additional setup after loading the view.
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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    @IBAction func goBack(_ sender :UIButton){
        if self.navigationController != nil && (self.navigationController?.viewControllers.count)! > 1 {
            self.pop()
        }else{
            dismiss(animated: true, completion: nil)
        }
        
    }
}
