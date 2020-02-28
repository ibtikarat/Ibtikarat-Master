//
//  FloatingPoint+Extension.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 15/12/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation
extension FloatingPoint {
  var isInteger: Bool { get{return rounded() == self} }
}
