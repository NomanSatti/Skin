//
//  SelectDeviceViewController.swift
//  Skins
//
//  Created by Work on 4/11/20.
//  Copyright © 2020 Work. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftMessages

class SelectDeviceViewController: BaseViewController {

  
    @IBOutlet weak var tableView: UITableView!
//    
    var deviceOptions = [DeviceOption]()
    
    var parameters = [String: Any]()
    
    var customImage: UIImage?
   //testig


    override func viewDidLoad() {
        super.viewDidLoad()
       // self.tabBarController?.tabBar.isHidden = true
        print(Defaults.quoteId)
        print(Defaults.customerToken)
        print(Defaults.isPending)
        
        
        
         // print(self.customImage!.toBase64())
        
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Artboard"))
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.setTitleView(imageView, showBackButton: true)
        self.view.backgroundColor = .white
        self.tableView.dataSource = self
        self.tableView.delegate = self
        getAllDevices()
        
    }
    
    private func getAllDevices(){
          NetworkManager.sharedInstance.showLoader()
        let url: String = API_ROOT_DOMAIN + "rest/V1/wallpaper/get-options"
              var request = URLRequest(url:  NSURL(string: url)! as URL)

              // Your request method type Get or post etc according to your requirement
              request.httpMethod = "GET"

              request.setValue("Bearer \(ADMIN_TOKEN)", forHTTPHeaderField: "Authorization")
              request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
        
              Alamofire.request(request).responseJSON { (responseObject) -> Void in

                print(responseObject)
                if let data =  responseObject.result.value {
                    
                    let json = JSON(responseObject.result.value)
                    
                    if let firstItem =  json.arrayValue.first {
                        let response = firstItem["response"]
                        let data = response["data"]
                        let mobiles = data["mobiles"]
                        for mobile in mobiles.arrayValue{
                            let new = try? JSONDecoder().decode(DeviceOption.self, from: mobile.rawData())
                            if new!.name.count != 0 {
                                 self.deviceOptions.append(new!)
                            }
                           
                        }
                          NetworkManager.sharedInstance.dismissLoader()
                        self.tableView.reloadData()
                    }
                    
                 }
            
              }
          }
    
    
    private func addToCart(){
              NetworkManager.sharedInstance.showLoader()
        getNewAuthToken {
            
            let token = UserDefaults.standard.string(forKey: "USERTOKEN")
                 //let token = Defaults.customerToken!
                 print(token)
                 let url: String = API_ROOT_DOMAIN + "rest/V1/carts/mine/items?"
                 var request = URLRequest(url:  NSURL(string: url)! as URL)
                 
                 // Your request method type Get or post etc according to your requirement
                 request.httpMethod = "POST"
                 
                 request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
                 request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                 request.httpBody = try! JSONSerialization.data(withJSONObject: self.parameters)
                 
                 print(self.parameters)
            
                Alamofire.request(request).responseJSON { (responseObject) -> Void in
                     
                     print(responseObject)
                      NetworkManager.sharedInstance.dismissLoader()
                    
                     SwiftMessages.showToast(NSLocalizedString("Item successfully Added To Cart.", comment: ""))
                     self.navigationController?.popToRootViewController(animated: true)
                     
                 }
            }
     
        }
    
    func getNewAuthToken(completionHandler: @escaping ()->()){
        
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
    

    func callingHttp(){

        
        NetworkManager.sharedInstance.callingHttpRequest(params: self.parameters, method: .post, apiname: .addToCart, currentView: UIViewController()) { (i, n) in
            print(i)
            
            print(n)
        }
    }
 
}


extension SelectDeviceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if let lan =  Defaults.language{
            if lan == "ar"{
                return "Select Device Option         "
            } else {
                return "Select Device Option"
            }
        } else {
            return "Select Device Option"
        }
    }
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        if let lan =  Defaults.language{
//            if lan == "ar"{
//                let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
//                header.textLabel?.textAlignment = NSTextAlignment.left
//            }
//        }
//
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deviceOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceSelectionCell", for: indexPath) as! DeviceSelectionCell
        cell.label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.label.font = UIFont.boldSystemFont(ofSize: 18)
        cell.label.text = self.deviceOptions[indexPath.row].name
        
        if let lan =  Defaults.language{
            if lan == "ar"{
                cell.leadingConstraintForArabic?.isActive = true
                cell.leadingConstraintForEnglish?.isActive = false
            } else {
                cell.leadingConstraintForArabic?.isActive = false
                cell.leadingConstraintForEnglish?.isActive = true
            }
        }
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deviceSelected = self.deviceOptions[indexPath.row].name
        
        let cartID = UserDefaults.standard.value(forKey: "cartID") as? Int
        
        self.parameters = [
            "cartItem" : [
                "sku": self.parameters["sku"]!,
                "qty": "1",
                "quote_id": cartID!,
                "extensionAttributes":[
                    "mobile": deviceSelected,
                ]
              ]
            ] as! [String: Any]
        
        
        //print(parameters)
        addToCart()
        //self.callingHttp()
    }
}





struct DeviceOption: Codable {
    let id, name, image, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case createdAt = "created_at"
    }
}

extension UIImage {
    func toBase64() -> String? {
        guard let imageData = self.jpegData(compressionQuality: 1) else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}



class DeviceSelectionCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var leadingConstraintForEnglish: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraintForArabic: NSLayoutConstraint!
}
