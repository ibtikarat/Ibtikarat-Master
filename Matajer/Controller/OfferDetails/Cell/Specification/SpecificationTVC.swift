//
//  SpecificationTVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 25/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class SpecificationTVC: UITableViewCell {

    
    @IBOutlet weak var titleContainerView : UIView!
    @IBOutlet weak var descriptionContainerView : UIView!
    
    @IBOutlet weak var titleLbl : UILabel!
    @IBOutlet weak var descriptionLbl : UILabel!
    
    var indexPath :IndexPath? {
        didSet{
            if (indexPath!.row % 2) == 0 {
                setGrayBackground()

            }else{
                setWihteBackground()

            }
        }
    }
    
    var specification :Specification? {
        didSet{
            titleLbl.text = specification?.key
            descriptionLbl.text = specification?.value
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
    
    
    
    
    
    func setGrayBackground(){
        titleContainerView.backgroundColor = UIColor.init(rgb: 0xF6F6F6)
        descriptionContainerView.backgroundColor = UIColor.init(rgb: 0xF6F6F6)
    }
    
    
    func setWihteBackground(){
        titleContainerView.backgroundColor = UIColor.white
        descriptionContainerView.backgroundColor = UIColor.white

    }
}
