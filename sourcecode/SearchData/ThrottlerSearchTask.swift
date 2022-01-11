//
//  Throttler.swift
//  Magento_POS
//
//  Created by bhavuk.chawla on 02/09/18.
//  Copyright © 2018 bhavuk.chawla. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

protocol ShareSearchData: class {
    func shareSearchData(products: [ProductList])
}

class Throttler {
    let defaults = UserDefaults.standard
    private var searchTask: DispatchWorkItem?
    typealias HomeRequestParameters = (String, HTTPMethod, [String: Any]) // 1.Params, 2.Verbs, 3.Dictionary
    deinit {
        print("Throttler object deiniantialized")
    }
    func throttle(searchText: String, block: @escaping (_ products: [SearchSuggestionProduct], _ searchSuggestion: [SearchSuggestion]) -> Void) {
        searchTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            guard let obj = self else {
                return
            }
            var requstParams = [String: Any]()
            requstParams["storeId"] = obj.defaults.object(forKey: "storeId") as? String ?? ""
            requstParams["searchQuery"] = searchText
            let call: HomeRequestParameters = ("", HTTPMethod.get, requstParams)
            obj.hitApi(data: call) { (data, jsonData) in
                if data {
                    var products = [SearchSuggestionProduct]()
                    var suggestions = [SearchSuggestion]()
                    if jsonData["suggestProductArray"] != JSON.null {
                        if let productData = jsonData["suggestProductArray"]["products"].array, productData.count > 0 {
                            products = productData.map { SearchSuggestionProduct(json: $0) }
                        }
                        if let suggestionData  = jsonData["suggestProductArray"]["tags"].array, suggestionData.count > 0 {
                            suggestions = suggestionData.map { SearchSuggestion(json: $0) }
                        }
                        block(products, suggestions)
                    }
                }
                print("first", data)
            }
        }
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: task)
    }
    func hitApi(data: HomeRequestParameters, completion: ((_ data: Bool, _ jsonData: JSON) -> Void)?) {
        NetworkManager.sharedInstance.callingHttpRequest(params: data.2, method: data.1, apiname: .searchSuggestion, currentView: UIViewController()) { success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {
                if let data = responseObject {
                    let jsonData = JSON(data)
                    if jsonData["success"].stringValue == "1" || jsonData["success"].boolValue {
                        completion?(true, jsonData)
                    } else {
                        completion?(false, JSON.null)
                    }
                }
            } else if success == 2 {   // Retry in case of error
            } else if success == 3 {   // No Changes
            }
        }
    }
}

struct SearchSuggestion {
    var label: String!
    var count: String!
    init(json: JSON) {
        label = json["label"].stringValue
        count = json["count"].stringValue
    }
}
