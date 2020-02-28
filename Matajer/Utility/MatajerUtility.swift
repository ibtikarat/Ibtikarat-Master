//
//  SmartSafty.swift
//  SmartSafty
//
//  Created by Abdullah Ayyad on 10/18/19.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class MatajerUtility: NSObject {
    
    
    
    static func isLogin() -> Bool{
        return UserDefaults.standard.object(forKey: "user") != nil 
    }
    
 
    
    
    
    static func saveUser(user :User){
        UserDefaults.standard.set(try! PropertyListEncoder().encode(user), forKey: "user")
    }
    
    
    static func loadUser() -> User?{
        let storedObject: Data? = UserDefaults.standard.object(forKey: "user") as? Data
        if(storedObject != nil){
            guard var user :User? =  try! PropertyListDecoder().decode(User.self, from: storedObject!) else {
                return nil
            }
            return user
        }
        return nil
        
    }
    
    
    
    
    
    static func isFirstTime() -> Bool{
        return UserDefaults.standard.bool(forKey: "first_time")
    }
    
    static func setFirstTime(isNotFirstTime :Bool){
        UserDefaults.standard.set(isNotFirstTime, forKey: "first_time")
    }
    

    static func isSubscribe() -> Bool{
        return UserDefaults.standard.bool(forKey: "subscribe")
    }
    
    static func setIsSubscribe(subscribe :Bool){
        UserDefaults.standard.set(subscribe, forKey: "subscribe")
    }
    
 
    
    
     
    
    
    static func logOut(){
        //let domain = Bundle.main.bundleIdentifier!
        //UserDefaults.standard.removePersistentDomain(forName: domain)
        //UserDefaults.standard.synchronize()
        
        UserDefaults.standard.removeObject(forKey: "user")

    }
    

}
