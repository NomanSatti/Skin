import Foundation
import Alamofire
import UIKit
import SwiftMessages
import UserNotifications
import SVProgressHUD
import QuickLook
import MobileCoreServices

typealias ServiceResponse = (NSDictionary?, NSError?) -> Void

//let progress = GradientCircularProgress()
//var dataBaseObject = AllDataCollection()

struct UrlParams {
    static let width = String(format: "%f", AppDimensions.screenWidth * UIScreen.main.scale)
    static var defaultWebsiteId = Defaults.websiteId //"1"
}

struct GlobalVariables {
    static var proceedToCheckOut: Bool = false
    static var hometableView: UITableView!
    static var ExecuteShippingAddress: Bool = false
    static var  CurrentIndex: Int = 1
}

class NetworkManager: NSObject {
    
    var languageBundle: Bundle!
    var fileURL: URL!
    static var addressData: StoredAddressData?
    class var sharedInstance: NetworkManager {
        struct Singleton {
            static let instance = NetworkManager()
        }
        return Singleton.instance
    }
    
    func callingHttpRequest(params: [String: Any], method: HTTPMethod, apiname: WhichApiCall, currentView: UIViewController, taskCallback: @escaping (Int,
        AnyObject?) -> Void) {
        let defaults = UserDefaults.standard
        var urlString: String = ""
        if apiname == .chatWithAdmin || apiname == .deleteChatToken {
            urlString = apiname.rawValue
        } else {
            urlString = hostName + apiname.rawValue
        }
        NetworkManager.sharedInstance.removePreviousNetworkCall()
        var dict = [String:Any]()
        if method == .get {
            urlString += "?storeId=" + Defaults.storeId
            urlString += "&quoteId=" + Defaults.quoteId
            urlString += "&currency=" + (Defaults.currency ?? "")
            urlString += "&customerToken=" + (Defaults.customerToken ?? "")
            urlString += "&websiteId=" + UrlParams.defaultWebsiteId
            urlString += "&width=" + UrlParams.width
            for (key, value) in params {
                print(key, value)
                if let value = value as? [String: Any] {
                    urlString += "&\(key)=\(value.convertDictionaryToString()?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
                } else if let value = value as? [Any] {
                    urlString += "&\(key)=\(value.convertArrayToString()?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
                } else {
                    urlString += "&\(key)=\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                }
            }
        } else {
            dict["currency"] = Defaults.currency
            dict["storeId"] = Defaults.storeId
            dict["customerToken"] = Defaults.customerToken
            dict["quoteId"] = Defaults.quoteId
            dict["websiteId"] = UrlParams.defaultWebsiteId
            dict["width"] = UrlParams.width
            for (key, value) in params {
                print(key, value)
                if let value = value as? [String: Any] {
                    dict[key] = value.convertDictionaryToString()
                } else if let value = value as? [Any] {
                    dict[key] = value.convertArrayToString()
                } else {
                    dict[key] = value
                }
            }
        }
        print("auth key", defaults.object(forKey: "authKey") as? String ?? "")
        print("url", urlString)
        
        print("params", dict)
        
        
        var headers: HTTPHeaders = [:]
        if defaults.object(forKey: "authKey") == nil {
            headers = [
                "authKey": ""
            ]
        } else {
            headers = [
                "authKey": defaults.object(forKey: "authKey") as? String ?? ""
            ]
        }

        
        
        
        Alamofire.request(urlString, method: method, parameters: dict, headers: headers).validate().responseJSON { response in
            print("time of api responese:->", response.timeline)
            switch response.result {
            case .success(let resultData):
                let statusCode =  response.response?.statusCode
                print("statusCode", statusCode ?? 0)
                let data = JSON(resultData)
                print(data)
                if data["otherError"].string == "customerNotExist" {
                    self.performUnexpectedLogout()
                    ShowNotificationMessages.sharedInstance.warningView(message: data["message"].stringValue)
                } else {
                    taskCallback(1, resultData as AnyObject)
                }
            case .failure(let error):
                if !Connectivity.isConnectedToInternet() {
                    NetworkManager.sharedInstance.dismissLoader()
                    currentView.view.isUserInteractionEnabled = true
                    let alertController = UIAlertController(title: "Warning".localized, message: error.localizedDescription, preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: "Retry".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                        taskCallback(2, "" as AnyObject)
                    })
                    let noBtn = UIAlertAction(title: "Cancel".localized, style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                    })
                    alertController.addAction(okBtn)
                    alertController.addAction(noBtn)
                    self.topMostController().present(alertController, animated: true, completion: { })
                } else {
                    let statusCode =  response.response?.statusCode
                    let errorCode: Int = error._code
                    let datastring = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                    print(datastring as Any)
                    print(statusCode as Any)
                    if  statusCode == 401 {
                        if let tokenValue = response.response?.allHeaderFields["token"] as? String {
                            let usernamePasswordMd5: String = (apiUserName+":"+apiKey).md5
                            let authkey =  (usernamePasswordMd5+":"+tokenValue).md5
                            defaults.set(authkey, forKey: "authKey")
                            defaults.synchronize()
                            taskCallback(2, "" as AnyObject)
                        }
                    } else if statusCode == 304 {
                        taskCallback(3, "" as AnyObject)
                    } else if errorCode != -999 && errorCode != -1005 {
                        NetworkManager.sharedInstance.dismissLoader()
                        currentView.view.isUserInteractionEnabled = true
                        var message: String = self.getRespectiveName(statusCode: 0)
                        if let statusCode =  response.response?.statusCode {
                            message = self.getRespectiveName(statusCode: statusCode)
                        }
                        let AC = UIAlertController(title: "Warning".localized, message: message, preferredStyle: .alert)
                        let okBtn = UIAlertAction(title: "Retry".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                            taskCallback(2, "" as AnyObject)
                        })
                        let noBtn = UIAlertAction(title: "Cancel".localized, style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                        })
                        AC.addAction(okBtn)
                        AC.addAction(noBtn)
                        self.topMostController().present(AC, animated: true, completion: {  })
                        //                            appvar.window?.rootViewController?.present(nav, animated: true, completion: nil)
                    } else if errorCode == -1005 {
                        NetworkManager.sharedInstance.dismissLoader()
                        taskCallback(2, "" as AnyObject)
                    }
                    /////////////////////////////////////////////
                }
            }
        }
    }
    
    func getHashKey(forView: String, keys: [String]) -> String {
        if keys.count == 0 {
            return forView
        } else {
            var generatedHashkeys: String = forView
            for key in keys {
                generatedHashkeys.append("/\(key)/")
            }
            
            generatedHashkeys = String(generatedHashkeys.dropLast())
            
            return generatedHashkeys
        }
    }
    
    func download(downloadUrl: String, saveUrl: String, completion: ((Bool, JSON) -> Void)?) {
        print(downloadUrl)
        let AC = UIAlertController(title: nil, message: "Your downloading has been started, we will let you know when it'll be finished".localized, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "Ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let file = documentsURL.appendingPathComponent(saveUrl, isDirectory: false)
                return (file, [.createIntermediateDirectories, .removePreviousFile])
            }
            //        Alamofire
            Alamofire.download(downloadUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, to: destination).downloadProgress(closure: { (progress) in
                //progress closure
                print(progress)
            }).response(completionHandler: { (response) in
                print(response)
                if  let url = response.destinationURL {
                    ShowNotificationMessages.sharedInstance.showSuccessActionSnackBar(message: "Your downloading has been completed.Tap on button to view file".localized) { _ in
                        self.fileURL = url
                        let previewController = QLPreviewController()
                        previewController.dataSource = self
                        previewController.delegate = self
                        previewController.modalPresentationStyle = .fullScreen
                        self.topMostController().present(previewController, animated: true)
                        print("jdfkdfkdfdk")
                    }
                } else {
                    print(response.error?.localizedDescription as Any)
                }
                //here you able to access the DefaultDownloadResponse
                //result closure
            })
        })
        AC.addAction(okBtn)
        topMostController().present(AC, animated: true, completion: {  })
    }
    
    func downloadWithPost(downloadUrl: String, saveUrl: String, completion: ((Bool, JSON) -> Void)?) {
        print(downloadUrl)
        let AC = UIAlertController(title: nil, message: "Your downloading has been started, we will let you know when it'll be finished".localized, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "Ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let file = documentsURL.appendingPathComponent(saveUrl, isDirectory: false)
                return (file, [.createIntermediateDirectories, .removePreviousFile])
            }
            //        Alamofire
            Alamofire.download(downloadUrl, method: .post, parameters: nil, encoding: JSONEncoding.default, to: destination).downloadProgress(closure: { (progress) in
                //progress closure
                print(progress)
            }).response(completionHandler: { (response) in
                print(response)
                if  let url = response.destinationURL {
                    ShowNotificationMessages.sharedInstance.showSuccessActionSnackBar(message: "Your downloading has been completed.Tap on button to view file".localized) { _ in
                        self.fileURL = url
                        let previewController = QLPreviewController()
                        previewController.dataSource = self
                        previewController.delegate = self
                        previewController.modalPresentationStyle = .fullScreen
                        self.topMostController().present(previewController, animated: true)
                        print("jdfkdfkdfdk")
                    }
                } else {
                    print(response.error?.localizedDescription as Any)
                }
                //here you able to access the DefaultDownloadResponse
                //result closure
            })
        })
        AC.addAction(okBtn)
        topMostController().present(AC, animated: true, completion: {  })
    }
    
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
    
    
    func getRespectiveName(statusCode: Int?) -> String {
        var message: String = ""
        if statusCode == 404 {
            message = "Something went wrong, Please try again!!".localized
        } else if statusCode == 500 {
            message = "Server Not Found".localized
        } else {
            message = "Something went wrong, Please try again!!".localized
        }
        return message
    }
    
    func getImageFromUrlWithActivity(imageUrl: String, imageView: UIImageView, activity: UIActivityIndicatorView) {
        let urlString = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        imageView.setImage(fromURL: urlString)
    }
    
    func getRealmFileURL() -> String {
        return  "\(String(describing: DBManager.sharedInstance.database?.configuration.fileURL!))"
    }
    
    func remainderNotificationCall() {
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            let requestIdentifier = "appuse" // for multiple notification
            content.badge = 1
            content.title = "pleasevisitourstore".localized
            content.subtitle =  "somenewproduct".localized
            content.body = "checkitwonce".localized
            content.categoryIdentifier = "appuse"
            content.sound = UNNotificationSound.default
            // If you want to attach any image to show in local notification
            let url = Bundle.main.url(forResource: "magento", withExtension: ".png")
            do {
                let attachment = try? UNNotificationAttachment(identifier: requestIdentifier, url: url!, options: nil)
                content.attachments = [attachment!]
            }
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 172800, repeats: false)
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error: Error?) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
            }
        }
    }
    
    func removePreviousNetworkCall() {
        //        print("dismisstheconnection")
        //        let sessionManager = Alamofire.SessionManager.default
        //        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
        //            dataTasks.forEach { $0.cancel() }
        //            uploadTasks.forEach { $0.cancel() }
        //            downloadTasks.forEach { $0.cancel() }
        //        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func checkValidEmail(data: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return (emailTest.evaluate(with: data))
    }
    
    func showLoader() {
        SVProgressHUD.show(withStatus: "Loading...".localized)
    }
    
    func dismissLoader() {
        SVProgressHUD.dismiss()
    }
    
    func json(from object: Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func saveProfileData(type: String, imageData: Data, completion: @escaping ((Bool) -> Void)) {
        NetworkManager.sharedInstance.showLoader()
        let defaults = UserDefaults.standard
        var headers: HTTPHeaders = [:]
        if defaults.object(forKey: "authKey") == nil{
            headers = [
                "apiKey": apiUserName,
                "apiPassword": apiKey,
                "authKey":""
            ]
        }else{
            headers = [
                "apiKey": apiUserName,
                "apiPassword": apiKey,
                "authKey":defaults.object(forKey: "authKey") as! String
            ]
        }
        var imageSendUrl:String = ""
        if (type == "banner") {
            let url = "\(baseDomain)/mobikulhttp/index/uploadBannerPic"
            imageSendUrl = url
        }else {
            let url = "\(baseDomain)/mobikulhttp/index/uploadProfilePic"
            imageSendUrl = url
        }
        DispatchQueue.main.async {
            Alamofire.upload(multipartFormData: { multipartFormData in
                let customerId = Defaults.customerToken
                var params = [String: AnyObject]()
                params["customerToken"] = customerId as AnyObject
                let width = String(format:"%f", AppDimensions.screenWidth * UIScreen.main.scale)
                params["width"] = width as AnyObject
                print(params)
                for (key, value) in params {
                    if let data = value.data(using: String.Encoding.utf8.rawValue) {
                        multipartFormData.append(data, withName: key)
                    }
                }
                multipartFormData.append(imageData, withName: "imageFormKey", fileName: "image.jpg", mimeType: "image/jpeg")
            }, to: imageSendUrl,method:HTTPMethod.post, headers: headers, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload
                        .validate()
                        .responseJSON { response in
                            switch response.result {
                            case .success(let value):
                                print("responseObject: \(value)")
                                let dict = JSON(value)
                                NetworkManager.sharedInstance.dismissLoader()
                                if !dict["success"].boolValue{
                                    //ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                                    completion(false)
                                } else {
                                    if (type == "banner"){
                                        let imageUrl = dict["url"].stringValue
                                        Defaults.profileBanner = imageUrl
                                    }else{
                                        let imageUrl = dict["url"].stringValue
                                        Defaults.profilePicture = imageUrl
                                    }
                                    completion(true)
                                }
                            case .failure(let responseError):
                                ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                                NetworkManager.sharedInstance.dismissLoader()
                                print("responseError: \(responseError)")
                            }
                    }
                case .failure(let encodingError):
                    print("encodingError: \(encodingError)")
                }
            })
        }
    }
    
    func uploadFileToServer(dict: [String:Any], apiCall: WhichApiCall, fileKey: String, fileName: String, fileData: Data, completion: @escaping (Bool, JSON) -> Void) {
        let mimeType = self.mimeTypeForPath(fileName: fileName)
        DispatchQueue.main.async {
            NetworkManager.sharedInstance.showLoader()
            var headers: HTTPHeaders = [:]
            if let authKey = UserDefaults.standard.object(forKey: "authKey") as? String {
                headers = [
                    "apiKey": apiUserName,
                    "apiPassword": apiKey,
                    "authKey": authKey
                ]
            }else{
                headers = [
                    "apiKey": apiUserName,
                    "apiPassword": apiKey,
                    "authKey": ""
                ]
            }
            Alamofire.upload(multipartFormData: { multipartFormData in
                print(dict)
                print(hostName + apiCall.rawValue)
                for (key, value) in dict {
                    var urlString = ""
                    if let value = value as? [String: Any] {
                        do {
                            let jsonData =  try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            let jsonString: String = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                            urlString = jsonString
                        } catch {
                            print(error.localizedDescription)
                        }
                    } else if let value = value as? [Any] {
                        do {
                            let jsonData =  try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            let jsonString: String = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                            urlString = jsonString
                        } catch {
                            print(error.localizedDescription)
                        }
                    } else {
                        urlString = "\(value)"
                    }
                    if let data = urlString.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                        multipartFormData.append(data, withName: key)
                    }
                }
                multipartFormData.append(fileData, withName: fileKey, fileName: fileName, mimeType: mimeType)
                print(multipartFormData)
            }, to: hostName + apiCall.rawValue, method: HTTPMethod.post,
               headers: headers, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload
                        .validate()
                        .responseJSON { response in
                            switch response.result {
                            case .success(let value):
                                let data = JSON(value)
                                print(data)
                                NetworkManager.sharedInstance.dismissLoader()
                                if data["success"].boolValue {
                                    if data["message"].stringValue != "" {
                                        ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: data["message"].stringValue)
                                    }
                                    completion(true, data)
                                } else {
                                    ShowNotificationMessages.sharedInstance.warningView(message: data["message"].stringValue)
                                }
                            case .failure(let responseError):
                                ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                                NetworkManager.sharedInstance.dismissLoader()
                                print("responseError: \(responseError)")
                            }
                    }
                case .failure(let encodingError):
                    ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                    NetworkManager.sharedInstance.dismissLoader()
                    print("encodingError: \(encodingError)")
                }
            })
        }
    }
    
    func uploadMultipleFilesToServer(dict: [String:Any], apiCall: WhichApiCall, fileInfo: [FileInfo], completion: @escaping (Bool, JSON) -> Void) {
        DispatchQueue.main.async {
            NetworkManager.sharedInstance.showLoader()
            var headers: HTTPHeaders = [:]
            if let authKey = UserDefaults.standard.object(forKey: "authKey") as? String {
                headers = [
                    "apiKey": apiUserName,
                    "apiPassword": apiKey,
                    "authKey": authKey
                ]
            }else{
                headers = [
                    "apiKey": apiUserName,
                    "apiPassword": apiKey,
                    "authKey": ""
                ]
            }
            Alamofire.upload(multipartFormData: { multipartFormData in
                var params = dict
//                params["currency"] = Defaults.currency
                params["storeId"] = Defaults.storeId
                params["customerToken"] = Defaults.customerToken
//                params["quoteId"] = Defaults.quoteId
//                params["websiteId"] = UrlParams.defaultWebsiteId
//                params["width"] = UrlParams.width
//                params["type"] = "downloadable"
                print(params)
                print(hostName + apiCall.rawValue)
                for (key, value) in params {
                    var urlString = ""
                    if let value = value as? [String: Any] {
                        urlString = value.convertDictionaryToString()!
                    } else if let value = value as? [Any] {
                        urlString = value.convertArrayToString()!
                    } else {
                        urlString = "\(value)"
                    }
                    if let data = urlString.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                        multipartFormData.append(data, withName: key)
                    }
                }
                for item in fileInfo {
                    let mimeType = self.mimeTypeForPath(fileName: item.fileName)
                    multipartFormData.append(item.fileData, withName: item.fileKey, fileName: item.fileName, mimeType: mimeType)
                }
                print(multipartFormData)
            }, to: hostName + apiCall.rawValue, method: HTTPMethod.post,
               headers: headers, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload
                        .validate()
                        .responseJSON { response in
                            switch response.result {
                            case .success(let value):
                                let data = JSON(value)
                                print(data)
                                NetworkManager.sharedInstance.dismissLoader()
                                if data["success"].boolValue {
                                    if data["message"].stringValue != "" {
                                        ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: data["message"].stringValue)
                                    }
                                    completion(true, data)
                                } else {
                                    ShowNotificationMessages.sharedInstance.warningView(message: data["message"].stringValue)
                                }
                            case .failure(let responseError):
                                ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                                NetworkManager.sharedInstance.dismissLoader()
                                print("responseError: \(responseError)")
                            }
                    }
                case .failure(let encodingError):
                    ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                    NetworkManager.sharedInstance.dismissLoader()
                    print("encodingError: \(encodingError)")
                }
            })
        }
    }
    
    struct AddOnsEnabled {
        static var wishlistEnable = true
        static var reviewEnable = true
        static var emailVerification = true
        static var isEmailVerified = true
        static var allowResetPassword = true
        static var allowSignUp = true
        static var allowGuest = true
        static var is_seller = false
        static var allowShipping = false
        static var allowGdpr = false
    }
    
}

struct FileInfo {
    var fileKey: String
    var fileName: String
    var fileData: Data
    init(fileKey: String, fileName: String, fileData: Data) {
        self.fileKey = fileKey
        self.fileName = fileName
        self.fileData = fileData
    }
}

extension NetworkManager: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let url = fileURL
        return url! as QLPreviewItem
    }
}

extension NetworkManager {
    
    func performUnexpectedLogout() {
        for i in UserDefaults.standard.dictionaryRepresentation() {
            print(i.key)
            if i.key == Defaults.Key.appleLanguages.rawValue || i.key == Defaults.Key.currency.rawValue || i.key == Defaults.Key.deviceToken.rawValue || i.key == Defaults.Key.language.rawValue || i.key == Defaults.Key.storeId.rawValue {
                print("ffs",i.key)
            } else {
                print(i.key)
                UserDefaults.standard.removeObject(forKey: i.key)
                UserDefaults.standard.synchronize()
            }
        }
        self.deleteTokenApi()
    }
    
    func deleteTokenApi() {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        requstParams["userId"] = Defaults.storeId
        requstParams["token"] = Defaults.deviceToken
        requstParams["accountType"] = "customer"
        requstParams["os"] = "ios"
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .post, apiname: .deleteChatToken, currentView: UIViewController()) { success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHome"), object: nil)
            } else if success == 2 {
                NetworkManager.sharedInstance.dismissLoader()
                self.deleteTokenApi()
            }
        }
    }
    
    func mimeTypeForPath(fileName: String) -> String {
        let pathExtension = fileName.components(separatedBy: ".").last ?? ""
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "image/jpeg"
    }
}
