//
//  UIImage.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 14/12/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

extension UIImage {

    func imageWithColorOld(color: UIColor) -> UIImage? {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

 

}
