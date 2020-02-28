//
//  SizeCVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 15/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class SizeColorCVC: UICollectionViewCell {

    @IBOutlet weak internal var titleLbl: UIButton!

    
    var color :Color? {
        didSet{
            let colorObject = self.color!
            
            UIView.performWithoutAnimation {
                titleLbl.setTitle(colorObject.content, for: .normal)
                titleLbl.setTitleColor(UIColor.black, for: .normal)
                titleLbl.layoutIfNeeded()

                titleLbl.titleLabel?.font = UIFont(name: "BahijTheSansArabic-Plain", size: 12)
            }
            
            if colorObject.isSelected {
                self.selected()
            }else{
                self.notSelected()
            }
        }
    }
    
    
    
    
    var optionContent :OptionContent? {
        didSet{
            let specificationObject = self.optionContent!
            UIView.performWithoutAnimation {
            titleLbl.setTitle(optionContent?.content, for: .normal)
            titleLbl.setTitleColor(UIColor.black, for: .normal)
                titleLbl.layoutIfNeeded()
            }

            if specificationObject.isSelected {
                self.selected()
            }else{
                self.notSelected()
            }
        }
    }
    
    
    
    
       var quantity :String? {
           didSet{
               UIView.performWithoutAnimation {
               titleLbl.setTitle(quantity!, for: .normal)
               titleLbl.setTitleColor(UIColor.black, for: .normal)
                   titleLbl.layoutIfNeeded()
               }

 
           }
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //selected()

    }

    
    
    
    func selected(){
        titleLbl.setRounded(radius: 1)
        titleLbl.setBorder(width: 1, color: UIColor.CustomColor.primaryColor)
        titleLbl.backgroundColor = UIColor.CustomColor.primaryColor
        titleLbl.setTitleColor(UIColor.white, for: .normal)
    }
    
    func notSelected(){
        titleLbl.setRounded(radius: 1)
        titleLbl.setBorder(width: 1, color: UIColor.CustomColor.grayDark)
        titleLbl.backgroundColor = UIColor.white
        titleLbl.setTitleColor(UIColor.black, for: .normal)

    }
    
    
    
}
