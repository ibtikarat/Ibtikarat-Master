//
//  BankTVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 08/10/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import SDWebImage
class BankTVC: UITableViewCell {

    @IBOutlet weak var holderNameLbl: UILabel!
    @IBOutlet weak var accountNumberLbl: UILabel!
    @IBOutlet weak var ibanNumberLbl: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    
    var bankAccount :BankAccount? {
        didSet{
            let bankAcc = bankAccount
            
            holderNameLbl.text = "\("name".localized) : \(bankAcc!.holderName)"
            accountNumberLbl.text = "\("account_number".localized) : \(bankAcc!.number)"
            ibanNumberLbl.text = "\("iban".localized) : \(bankAcc!.iban)"
            imageV.sd_setImage(with: URL(string: bankAcc!.img), completed: nil)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
