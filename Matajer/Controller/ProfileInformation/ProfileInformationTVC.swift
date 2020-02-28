//
//  ProfileInformationTVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 08/10/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

protocol UpdateDeletagate{
    func didUpdate()
}



class ProfileInformationTVC: UITableViewController {
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var birthdayLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge()
        
        self.extendedLayoutIncludesOpaqueBars = false
        //self.navigationController?.navigationBar.backItem?.title = "تعديل البروفايل "
        setBackTitle(title: "user_profile".localized)

    }
    
    
    func initData(){
        let user = MatajerUtility.loadUser()
        nameLbl.text = user?.name

        phoneLbl.text = user?.mobile
        birthdayLbl.text = user?.birthday
        genderLbl.text = user?.gender?.localized
        emailLbl.text = user?.email
        
        if AppDelegate.shared.language == "ar"{
            self.tableView.semanticContentAttribute = .forceRightToLeft
        }else{
            self.tableView.semanticContentAttribute = .forceLeftToRight
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        initData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
              
    }

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
            headerView.backgroundColor = UIColor.CustomColor.background
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
                    view.backgroundColor = UIColor.CustomColor.background
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
                    view.backgroundColor = UIColor.CustomColor.background
    }
    
    
     
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let position = (indexPath.section , indexPath.row)
        let dialogStoryboard = UIStoryboard(name: "Dialogs", bundle: nil)
        let user = MatajerUtility.loadUser()

        switch position {
        case (0,0) :
            //change fullName
            let dialog :EditNamePhoneEmailDialogVC = dialogStoryboard.instanceVC()
            dialog.type = .name
            dialog.delegate = self
            dialog.data = user?.name ?? ""

            self.present(dialog, animated: true, completion: nil)
            break

            
                
            case (0,1) :
 
                     let dialog :EditGenderDialogVC = dialogStoryboard.instanceVC()
                     dialog.delegate = self
                    dialog.gender = user?.gender ?? ""
 
                    self.present(dialog, animated: true, completion: nil)
                    break
                    
                
            
            
                
            case (0,2) :
                     let dialog :EditNamePhoneEmailDialogVC = dialogStoryboard.instanceVC()
                    dialog.type = .phone
                    dialog.delegate = self
                    dialog.data = user?.mobile ?? ""
                    self.present(dialog, animated: true, completion: nil)
                    break
                    
            
               case (0,3) :
                        let dialog :EditNamePhoneEmailDialogVC = dialogStoryboard.instanceVC()
                       dialog.type = .email
                       dialog.delegate = self
                       dialog.data = user?.email ?? ""
                       self.present(dialog, animated: true, completion: nil)
                       break
                       
                
            case (0,4) :
                           //change firstName
              let dialog :EditBirthDateDialogVC = dialogStoryboard.instanceVC()
                    dialog.delegate = self
              dialog.date = user?.birthday ?? ""
                     self.present(dialog, animated: true, completion: nil)
                break
                           
        default:
            break
        }
    }
    
    
    
    
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 10
//    }
//
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//         return 10
//    }
//
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
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = super.tableView(tableView, cellForRowAt: indexPath)
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
    
    
}


extension ProfileInformationTVC :UpdateDeletagate{
   
    func didUpdate() {
        initData()
    }
 
}
