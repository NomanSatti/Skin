//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: AddReviewDataViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit
import MaterialComponents.MDCMultilineTextField
import MaterialComponents.MaterialTextFields_ColorThemer
import MaterialComponents.MaterialTextFields_TypographyThemer
import Cosmos
import Alamofire

class AddReviewDataViewController: UIViewController {
    
    @IBOutlet weak var reviewTableHeight: NSLayoutConstraint!
    @IBOutlet weak var reviewTableView: UITableView!
    //    @IBOutlet weak var starView: CosmosView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var textView: MDCMultilineTextField!
    @IBOutlet weak var nameField: MDCTextField!
    @IBOutlet weak var summaryField: MDCTextField!
    @IBOutlet weak var submitBtn: UIButton!
    var textViewController: MDCTextInputControllerBase!
    var fieldController: MDCTextInputControllerOutlined!
    var summaryController: MDCTextInputControllerOutlined!
    var valuesDict = [String: String]()
    
    var imageUrl: String!
    var id: String!
    var name: String!
    var whichApiCall = ""
    var model: AddReviewModal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Review Product".localized
        productName.text = name
        productImage.setImage(fromURL: imageUrl)
        textView.minimumLines = 0
        textViewController = MDCTextInputControllerOutlinedTextArea(textInput: textView)
        textViewController.activeColor = AppStaticColors.accentColor
        textViewController.floatingPlaceholderActiveColor = AppStaticColors.accentColor
        
        nameField.placeholder = "Name".localized
        summaryField.placeholder = "Summary".localized
        submitBtn.setTitle("Submit Review for Approval".localized.uppercased(), for: .normal)
        textViewController.placeholderText = "Review".localized
        reviewTableView.register(cellType: StarRatingTableViewCell.self)
        reviewTableHeight.constant = 0
        reviewTableView.isScrollEnabled = false
        reviewTableView.separatorStyle = .none
        
        fieldController = MDCTextInputControllerOutlined(textInput: nameField)
        summaryController = MDCTextInputControllerOutlined(textInput: summaryField)
        
        let allTextFieldController: [MDCTextInputControllerOutlined] = [fieldController, summaryController]
        for textFieldController in allTextFieldController {
            textFieldController.activeColor = AppStaticColors.accentColor
            textFieldController.floatingPlaceholderActiveColor = AppStaticColors.accentColor
        }
        nameField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left
        summaryField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left
        nameField.text = Defaults.customerName
        //        starView.didFinishTouchingCosmos = { rating in
        //            print(rating)
        //            self.rating = rating
        //        }
        self.callingHttppApi()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        
        if valuesDict.count != model.ratingFormData.count  {
            ShowNotificationMessages.sharedInstance.warningView(message: "Please complete your ratings".localized)
        } else if nameField.text!.emptyStringCheck() {
            ShowNotificationMessages.sharedInstance.warningView(message: "Enter Your name".localized)
        } else if summaryField.text!.emptyStringCheck() {
            ShowNotificationMessages.sharedInstance.warningView(message: "Enter Summary".localized)
        } else if textView.text!.emptyStringCheck() {
            ShowNotificationMessages.sharedInstance.warningView(message: "Enter Review Details".localized)
        } else {
            whichApiCall = "submit"
            self.callingHttppApi()
        }
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func callingHttppApi() {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        requstParams["width"] = UrlParams.width
        requstParams["quoteId"] = Defaults.quoteId
        requstParams["customerToken"] = Defaults.customerToken
        var apiName: WhichApiCall = .ratingFormData
        var verbs: HTTPMethod = .get
        
        if whichApiCall == "submit" {            
            let uni = (summaryField.text ?? "").unicodeScalars
            let unicode = uni[uni.startIndex].value
            print(String(unicode, radix: 16, uppercase: true))
            requstParams["title"] = summaryField.text?.encode()
            
            let detailuni = (textView.text ?? "").unicodeScalars
            let detailunicode = detailuni[detailuni.startIndex].value
            print(String(detailunicode, radix: 16, uppercase: true))
            requstParams["detail"] = textView.text?.encode()
            
            requstParams["productId"] = id
            requstParams["nickname"] = nameField.text
            requstParams["ratings"] = valuesDict.convertDictionaryToString()
            apiName = .saveReview
            verbs = .post
        } else {
            apiName = .ratingFormData
            verbs = .get
        }
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: verbs, apiname: apiName, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {                
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    self?.doFurtherProcessingWithResult(jsonResponse: jsonResponse)
                } else {
                    ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                }
            } else if success == 2 {   // Retry in case of error
                NetworkManager.sharedInstance.dismissLoader()
                self?.callingHttppApi()
            }
        }
    }
    
    func doFurtherProcessingWithResult(jsonResponse: JSON) {
        if whichApiCall == "submit" {
            ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: jsonResponse["message"].stringValue)
            self.dismiss(animated: true, completion: nil)
        } else {
            model = AddReviewModal(json: jsonResponse)
            if model.ratingFormData.count > 0 {
                reviewTableHeight.constant = CGFloat(85 * model.ratingFormData.count)
                reviewTableView.delegate = self
                reviewTableView.dataSource = self
            }
        }
    }
    
}

extension AddReviewDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: StarRatingTableViewCell = tableView.dequeueReusableCell(with: StarRatingTableViewCell.self, for: indexPath) {
            cell.heading.text = model.ratingFormData[indexPath.row].name
            cell.selectionStyle = .none
            cell.startView.didFinishTouchingCosmos = { rating in
                let rating = Int(rating)
                self.valuesDict[self.model.ratingFormData[indexPath.row].id] = self.model.ratingFormData[indexPath.row].values[rating - 1]
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.ratingFormData.count
    }
}

extension String {
    func emptyStringCheck() -> Bool {
        if self.count > 0 {
            return false
        }
        return true
    }
}
extension String {
    
    func decode() -> String {
        let data = self.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII) ?? self
    }
    
    func encode() -> String {
        let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
}
