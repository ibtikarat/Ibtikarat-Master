//
//  SearchTF.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 20/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class SearchTextField: UITextField {

 
    
    
       override func awakeFromNib() {
            self.delegate = self
            self.returnKeyType = UIReturnKeyType.search
            self.textAlignment = .natural
            
            self.rightView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchSelector)))
    }
       
    
}


extension SearchTextField: UITextFieldDelegate{
    
    @objc func searchSelector(){
        textFieldShouldReturn(self)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField.text!.isEmpty {
                return true
    }
        
    textField.resignFirstResponder()
        
            let storyboard = UIStoryboard(name: "Main2", bundle: nil)
            let search :SearchResultVC = storyboard.instanceVC()
                search.searchValue = self.text!
            AppDelegate.shared.viewController.present(search, animated: false,pushing: true, completion: nil)
 
        return false
    }
}
