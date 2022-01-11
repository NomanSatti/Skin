//
//  CheckOutManager.swift
//  Skins
//
//  Created by Work on 3/21/20.
//  Copyright © 2020 Work. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire


class OrderProcessManager {
    
    class func getMyCartData(completionHandler: @escaping (JSON?) -> ()) {
        
        self.getNewAuthToken {
            if UserDefaults.fetch(key: Defaults.Key.customerToken.rawValue) != nil {
                
                let token = UserDefaults.standard.string(forKey: "USERTOKEN")
              //  let token2 = Defaults.auth
                let url: String = API_ROOT_DOMAIN + "rest/V1/carts/mine?"
                var request = URLRequest(url:  NSURL(string: url)! as URL)
                
                // Your request method type Get or post etc according to your requirement
                request.httpMethod = "GET"
                
                request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                
                Alamofire.request(request).responseJSON { (responseObject) -> Void in
            //        print(responseObject)
                    if let value =  responseObject.result.value{
                        let json = JSON(value)
                        print(json)
                        
                        
                        
                        if let cartID = json["id"].int {
                            print(cartID)
                            UserDefaults.standard.set(cartID, forKey: "cartID")
                            completionHandler(JSON(value))
                        }else{
                            createNewCart { (id) in
                                completionHandler(nil)
                            }
                        }
                    }else{
                        print(responseObject)
                        completionHandler(nil)
                    }
                    
                }
                
            }
        }
     
    }
    
    class func createNewCart(completionHandler: @escaping (Int?) -> ()){
        
        if UserDefaults.fetch(key: Defaults.Key.customerToken.rawValue) != nil {
            
            let token = UserDefaults.standard.string(forKey: "USERTOKEN")
            let url: String = API_ROOT_DOMAIN + "rest/V1/carts/mine?"
            var request = URLRequest(url:  NSURL(string: url)! as URL)
            
            // Your request method type Get or post etc according to your requirement
            request.httpMethod = "POST"
            
            request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            Alamofire.request(request).responseJSON { (responseObject) -> Void in
                
                if let value =  responseObject.result.value{
                    let json = JSON(value)
                    UserDefaults.standard.set("\(json.intValue)", forKey: "CartID")
                    completionHandler(json.intValue)
                }else{
                    print(responseObject)
                    completionHandler(nil)
                }
                
            }
        }
        
        
    }
    
    
    
    
    class func getNewAuthToken(completionHandler: @escaping ()->()){
        
     if UserDefaults.fetch(key: Defaults.Key.customerToken.rawValue) != nil{
          
           // let userName = Defaults.customerEmail
          //  let password = Defaults.c
        
        let url: String = API_ROOT_DOMAIN + "rest/V1/integration/customer/token"
        var request = URLRequest(url:  NSURL(string: url)! as URL)
        
        
        // Your request method type Get or post etc according to your requirement
        request.httpMethod = "POST"
        
        request.setValue("Bearer \(ADMIN_TOKEN)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let useremail = Defaults.customerEmail
        let password  = UserDefaults.standard.string(forKey: "loginUserPassword")
        let parameters = [
            "username": useremail,
            "password": password
        ]
        
        print(useremail! + password!)
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters )
        
        Alamofire.request(request).responseJSON { (response) -> Void in
            
            if let value = response.value, value is String {
                let token = value as! String
                print(token)
                UserDefaults.standard.set(true, forKey: "isLogined")
                UserDefaults.standard.set(token, forKey: "USERTOKEN")
                completionHandler()
            }
            
        }
        
        }
    }
    
    
    
    
}

class CartImageManager {
    class func getProductMedia(sku: String, completionHandler:@escaping (String?) -> ()){
        
       
       // let trimmedString = sku.trimmingCharacters(in: .whitespaces)
        //l/et newsku = trimmedString.removingWhitespaces()
      
        let string = API_ROOT_DOMAIN + "rest/V1/products/\(sku)/media"
        
        var urlString = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        print(urlString)
        //var urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
     
        
       
        
        var request = URLRequest(url:  NSURL(string: urlString!)! as URL)
        
        // Your request method type Get or post etc according to your requirement
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(ADMIN_TOKEN)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        Alamofire.request(request).responseJSON { (responseObject) -> Void in
            
            
            
            if let data =  responseObject.result.value {
                let json = JSON(data)
                if let first = json.arrayValue.first{
                    
                    completionHandler(first["file"].stringValue)
                }else{
                    completionHandler(nil)
                }
                
                
            }
            
        }
        
    }
}

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
