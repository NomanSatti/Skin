//
//  RateDeliveryBoyViewController.swift
//  Mobikul Single App
//
//  Created by akash on 16/01/20.
//  Copyright © 2020 Webkul. All rights reserved.
//

import UIKit
import MaterialComponents.MDCMultilineTextField
import MaterialComponents.MaterialTextFields_ColorThemer
import MaterialComponents.MaterialTextFields_TypographyThemer
import Cosmos
import Alamofire

class RateDeliveryBoyViewController: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var reviewTableHeight: NSLayoutConstraint!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var textView: MDCMultilineTextField!
    @IBOutlet weak var nameField: MDCTextField!
    @IBOutlet weak var summaryField: MDCTextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    var textViewController: MDCTextInputControllerBase!
    var fieldController: MDCTextInputControllerOutlined!
    var summaryController: MDCTextInputControllerOutlined!
    var valuesDict = [String: String]()
    var rating = [RatingFormData]()
    var deliveryboyId = ""
    var customerId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rating.append(RatingFormData(object: ["id": "rating", "name": "Rating".localized, "values": ["1", "2", "3", "4", "5"]]))
        reviewTableHeight.constant = CGFloat(85 * self.rating.count)
        reviewTableView.dataSource = self
        reviewTableView.reloadData()
        self.navigationItem.title = "Write your Review".localized
        textView.minimumLines = 0
        textViewController = MDCTextInputControllerOutlinedTextArea(textInput: textView)
        textViewController.activeColor = AppStaticColors.accentColor
        textViewController.floatingPlaceholderActiveColor = AppStaticColors.accentColor
        
        titleLbl.text = "How do you rate Deliveryboy?".localized
        nameField.placeholder = "Name".localized
        summaryField.placeholder = "Summary".localized
        submitBtn.setTitle("Submit Review for Approval".localized.uppercased(), for: .normal)
        textViewController.placeholderText = "Review".localized
        reviewTableView.register(cellType: StarRatingTableViewCell.self)
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
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        if valuesDict.count != rating.count  {
            ShowNotificationMessages.sharedInstance.warningView(message: "Please complete your ratings".localized)
        } else if nameField.text!.emptyStringCheck() {
            ShowNotificationMessages.sharedInstance.warningView(message: "Enter Your name".localized)
        } else if summaryField.text!.emptyStringCheck() {
            ShowNotificationMessages.sharedInstance.warningView(message: "Enter Summary".localized)
        } else if textView.text!.emptyStringCheck() {
            ShowNotificationMessages.sharedInstance.warningView(message: "Enter Review Details".localized)
        } else {
            self.callingHttppApi()
        }
    }
    
    func callingHttppApi() {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        requstParams = valuesDict
        requstParams["storeId"] = Defaults.storeId
        requstParams["width"] = UrlParams.width
        requstParams["quoteId"] = Defaults.quoteId
        requstParams["customerToken"] = Defaults.customerToken
        requstParams["customerId"] = customerId
        requstParams["deliveryboyId"] = deliveryboyId
        requstParams["nickname"] = nameField.text

        let uni = (summaryField.text ?? "").unicodeScalars
        let unicode = uni[uni.startIndex].value
        print(String(unicode, radix: 16, uppercase: true))
        requstParams["title"] = summaryField.text?.encode()
        
        let detailuni = (textView.text ?? "").unicodeScalars
        let detailunicode = detailuni[detailuni.startIndex].value
        print(String(detailunicode, radix: 16, uppercase: true))
        requstParams["comment"] = textView.text?.encode()
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .post, apiname: .saveDeliveryboyReview, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: jsonResponse["message"].stringValue)
                    self?.dismiss(animated: true, completion: nil)
                } else {
                    ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                }
            } else if success == 2 {   // Retry in case of error
                NetworkManager.sharedInstance.dismissLoader()
                self?.callingHttppApi()
            }
        }
    }
}

extension RateDeliveryBoyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: StarRatingTableViewCell = tableView.dequeueReusableCell(with: StarRatingTableViewCell.self, for: indexPath) {
            cell.heading.text = self.rating[indexPath.row].name
            cell.selectionStyle = .none
            cell.startView.didFinishTouchingCosmos = { rating in
                let rating = Int(rating)
                self.valuesDict[self.rating[indexPath.row].id] = self.rating[indexPath.row].values[rating - 1]
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rating.count
    }
}

