//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ProductReviewDetailDataViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit
import Cosmos

class ProductReviewDetailDataViewController: UIViewController {
    
    @IBOutlet weak var submittedOnLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var yourReview: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var yourRating: CosmosView!
    @IBOutlet weak var reviewDesc: UILabel!
    @IBOutlet weak var reviewHeading: UILabel!
    @IBOutlet weak var productReviews: UILabel!
    @IBOutlet weak var productRating: CosmosView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productStars: UILabel!
    @IBOutlet weak var customerName: UILabel!
    
    var data: CustomerReviewList!
    override func viewDidLoad() {
        super.viewDidLoad()
        yourRating.settings.fillMode = .half
        productRating.settings.fillMode = .half
        yourRating.isUserInteractionEnabled = false
        productRating.isUserInteractionEnabled = false
        self.navigationItem.title = "Review Details".localized
        submittedOnLabel.text = "Submitted on".localized
        ratingLabel.text = "Rating".localized
        yourReview.text = "Your Review".localized.uppercased()
        self.productName.text = data?.proName
        productImageView.setImage(fromURL: data?.thumbNail)
        date.text = data?.date
        reviewDesc.text = data?.details
        productReviews.text = data.totalProductReviews + " " + "Reviews".localized
        yourRating.rating = Double(data.customerRating)
        customerName.text = String(data.customerRating) + " " + "Stars".localized
        productRating.rating = Double(data.totalProductRatings)
        self.callingHttppApi()
        // Do any additional setup after loading the view.
    }
    
    func callingHttppApi() {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        requstParams["customerToken"] = Defaults.customerToken
        requstParams["quoteId"] = Defaults.quoteId
        requstParams["reviewId"] = data.id
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .get, apiname: .reviewDetails, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {                
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    
                    
                    self?.doFurtherProcessingWithResult(data: jsonResponse)
                } else {
                    if jsonResponse["message"].stringValue.removeWhiteSpace.count > 0 {
                        ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
                    } else {
                        ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                    }
                }
            } else if success == 2 {   // Retry in case of error
                NetworkManager.sharedInstance.dismissLoader()
                self?.callingHttppApi()
            } else if success == 3 {   // No Changes
                let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "notificationData"))
                self?.doFurtherProcessingWithResult(data: jsonResponse)
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON) {
        //        model = NotificationData(json: data)
        
        reviewDesc.text = data["reviewDetail"].stringValue.html2String.decode()
        date.text = data["reviewDate"].stringValue
        reviewHeading.text = data["reviewTitle"].stringValue.decode()
        productReviews.text = data["totalProductReviews"].stringValue + " " + "Reviews".localized
        productReviews.addTapGestureRecognizer {
            if data["totalProductReviews"].intValue != 0 {
                let nextController = AllReviewsDataViewController.instantiate(fromAppStoryboard: .product)
                nextController.productId = data["productId"].stringValue
                self.navigationController?.pushViewController(nextController, animated: true)
            }
        }
        productRating.rating = data["averageRating"].doubleValue
        productStars.text = data["averageRating"].stringValue + " " + "Stars".localized
        
        productImageView.addTapGestureRecognizer {
            let viewController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
            viewController.productId = data["productId"].stringValue
            self.navigationController?.pushViewController(viewController, animated: true)
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
    
}
