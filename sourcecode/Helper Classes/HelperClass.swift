import UIKit
import Alamofire
import Foundation

import ImageIO
import Kingfisher
import QuartzCore

let isIPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

protocol MoveController: class {
    func moveController(id: String, name: String, dict: [String: Any], jsonData: JSON, type: String, controller: AllControllers)
}

public typealias DictType = [String: Any]
typealias MoveDelegate = (id: String, name: String, dict: [String: Any], jsonData: JSON, type: String, controller: AllControllers)

enum WhichApiCall: String {
    //MARK:- M2 Default API
    case registerDevice = "mobikulhttp/extra/registerDevice"
    case loadHome = "mobikulhttp/catalog/homePageData"
    case logout = "mobikulhttp/extra/logout"
    case forgetPassword = "mobikulhttp/customer/forgotpassword"
    case login = "mobikulhttp/customer/logIn"
    case createAccount = "mobikulhttp/customer/createAccount"
    case createAccountFormData = "mobikulhttp/customer/createAccountFormData"
    case newProductList = "mobikulhttp/catalog/newProductList"
    case featuredProductList = "mobikulhttp/catalog/featuredProductList"
    case hotDealsList = "mobikulhttp/catalog/hotDealList"
    case customCollection = "mobikulhttp/extra/customcollection"
    case categoryProductList = "mobikulhttp/catalog/productCollection"
    case addToWishList = "mobikulhttp/catalog/addtoWishlist"
    case addToCompare = "mobikulhttp/catalog/addtocompare"
    case removeFromWishList = "mobikulhttp/customer/removefromWishlist"
    case addToCart = "mobikulhttp/checkout/addtoCart"
    case notificationList = "mobikulhttp/extra/notificationList"
    case searchTermList = "mobikulhttp/extra/searchTermList"
    case advancedSearchFormData = "mobikulhttp/catalog/advancedsearchformdata"
    case removeFromCompare = "mobikulhttp/catalog/removefromcompare"
    case compareList = "mobikulhttp/catalog/comparelist"
    case contactPost = "mobikulhttp/contact/post"
    case cmsData = "mobikulhttp/extra/cmsData"
    case reorder = "mobikulhttp/customer/reOrder"
    case guestReoder = "mobikulhttp/sales/guestreorder"
    case orderList = "mobikulhttp/customer/orderList"
    case orderDetails = "mobikulhttp/customer/orderDetails"
    case customerReviewList = "mobikulhttp/customer/ReviewList"
    case cartData = "mobikulhttp/checkout/cartDetails"
    case removeProductFromData = "mobikulhttp/checkout/removeCartItem"
    case wishlistData = "mobikulhttp/customer/Wishlist"
    case wishlistToCart = "mobikulhttp/customer/WishlistToCart"
    case checkoutAddress = "mobikulhttp/checkout/checkoutaddress"
    case checkoutShippping = "mobikulhttp/checkout/ShippingMethods"
    case deleteAddress = "mobikulhttp/customer/deleteAddress"
    case addressBook = "mobikulhttp/customer/addressBookData"
    case getAddress = "mobikulhttp/customer/addressformData"
    case saveAddress = "mobikulhttp/customer/saveAddress"
    case checkoutOrderReview = "mobikulhttp/checkout/reviewandpayment"
    case placeOrder = "mobikulhttp/checkout/PlaceOrder"
    case productPage = "mobikulhttp/catalog/productPageData"
    case downloadProductList = "mobikulhttp/customer/MyDownloadsList"
    case saveReview = "mobikulhttp/customer/saveReview"
    case wishlistFromCart = "mobikulhttp/Checkout/WishlistFromCart"
    case couponForCart = "mobikulhttp/Checkout/ApplyCoupon"
    case removeCoupon = "removeCoupon"
    case addToWishlist = "mobikulhttp/Catalog/AddToWishlist"
    case ratingFormData = "mobikulhttp/catalog/ratingformdata"
    case subCategoryData = "mobikulhttp/catalog/categoryPageData"
    case accountinfoData = "mobikulhttp/customer/accountinfoData"
    case searchSuggestion = "mobikulhttp/extra/searchSuggestion"
    case updateCart = "mobikulhttp/checkout/updateCart"
    case updateWishlist = "mobikulhttp/customer/UpdateWishlist"
    case emptyCart = "mobikulhttp/checkout/EmptyCart"
    case allReviews = "mobikulhttp/catalog/reviewsandratings"
    case inVoiceDetails = "mobikulhttp/customer/invoiceview"
    case shipmentDetails = "mobikulhttp/customer/shipmentview"
    case signout = "mobikulhttp/extra/logOut"
    case downloadProduct = "mobikulhttp/customer/downloadProduct"
    case reviewDetails = "mobikulhttp/customer/reviewDetails"
    case guestview = "mobikulhttp/sales/guestview"
    case updateitemoptions = "mobikulhttp/checkout/updateitemoptions"
    case saveAccountInfo = "mobikulhttp/customer/saveAccountInfo"
    case checkCustomerByEmail = "mobikulhttp/customer/checkCustomerByEmail"
    case accountcreate = "mobikulhttp/checkout/accountcreate"
    case GetDeliveryboyLocation = "expressdelivery/api/getLocation"
    case chatWithAdmin = "https://us-central1-mobikul-magento2-app.cloudfunctions.net/updateTokenToDataBase"
    case deleteChatToken = "https://us-central1-mobikul-magento2-app.cloudfunctions.net/deleteTokenFromDataBase"
    case shareWishList = "mobikulhttp/sales/sharewishlist"
    case addAllToCart = "mobikulhttp/sales/alltocart"
    case uploadBannerPic = "mobikulhttp/index/uploadBannerPic"
    case uploadProfilePic = "mobikulhttp/index/uploadProfilePic"
    case notifyPrice = "mobikulhttp/productalert/price"
    case notifyStock = "mobikulhttp/productalert/stock"
    case saveDeliveryboyReview = "expressdelivery/api_customer/addreview"
    case none = ""
    
    
}

/*{
  "canReorder" : true,
  "incrementId" : "000000081",
  "showCreateAccountLink" : true,
  "orderId" : "88",
  "message" : "",
  "email" : "tester@webkul.com",
  "success" : true,
  "customerDetails" : {
    "groupId" : 0,
    "guestCustomer" : 1,
    "email" : "tester@webkul.com",
    "lastname" : "jdjdjdj",
    "firstname" : "hdhdh"
  },
  "cartCount" : 1
}*/
