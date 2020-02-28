//
//  Array.swift
//  SmartSafty
//
//  Created by Abdullah Ayyad on 10/27/19.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation

extension Array {
    
    func filterDuplicates(includeElement: (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        var results = [Element]()
        
        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        
        return results
    }
}

