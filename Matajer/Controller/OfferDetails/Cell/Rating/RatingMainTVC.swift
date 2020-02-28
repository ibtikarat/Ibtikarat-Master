//
//  RatingMainTVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 04/10/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import Cosmos

class RatingMainTVC: UITableViewCell {

    
    @IBOutlet weak var totalRatingLbl :UILabel!//
  
    @IBOutlet weak var avgRatingLbl :UILabel!
  
    @IBOutlet weak var oneLbl :UILabel!
    @IBOutlet weak var oneProgress :UIProgressView!
    
    @IBOutlet weak var twoLbl :UILabel!
    @IBOutlet weak var twoProgress :UIProgressView!
    
    @IBOutlet weak var threeLbl :UILabel!
    @IBOutlet weak var threeProgress :UIProgressView!
    
    @IBOutlet weak var fourLbl :UILabel!
    @IBOutlet weak var fourProgress :UIProgressView!
    
    @IBOutlet weak var fiveLbl :UILabel!
    @IBOutlet weak var fiveProgress :UIProgressView!
    
    @IBOutlet weak var rateView :CosmosView!

    
    var avgValue :Double? {
        didSet{
            rateView.rating = avgValue!
            avgRatingLbl.text = avgValue!.description
        }
    }
    
    var rateCount :RatesCounts? {
        didSet{
            totalRatingLbl.text = rateCount?.total.description
            
            oneLbl.text = rateCount?.one.description
            twoLbl.text = rateCount?.two.description
            threeLbl.text = rateCount?.three.description
            fourLbl.text = rateCount?.four.description
            fiveLbl.text = rateCount?.five.description
            
            oneProgress.progress = rateCount!.total == 0 ? 0.0 :  Float(rateCount!.one) / Float(rateCount!.total)
            twoProgress.progress = rateCount!.total == 0 ? 0.0 : Float(rateCount!.two) / Float(rateCount!.total)
            threeProgress.progress = rateCount!.total == 0 ? 0.0 : Float(rateCount!.three) / Float(rateCount!.total)
            fourProgress.progress = rateCount!.total == 0 ? 0.0 : Float(rateCount!.four) / Float(rateCount!.total)
            fiveProgress.progress = rateCount!.total == 0 ? 0.0 : Float(rateCount!.five) / Float(rateCount!.total)
//            
            totalRatingLbl.text = Int(rateCount!.total).description + "rate".localized
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
