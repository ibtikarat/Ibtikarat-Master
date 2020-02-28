//
//  SettingTVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 22/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class SettingTVC: UITableViewController {

    
    @IBOutlet weak var flagImageView :UIImageView!
    
    var selectedSector = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        flagImageView.image = AppDelegate.shared.language == "ar" ? UIImage(named: "ic_profile_saudi_ar") : UIImage(named: "ic_profile_uk")
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
                selectedSector = indexPath.section

        return indexPath
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        

        
        
        if indexPath.row == 0 && indexPath.section == 3 {
            let whatsAppNumber = AppDelegate.shared.appContent?.whatsaap

            guard let whatsAppUrl = URL(string: "whatsapp://send?phone=\(whatsAppNumber!)&text="),
               case let application = UIApplication.shared, application.canOpenURL(whatsAppUrl)
            else {
                self.showOkAlert(title: "", message: "you_dont_have_whatsapp_app".localized)
                return
            }
            application.openURL(whatsAppUrl)
        }
        
       
        
        if indexPath.row == 3 && indexPath.section == 2 {
            let dialogStoryboard = UIStoryboard(name: "Dialogs", bundle: nil)
            let dialog :LanguageDialoge = dialogStoryboard.instanceVC()
            self.present(dialog, animated: true, completion: nil)
        }
        
        if indexPath.row == 0 && indexPath.section == 4 {
            self.singOut()
        }
        
        selectedSector = indexPath.section
 
        
        
        
        
    }
    
 
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if selectedSector == 2 {
              if !MatajerUtility.isLogin() {
                          self.signIn()
                          return false
            }
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.CustomColor.background
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "BahijTheSansArabic-SemiBold", size: 16)
        header.backgroundColor = UIColor.CustomColor.background

    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.CustomColor.background
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "BahijTheSansArabic-SemiBold", size: 16)
        header.backgroundColor = UIColor.CustomColor.background

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
              var cell = super.tableView(tableView, heightForRowAt: indexPath)
        
        if !MatajerUtility.isLogin() {
            if indexPath.section == 4 {
                    return 0
                }
        }
        
                return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
       // print("Identifier" , cell.textLabel!.accessibilityIdentifier)
        if let label = cell.textLabel, let id = label.accessibilityIdentifier, id.count > 0 {
            let key = id + ".text"
            let localizedString = NSLocalizedString(key, tableName: "Main", comment: "")
            if key != localizedString {
                label.text = localizedString
                
                if AppDelegate.shared.language == "ar" {
                    label.textAlignment = .right
                }else{
                    label.textAlignment = .left
                }
            }
        }
        return cell
    }
    
    
    
    
    
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        var cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
//
//        if cell == self.cellYouWantToHide {
//            return 0
//        }
//
//        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
//    }
}
