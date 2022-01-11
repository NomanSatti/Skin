//
//  LoginUserHelper.swift
//  Skins
//
//  Created by Work on 2/26/20.
//  Copyright © 2020 Work. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

typealias CurrentUser = LoggedInUserHelper

let UserInfoFileName = "UserInfo.dat"

open class LoggedInUserHelper: NSObject {

    //MARK:- Shared Instance
    static let sharedInstance = LoggedInUserHelper()
    
    //MARK:- Internal/Private Variables
    open var user: [String: Any]?
    open var token: String?
    open var name: String?
    open var userId: String?
    open var email: String?
   // open var myPatients: [String: Any]?
    open var imageToUpload: UIImage?
    
    var stringActionSheetPicker : ActionSheetStringPicker?
    var dateActionSheetPicker : ActionSheetDatePicker?
    
   // var appFlowType: FlowType = .wallPaper
    
    var currentLanguage: Language {
        get {
            if let lang = UserDefaults.standard.value(forKey: K.LanguageKey) as? String {
                return Language.init(languageCode: lang)!
            } else {
                return .none
            }
        }
        set(newValue) {
            UserDefaults.standard.setValue(newValue.code, forKey: K.LanguageKey)
        }
    }
    
    //MARK:- Init
    override init() {
        
        super.init()
        self.user = self.getWrittenFile(UserInfoFileName) as? [String: Any]
        
        if let _ = self.user {
            self.token = TOKEN
            self.userId = self.user!["id"] as? String
            self.name = self.user!["name"] as? String
            self.email = self.user!["email"] as? String
            
            TOKEN = self.token!
            USER_ID = self.userId!
        }
    }
    
    open var fullName : String {
        
        get {
            return (self.user!["fname"] as? String)! + " " + (self.user!["lname"] as? String)!
        }
        
    }
    
    //MARK:- Public Methods
    open class func setLoggedInUserInfo(_ user: [String : Any]) {
        
        let currentUser = CurrentUser.sharedInstance
        
        currentUser.user = user
        currentUser.token = user["token"] as? String
        currentUser.userId = user["id"] as? String
        currentUser.name = user["name"] as? String
        currentUser.email = user["email"] as? String
        currentUser.writeFile(user as AnyObject, fileName: UserInfoFileName)
        
        USER_ID = currentUser.userId!
    }
    
    //MARK:- Internal/Private Methods
    fileprivate class func clearUserDefaults() {
        
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        //ServicesManager.PRACTICE_ID = ""
    }
    
    fileprivate func documentDirectoryPathForFileNamed(_ fileName: String) -> String {
        
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.stringByAppendingPathComponent(fileName)
    }
    
    fileprivate func writeFile(_ file: AnyObject, fileName: String) {
        
        if !NSKeyedArchiver.archiveRootObject(file,
                                              toFile: self.documentDirectoryPathForFileNamed(fileName)) {
            print(" ---- Error ---- \n\nSaving Data List\n\n ---- Error ---- ")
        }
    }
    
    fileprivate func getWrittenFile(_ fileName: String) -> AnyObject? {
        
        return NSKeyedUnarchiver.unarchiveObject(withFile: self.documentDirectoryPathForFileNamed(fileName)) as AnyObject?
    }
    
    fileprivate func removeWrittenFile(_ fileName: String) {
        
        do {
            try FileManager.default.removeItem(atPath: self.documentDirectoryPathForFileNamed(fileName))
        } catch {
            print("Unable to delete the file. It does not exist: \(fileName)")
        }
    }
}
