//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: DownloadManager.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */


import Foundation
import Alamofire


class DownloadManager: NSObject {
    
    override private init() {
        super.init()
    }
    
    static var shared = DownloadManager()
    
    
    func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    func download(string: String, completion: @escaping ((String) -> Void)) {
        Alamofire.download(URLRequest(url: URL(string: string)!), to: destination).response { response in
            if response.error == nil, let filePath = response.destinationURL?.path {
                print(filePath)
                let myUrl = "file://" + filePath
                print(myUrl)
                //                UserDefaults.standard.set(myUrl, forKey: "obj")
                //                UserDefaults.standard.synchronize()
                completion(myUrl)
            }
        }
    }
    
    let destination: DownloadRequest.DownloadFileDestination = { _, _ in
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("\(DownloadManager.shared.randomString(length: 5)).usdz")
        return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
    }
    
}
