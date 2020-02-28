//
//  AboutVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 25/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import MessageUI
class AboutVC: UIViewController ,MFMailComposeViewControllerDelegate{

    
    @IBOutlet weak var contactUs :UIView!
    
    @IBOutlet weak var infoTextContentLbl :UILabel!
    
    
    @IBOutlet weak var emailBtn :UIButton!
    @IBOutlet weak var phoneBtn :UIButton!
    @IBOutlet weak var webBtn :UIButton!
    
    var appContent :AppContent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appContent = AppDelegate.shared.appContent
        //edgesForExtendedLayout = []
        self.edgesForExtendedLayout = UIRectEdge()
        self.extendedLayoutIncludesOpaqueBars = false
//        self.navigationController?.navigationBar.backItem?.title = "عن سمارت سيفتي"

        setBackTitle(title: "about_smart_safety".localized)

        
        infoTextContentLbl.text = appContent.aboutApp.htmlAttributedString!.string
        
        
        contactUs.isUserInteractionEnabled = true
        contactUs.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openContactUs)))
  
        
        
 
        emailBtn.setTitle(appContent?.email, for: .normal)
        phoneBtn.setTitle(appContent?.phone, for: .normal)
        webBtn.setTitle(appContent?.websiteURL, for: .normal)
    }
    

   @objc func openContactUs(){
        let vc :ContactUsVC = self.storyboard!.instanceVC()
        present(vc, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
 
    
    @IBAction func callAction(_ sender :UIButton){
        let mobileNumber = appContent.phone
        
        if let url = URL(string: "tel://\(mobileNumber)") {
              UIApplication.shared.openURL(url)
        }
        
        
    }
    
    @IBAction func openURl(_ sender :UIButton){
        let websiteURL = appContent.websiteURL
        if let link = URL(string: websiteURL) {
          UIApplication.shared.open(link)
        }
    }
    
    
    @IBAction func sendEmail(_ sender :UIButton){
        let email = appContent.email
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["\(email)"])
            mail.setMessageBody("<p></p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }

    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
}
