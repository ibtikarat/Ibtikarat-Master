//
//  TabBar.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 08/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class TabBar: UITabBar {
    private var cachedSafeAreaInsets = UIEdgeInsets.zero
    
    override var safeAreaInsets: UIEdgeInsets {
        let insets = super.safeAreaInsets
        if insets.bottom < bounds.height {
            cachedSafeAreaInsets = insets
        }
        
        return cachedSafeAreaInsets
    }
}
