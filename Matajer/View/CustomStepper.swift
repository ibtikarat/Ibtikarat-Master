//
//  CustomStepper.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 01/10/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import SDWebImage
class CustomStepper: UIView {

    @IBOutlet weak var checkOne :UIImageView!
    @IBOutlet weak var checkTwo :UIImageView!
    @IBOutlet weak var checkThree :UIImageView!
    @IBOutlet weak var lineOne :UIImageView!
    @IBOutlet weak var lineTwo :UIImageView!

    var steps :Int = 0 {
        didSet{
            
            switch steps {
                case 0:
                              lineOne.image = UIImage(named: "shape_track_line_gap")!
                               lineTwo.image = UIImage(named: "shape_track_line_gap")!
                               checkOne.image = UIImage(named: "ic_track_uncheck")!
                               checkTwo.image = UIImage(named: "ic_track_uncheck")!
                               checkThree.image = UIImage(named: "ic_track_uncheck")!
                    break

                case 1:
                                    lineOne.image = UIImage(named: "shape_track_line_gap")!
                                   lineTwo.image = UIImage(named: "shape_track_line_gap")!
                                   checkOne.image = UIImage(named: "ic_track_check")!.sd_tintedImage(with: UIColor.CustomColor.primaryColor)
                                   checkTwo.image = UIImage(named: "ic_track_uncheck")!
                                   checkThree.image = UIImage(named: "ic_track_uncheck")!
                          break
                
                case 2:
                                   lineOne.image = UIImage(named: "shape_track_line_filled")!.sd_tintedImage(with: UIColor.CustomColor.primaryColor)
                                   lineTwo.image = UIImage(named: "shape_track_line_gap")!
                                   checkOne.image = UIImage(named: "ic_track_check")!.sd_tintedImage(with: UIColor.CustomColor.primaryColor)
                                   checkTwo.image = UIImage(named: "ic_track_check")!
                                   checkThree.image = UIImage(named: "ic_track_uncheck")!
                                    
                                   
                                   
                                   

                            break
                
                
                case 3:
                    lineOne.image = UIImage(named: "shape_track_line_filled")!.sd_tintedImage(with: UIColor.CustomColor.primaryColor)
                                         lineTwo.image = UIImage(named: "shape_track_line_filled")!.sd_tintedImage(with: UIColor.CustomColor.primaryColor)
                                         checkOne.image = UIImage(named: "ic_track_check")!
                                         checkTwo.image = UIImage(named: "ic_track_check")!
                                         checkThree.image = UIImage(named: "ic_track_check")!
                          
                          
                                 // lineOne.tintColor = UIColor.CustomColor.primaryColor
                                 // lineTwo.tintColor = UIColor.CustomColor.primaryColor

                                break
                
                
                
            default:
                lineOne.image = UIImage(named: "shape_track_line_gap")!
                lineTwo.image = UIImage(named: "shape_track_line_gap")!
                checkOne.image = UIImage(named: "ic_track_uncheck")!
                checkTwo.image = UIImage(named: "ic_track_uncheck")!
                checkThree.image = UIImage(named: "ic_track_uncheck")!
                
                break
            }
            
            
        }
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
