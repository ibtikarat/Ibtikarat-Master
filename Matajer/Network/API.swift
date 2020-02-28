//
//  API.swift
//  SmartSafty
//  
//  Created by Abdullah Ayyad on 3/18/19.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation
import Alamofire

enum API {
    //to see output into command text
    private static let DEBUG = true
    private  static let TAG = "API - Service "
    
    
    static let APP_ID = "nvb7w4me00woekt"
    //    static let APP_ID = "e9a4wwy59etoi7h"
    
    
    static let FIREBASE_SUBSCRIBE_iosArTopic = "iosArTopic-\(APP_ID)";
    static let DOMAIN_URL = "https://matajerapp.com/api/v1/\(APP_ID)/";
    static let PRIVACY_POLICY_URL = "https://matajerapp.com/api/v1/\(APP_ID)/privacy?lang=\(AppDelegate.shared.language)";
    
    static let appStore = "itms-apps://apps.apple.com/us/app/%D8%A8%D9%8A%D8%AA-%D8%A7%D9%84%D8%B9%D8%B1%D9%88%D8%B3/id1333190404?l=\(AppDelegate.shared.language)"
    static let ituneStore = "itms://apps.apple.com/us/app/%D8%A8%D9%8A%D8%AA-%D8%A7%D9%84%D8%B9%D8%B1%D9%88%D8%B3/id1333190404?l=\(AppDelegate.shared.language)"
    
    
    //auth
    case LOGIN
    case LOGOUT
    case REGISTER
    case FORGOT
    case RESET_PASSWORD
    
    //User
    case FETCH_USER //(deprecated)
    case UPDATE_USER //(deprecated)
    case UPDATE_PASSWORD //(deprecated)
    
    case UPDATE_PROFILE
    
    
    
    //main
    case HOME
    case TAB_MOST_ORDER
    case TAB_OFFERS
    case TAB_BRANDS
    case TAB_RECENTLY_ARRIVED
    
    //category
    case MAIN_CATEGORY
    case CATEGORY_DETAILS //(deprecaed)
    
    
    //details_product
    case PRODUCT_DETAILS
    
    //tradeMark product by id
    case PRODUCTS_BY_TRADE_MARK
    //category product by id
    case PRODUCTS_BY_CATEGROY
    //subCategory  product by id
    case PRODUCTS_BY_SUB_CATEGROY
    
    
    
    
    //favorites
    case MY_FAVORITES
    case ADD_FAVORITES
    case REMOVE_FAVORITES
    
    
    //Address
    case MY_ADDRESS
    case ADD_ADDRESS
    case UPDATE_ADDRESS
    case REMOVE_ADDRESS
    
    //BankTransfare
    case BANKS_ACCOUNTS
    case ADD_BANKTRANSFER
    
    //notifications
    case NOTIFICATIONS //deprecated
    case PUBLIC_NOTIFICATIONS //deprecated
    case ALL_NOTIFICATIONS
    case UNREAD_NOTIFICATIONS
    case SET_NOTIFICATION
    
    //rating
    case RATINGS
    case ADD_RATINGS
    
    
    //AppData
    case CONTACT_US
    case APP_CONTENTS
    
    case SHIPPING_METHODS
    
    case COUPON
    
    
    //Order
    case ORDER
    case ORDER_DETAILS
    case RE_ORDER
    case ORDER_NEW
    case ORDER_PROCESSING
    case ORDER_COMPLETED
    case ORDER_REJECTED
    case ADD_ORDER_REQUIRED_DATA
    case CONFIRM_ORDER_PAYMENT
    //
    case INVOICE
    
    
    //search
    case SEARCH
    
    
    //FILTER
    case FILTER_ITEMS
    case PRODUCTS_FILTER
    
    
    
    private var values : (url: String ,reqeustType: HTTPMethod,key :String?){
        get{
            switch self {
            case .LOGIN:
                return (API.DOMAIN_URL + "login",.post,nil)
                
            case .LOGOUT:
                return (API.DOMAIN_URL + "logout",.get,nil)
                
            case .REGISTER:
                return (API.DOMAIN_URL + "register",.post,nil)
                
            case .FORGOT:
                return (API.DOMAIN_URL + "password/forgot",.post,nil)
                
            case .RESET_PASSWORD:
                return (API.DOMAIN_URL + "password/reset",.put,nil)
                
            case .FETCH_USER:
                return (API.DOMAIN_URL + "user",.get,nil)
                
            case .UPDATE_USER:
                return (API.DOMAIN_URL + "updateuser",.post,nil)
                
            case .UPDATE_PASSWORD:
                return (API.DOMAIN_URL + "updatepassword",.post,nil)
                
            case .HOME:
                return (API.DOMAIN_URL + "home",.get,nil)
                
            case .TAB_MOST_ORDER:
                return (API.DOMAIN_URL + "products/mostOrdered",.get,nil)
                
            case .TAB_OFFERS:
                return (API.DOMAIN_URL + "products/offers",.get,nil)
                
            case .TAB_BRANDS:
                return (API.DOMAIN_URL + "tradeMarks",.get,nil)
                
            case .TAB_RECENTLY_ARRIVED:
                return (API.DOMAIN_URL + "products/recentlyArrived",.get,nil)
                
            case .MAIN_CATEGORY:
                return (API.DOMAIN_URL + "mainCategories",.get,nil)
                
            case .CATEGORY_DETAILS:
                return (API.DOMAIN_URL + "mainCategory/",.get,"nested")
                
            case .PRODUCT_DETAILS:
                return (API.DOMAIN_URL + "product/",.get,"nested")
                
                
                
            case .MY_FAVORITES:
                return (API.DOMAIN_URL + "favorites",.get,"")
                
                
                
            case .ADD_FAVORITES:
                return (API.DOMAIN_URL + "favorite",.post,"")
                
                
                
            case .REMOVE_FAVORITES:
                return (API.DOMAIN_URL + "product/",.delete,"nested")
                
                
            case .MY_ADDRESS:
                return (API.DOMAIN_URL + "deliveryAddresses",.get,"")
                
            case .ADD_ADDRESS:
                return (API.DOMAIN_URL + "deliveryAddresses",.post,"")
                
                
            case .UPDATE_ADDRESS:
                return (API.DOMAIN_URL + "deliveryAddresses/",.put,"nested")
                
            case .REMOVE_ADDRESS:
                return (API.DOMAIN_URL + "deliveryAddresses/",.delete,"nested")
                
                
                
                
            case .PRODUCTS_BY_TRADE_MARK:
                return (API.DOMAIN_URL + "tradeMark/",.get,"nested")
                
            case .PRODUCTS_BY_CATEGROY:
                return (API.DOMAIN_URL + "mainCategory/",.get,"nested")
                
            case .PRODUCTS_BY_SUB_CATEGROY:
                return (API.DOMAIN_URL + "subCategory/",.get,"nested")
                
                
                
            case .BANKS_ACCOUNTS:
                return (API.DOMAIN_URL + "banksAccounts",.get,"")
                
                
            case .ADD_BANKTRANSFER:
                return (API.DOMAIN_URL + "order/",.post,"nested")
                
                
                
            case .UPDATE_PROFILE:
                return (API.DOMAIN_URL + "profile",.put,"")
                
            case .NOTIFICATIONS:
                return (API.DOMAIN_URL + "notifications",.get,"")
                
            case .ALL_NOTIFICATIONS:
                return (API.DOMAIN_URL + "allNotifications",.get,"")
                
                
            case .SET_NOTIFICATION:
                return (API.DOMAIN_URL + "notification/",.put,"nested")
                
            case .UNREAD_NOTIFICATIONS:
                return (API.DOMAIN_URL + "unreadNotifications",.get,"")
                
                
            case .RATINGS:
                return (API.DOMAIN_URL + "ratings",.get,"")
                
            case .ADD_RATINGS:
                return (API.DOMAIN_URL + "product/",.post,"")
                
                
                
            case .CONTACT_US:
                return (API.DOMAIN_URL + "contactUs",.post,"")
                
            case .APP_CONTENTS:
                return (API.DOMAIN_URL + "appContents",.get,"")
                
            case .SHIPPING_METHODS:
                return (API.DOMAIN_URL + "shippingMethods",.get,"")
                
            case .COUPON:
                return (API.DOMAIN_URL + "coupon",.post,"")
                
            case .ORDER:
                return (API.DOMAIN_URL + "order",.post,"")
                
            case .ORDER_DETAILS:
                return (API.DOMAIN_URL + "order/",.get,"nested")
                
            case .ORDER_NEW:
                return (API.DOMAIN_URL + "orders/new",.get,"")
                
            case .ORDER_PROCESSING:
                return (API.DOMAIN_URL + "orders/processing",.get,"")
                
            case .ORDER_COMPLETED:
                return (API.DOMAIN_URL + "orders/completed",.get,"")
                
            case .ORDER_REJECTED:
                return (API.DOMAIN_URL + "orders/rejected",.get,"")
                
            case .ADD_ORDER_REQUIRED_DATA:
                return (API.DOMAIN_URL + "addOrderRequiredData",.get,"")
                
            case .CONFIRM_ORDER_PAYMENT:
                return (API.DOMAIN_URL + "confirmOrderPayment",.post,"")
                
            case .INVOICE:
                return (API.DOMAIN_URL + "order/",.get,"nested")
                
            case .SEARCH:
                return (API.DOMAIN_URL + "search",.get,"")
                
                
            case .FILTER_ITEMS:
                return (API.DOMAIN_URL + "filterItems",.get,"")
                
            case .PRODUCTS_FILTER:
                return (API.DOMAIN_URL + "productsFilter",.post,"")
                
            case .RE_ORDER:
                return (API.DOMAIN_URL + "reorder",.post,"")
                
            case .PUBLIC_NOTIFICATIONS:
                return (API.DOMAIN_URL + "publicNotifications",.get,"")
            }
        }
    }
    
    
    
    
    func startRequest(uiViewController:UIViewController? = nil,showIndicator:Bool = false ,nestedParams :String = "",params :[String:String] = [:],header : [String:String] = [:],completion : @escaping (API,StatusResult)->Void){
        var params = params;
        var header = header
        var nestedParams = nestedParams
        ////
        //for sorted
        if self == .TAB_OFFERS || self == .TAB_MOST_ORDER || self == .TAB_RECENTLY_ARRIVED || self == .PRODUCTS_BY_TRADE_MARK || self == .PRODUCTS_BY_CATEGROY  || self == .SEARCH || self == .PRODUCTS_BY_SUB_CATEGROY{
            if AppDelegate.shared.sortedBy != SortedDialogVC._default {
                params["orderBy"] = AppDelegate.shared.sortedBy
            }
        }
        /////
        header["Accept"] = "application/json"
        header["Accept-Language"] = AppDelegate.shared.language
        
        if let authToken = MatajerUtility.loadUser()?.apiToken {
            header["Authorization"] = "Bearer \(authToken)"
            
            
            //            header["Authorization"] = "Bearer 2hbSdqIovcyW7QyvaROthfHkPz9UgXeFu9DabEw8u7QH9UQNccipQw510wkLSDOzAp6NDHzNaoallq9R2UJHevykFU3VQO0fSXjQfmLH7VjoeTdiAZH27OCBkIyhXw3aUYZrcJjHMrNdVk7IzwDtEZWFNu4lgrM83AeZCWh3R2NOKYRKZsnrggvg6EOpbreuiXnPIrC7XfVpyIe5QNj3TyZJz9h7yL3Ppt1edwrYYrKOf2UUTZUIbamL3xhiXok9UxBjTjpBv6GWoHrWOkL59T5yNoRmzxrDl4h3SyJJP8R79eeON1sgdVBXkP0d6mcbd33K0TAjBxQ1KcCBYIkwL2RCSCDxbOM2a4VfkLQMtmU2uLZe9c0LplYLCc0XirSg8G8QCb9LzuX7ZRxrJ3zLFrzsdkGyKyyvQkeNgiwhbMMq6lmF0gZ8TLYnJVN2Dd1VwPByK1PHz0WuAaKGsd0tuzp1YSC5KYZ8"
        }
        
        
        //              header["Authorization"] = "Bearer 2hbSdqIovcyW7QyvaROthfHkPz9UgXeFu9DabEw8u7QH9UQNccipQw510wkLSDOzAp6NDHzNaoallq9R2UJHevykFU3VQO0fSXjQfmLH7VjoeTdiAZH27OCBkIyhXw3aUYZrcJjHMrNdVk7IzwDtEZWFNu4lgrM83AeZCWh3R2NOKYRKZsnrggvg6EOpbreuiXnPIrC7XfVpyIe5QNj3TyZJz9h7yL3Ppt1edwrYYrKOf2UUTZUIbamL3xhiXok9UxBjTjpBv6GWoHrWOkL59T5yNoRmzxrDl4h3SyJJP8R79eeON1sgdVBXkP0d6mcbd33K0TAjBxQ1KcCBYIkwL2RCSCDxbOM2a4VfkLQMtmU2uLZe9c0LplYLCc0XirSg8G8QCb9LzuX7ZRxrJ3zLFrzsdkGyKyyvQkeNgiwhbMMq6lmF0gZ8TLYnJVN2Dd1VwPByK1PHz0WuAaKGsd0tuzp1YSC5KYZ8"
        
        var httpHeader = HTTPHeaders(header)
        if API.DEBUG {
            printRequest(nested: nestedParams,params: params, header: header)
        }
        
        let currentViewCountroller = AppDelegate.shared.viewController
        
        currentViewCountroller.isInterntConnected(){_ in
            self.startRequest(nestedParams:nestedParams,params: params, completion:completion)
        }
        
        if showIndicator{
            currentViewCountroller.showIndicator()
        }
        
        startRequest(api: self,nestedParams: nestedParams,params: params,header: httpHeader) { (result,status,message) in
            if API.DEBUG {
                self.printResponse(result: result)
            }
            
            if showIndicator{
                currentViewCountroller.hideIndicator()
            }
            
            let statusResult = StatusResult(json: result)
            
            if !status {
                statusResult.isSuccess = status
                statusResult.errorMessege = message
            }
            
            
            if statusResult.statusCode == 401 {
                currentViewCountroller.singOutWithPermently(message: statusResult.errorMessege)
            }else{
                completion(self,statusResult)
            }
        }
    }
    
    private func printRequest(nested :String, params :[String:String] = [:],header : [String:String] = [:]){
        print(API.TAG + "url : \(self.values.url)/\(nested)" )
        print(API.TAG + "params : \(params)" )
        print(API.TAG + "header : \(header)" )
        
    }
    
    private func printResponse(result: [String:Any]) {
        print(API.TAG + "result : \(result)" )
    }
    
    
    private func startRequest(api :API,nestedParams :String = "",params : [String:String] = [:],header: HTTPHeaders = [:], completion:@escaping ([String:Any],Bool,String)->Void){
        
        AF.request(api.values.url+nestedParams, method: api.values.reqeustType, parameters: params.isEmpty ? nil:params,encoding: URLEncoding.default, headers: header.isEmpty ? nil:header)
            //.validate(statusCode: 200..<600)
            .responseJSON { response  in
                if API.DEBUG {
                    if let statusCode = response.response?.statusCode {
                        print(API.TAG + "status code : \(statusCode)" )
                    }
                }
                switch(response.result)
                {
                case .success(let value):
                    if let resp = value as? [String:Any] {
                        completion(resp,true,"")
                    }else {
                        completion([:],false,"no data was found in response")
                    }
                    if API.DEBUG {
                        debugPrint(value)
                    }
                case .failure(let error) :
                    if API.DEBUG {
                        print(response.error.debugDescription)
                        print(error.errorDescription)
                        
                    }
                    completion([:],false,error.localizedDescription)
                }
                
        }
    }
    
    
    
    
    
    ///file
    
    func startRequestWithFile(uiViewController:UIViewController? = nil,showIndicator:Bool = false,nestedParams :String = "" ,params :[String:String] = [:],data :[String:Data] = [:],headers : [String:String] = [:],completion : @escaping (API,StatusResult)->Void){
        var params = params;
        var headers = headers;
        
        headers["Accept"] = "application/json"
        headers["Accept-Language"] = AppDelegate.shared.language
        
        if let authToken = MatajerUtility.loadUser()?.apiToken {
            headers["Authorization"] = "Bearer \(authToken)"
        }
        
        
        
        if API.DEBUG {
            printRequest(nested: nestedParams, params: params, header: headers)
            print("data size 'file Numbers' \(data.count)")
            
        }
        
        let currentViewCountroller = AppDelegate.shared.viewController
        
        if  !currentViewCountroller.isConnectedToNetwork() {
            currentViewCountroller.isInterntConnected(){_ in
                self.startRequest(params: params, completion:completion)
            }
            return
        }
        
        
        if showIndicator{
            currentViewCountroller.showIndicator()
        }
        
        startRequest(api: self,nestedParams :nestedParams ,params: params,data: data,headers: HTTPHeaders(headers)) { (result,status,message) in
            if API.DEBUG {
                self.printResponse(result: result)
            }
            
            if showIndicator{
                currentViewCountroller.hideIndicator()
            }
            
            let statusResult = StatusResult(json: result)
            
            if !status {
                statusResult.isSuccess = status
                statusResult.errorMessege = message
            }
            completion(self,statusResult)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    private func startRequest(api :API,nestedParams :String = "",params : [String:String] = [:],data : [String:Data] = [:],headers: HTTPHeaders = [:], completion:@escaping ([String:Any],Bool,String)->Void){
        print("full domain \(api.values.url + nestedParams)")
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key )
            }
            
            
            for (key, value) in data {
                multipartFormData.append(value, withName: key,fileName: "\(key).jpg", mimeType: "image/jpeg")
            }
            
        }, to: api.values.url + nestedParams , method:api.values.reqeustType ,headers: headers).uploadProgress {(progress) in
            print("file upload progress \(progress)%")
            
        }.responseJSON { (response) in
            
            if API.DEBUG {
                if let statusCode = response.response?.statusCode {
                    print(API.TAG + "status code : \(statusCode)" )
                }
            }
            
            switch(response.result)
            {
            case .success(let value):
                if let resp = value as? [String:Any] {
                    completion(resp,true,"")
                }else {
                    completion([:],false,"no data was found in response")
                }
                if API.DEBUG {
                    debugPrint(value)
                }
            case .failure(let error) :
                if API.DEBUG {
                    print(response.error.debugDescription)
                    print(error.errorDescription)
                    
                }
                completion([:],false,error.localizedDescription)
            }
            
            
        }
    }
    
    
    
}
