//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ProductStorageItems.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit

protocol ProductViewModalItem {
    var type: ProductItemTyoe { get }
    var tableRowCount: Int { get }
    var collectionRowCount: Int { get }
    var height: CGFloat { get }
    var heading: String { get }
}

enum ProductItemTyoe {
    case images
    case price
    case rating
    case stock
    case actions
    case shortDescription
    case tierPrice
    
    case quantity
    case buynow
    case description
    case features
    case reviews
    case upSell
    case related
    case configurable
    case bundle
    case grouped
    case links
    case sample
    case customOptions
}

class ProductViewModalbannerItem: ProductViewModalItem {
    var heading: String {
        return ""
    }
    
    var type: ProductItemTyoe {
        return .images
    }
    
    var tableRowCount: Int {
        return 1
    }
    
    var collectionRowCount: Int {
        return images.count
    }
    var height: CGFloat {
        return AppDimensions.screenHeight/2
    }
    
    var images: [ImageGallery]
    var offer: String
    
    init(images: [ImageGallery], offer: String ) {
        self.images = images
        self.offer = offer
    }
    
    func updateImages(data: [ImageGallery]) {
        self.images = data
    }
    
    func add(img: String) {
        var dict = [String: Any]()
        dict["dominantColor"] = ""
        dict["largeImage"] = img
        dict["smallImage"] = ""
        let imag = ImageGallery(json: JSON(dict))
        self.images.insert(imag, at: 0)
    }
    
    func replace(img: String) {
        var dict = [String: Any]()
        dict["dominantColor"] = ""
        dict["largeImage"] = img
        dict["smallImage"] = ""
        let imag = ImageGallery(json: JSON(dict))
        if self.images.count > 0 {
            self.images.remove(at: 0)
        }
        self.images.insert(imag, at: 0)
    }
}

struct ProductViewModalNamePriceItem: ProductViewModalItem {
    var type: ProductItemTyoe {
        return .price
    }
    var heading: String {
        return ""
    }
    
    var tableRowCount: Int {
        return 1
    }
    
    var collectionRowCount: Int {
        return 1
    }
    
    var height: CGFloat {
        return UITableView.automaticDimension
    }
    
    var data: ProductPageModel
    
    init(data: ProductPageModel ) {
        self.data = data
    }
}

struct ProductViewModalRatingDataItem: ProductViewModalItem {
    var type: ProductItemTyoe {
        return .rating
    }
    var heading: String {
        return ""
    }
    
    var tableRowCount: Int {
        return 1
    }
    
    var collectionRowCount: Int {
        return 1
    }
    var height: CGFloat {
        return UITableView.automaticDimension
    }
    
    var rating: String
    var numberOfReviews: String
    var guestCanReview: Bool
    
    init(rating: String, numberOfReviews: String, guestCanReview: Bool ) {
        self.rating = rating
        self.numberOfReviews = numberOfReviews
        self.guestCanReview = guestCanReview
    }
}

struct ProductViewModalActionsItem: ProductViewModalItem {
    var type: ProductItemTyoe {
        return .actions
    }
    var heading: String {
        return ""
    }
    
    var tableRowCount: Int {
        return 1
    }
    
    var collectionRowCount: Int {
        return 1
    }
    var height: CGFloat {
        return UITableView.automaticDimension
    }
}

struct ProductViewModalStockItem: ProductViewModalItem {
    var type: ProductItemTyoe {
        return .stock
    }
    var heading: String {
        return ""
    }
    
    var tableRowCount: Int {
        return 1
    }
    
    var collectionRowCount: Int {
        return 1
    }
    var height: CGFloat {
        return UITableView.automaticDimension
    }
    var stock: String
    var showPriceDown: Bool
    var showOutofStock: Bool
    
    init(stock: String, showPriceDown: Bool, showOutofStock: Bool) {
        self.stock = stock
        self.showPriceDown = showPriceDown
        self.showOutofStock = showOutofStock
    }
}

struct ProductViewModalTierPriceItem: ProductViewModalItem {
    var type: ProductItemTyoe {
        return .tierPrice
    }
    var heading: String {
        return ""
    }
    
    var tableRowCount: Int {
        return 1
    }
    
    var collectionRowCount: Int {
        return 1
    }
    var height: CGFloat {
        return UITableView.automaticDimension
    }
    var tierPrice: String
    
    init(tierPrice: String) {
        self.tierPrice = tierPrice
    }
}


struct ProductViewModalShortDescriptionItem: ProductViewModalItem {
    var type: ProductItemTyoe {
        return .shortDescription
    }
    var heading: String {
        return ""
    }
    
    var tableRowCount: Int {
        return 1
    }
    
    var collectionRowCount: Int {
        return 1
    }
    var height: CGFloat {
        return UITableView.automaticDimension
    }
    var shortDescription: String
    
    init(shortDescription: String) {
        self.shortDescription = shortDescription.html2String
    }
}


struct ProductViewModalQuantityItem: ProductViewModalItem {
    var type: ProductItemTyoe {
        return .quantity
    }
    var heading: String {
        return ""
    }
    
    var tableRowCount: Int {
        return 1
    }
    
    var collectionRowCount: Int {
        return 1
    }
    var height: CGFloat {
        return UITableView.automaticDimension
    }
}

struct ProductViewModalBuyNowItem: ProductViewModalItem {
    var type: ProductItemTyoe {
        return .buynow
    }
    var heading: String {
        return ""
    }
    
    var tableRowCount: Int {
        return 1
    }
    
    var collectionRowCount: Int {
        return 1
    }
    var height: CGFloat {
        return UITableView.automaticDimension
    }
}

struct ProductViewModalDescriptionItem: ProductViewModalItem {
    var type: ProductItemTyoe {
        return .description
    }
    var heading: String {
        return descriptionheading
    }
    
    var tableRowCount: Int {
        return 1
    }
    
    var collectionRowCount: Int {
        return 1
    }
    var height: CGFloat {
        return UITableView.automaticDimension
    }
    var descriptionheading: String
    var description: NSAttributedString
    
    init(descriptionheading: String, description: String) {
        self.descriptionheading = descriptionheading
        self.description = description.html2AttributedString ?? NSAttributedString()
    }
}

struct ProductViewModalFeaturesItem: ProductViewModalItem {
    var type: ProductItemTyoe {
        return .features
    }
    var heading: String {
        return featuresheading
    }
    
    var tableRowCount: Int {
        return additionalInf.count
    }
    
    var collectionRowCount: Int {
        return 1
    }
    var height: CGFloat {
        return UITableView.automaticDimension
    }
    var featuresheading: String
    var additionalInf: [AdditionalInformation]
    
    init(featuresheading: String, additionalInf: [AdditionalInformation]) {
        self.featuresheading = featuresheading
        self.additionalInf = additionalInf
    }
}

struct ProductViewModalReviewsItem: ProductViewModalItem {
    var type: ProductItemTyoe {
        return .reviews
    }
    var heading: String {
        return reviewsheading
    }
    
    var tableRowCount: Int {
        return reviewList.count
    }
    
    var collectionRowCount: Int {
        return 1
    }
    var height: CGFloat {
        return UITableView.automaticDimension
    }
    var reviewsheading: String
    var reviewList: [ReviewList]
    var guestCanReview: Bool
    
    init(reviewsheading: String, reviewList: [ReviewList], guestCanReview: Bool) {
        self.reviewsheading = reviewsheading
        self.reviewList = reviewList
        self.guestCanReview = guestCanReview
    }
}

struct ProductViewModalRelatedProductsItem: ProductViewModalItem {
    var type: ProductItemTyoe {
        return .related
    }
    var heading: String {
        return relatedheading
    }
    
    var tableRowCount: Int {
        return 1
    }
    
    var collectionRowCount: Int {
        return relatedList.count
    }
    var height: CGFloat {
        return UITableView.automaticDimension
    }
    var relatedheading: String
    var relatedList: [RelatedProductList]
    
    init(relatedheading: String, relatedList: [RelatedProductList]) {
        self.relatedheading = relatedheading
        self.relatedList = relatedList
    }
}

struct ProductViewModalUpSellProductsItem: ProductViewModalItem {
    var type: ProductItemTyoe {
        return .upSell
    }
    var heading: String {
        return upSellheading
    }
    
    var tableRowCount: Int {
        return 1
    }
    
    var collectionRowCount: Int {
        return upSellList.count
    }
    var height: CGFloat {
        return UITableView.automaticDimension
    }
    var upSellheading: String
    var upSellList: [RelatedProductList]
    
    init(upSellheading: String, upSellList: [RelatedProductList]) {
        self.upSellheading = upSellheading
        self.upSellList = upSellList
    }
}

struct ProductViewModalConfigurableItem: ProductViewModalItem {
    var type: ProductItemTyoe {
        return .configurable
    }
    var heading: String {
        return ""
    }
    
    var tableRowCount: Int {
        return configurableData.attributes.count
    }
    
    var collectionRowCount: Int {
        return 1
    }
    var height: CGFloat {
        return 106
    }
    
    var configurableData: ConfigurableData
    
    init(configurableData: ConfigurableData) {
        self.configurableData = configurableData
    }
}

struct ProductViewModalGroupedItem: ProductViewModalItem {
    var type: ProductItemTyoe {
        return .grouped
    }
    var heading: String {
        return ""
    }
    
    var groupedDict = [String: String]()
    var tableRowCount: Int {
        return gropedData.count
    }
    
    var collectionRowCount: Int {
        return 1
    }
    var height: CGFloat {
        return 128
    }
    
    var gropedData: [CartProducts]
    
    init(gropedData: [CartProducts]) {
        self.gropedData = gropedData
        self.add()
    }
    
    mutating func add() {
        for i in 0..<gropedData.count {
            //groupedDict[String(i)] = gropedData[i].qty
            groupedDict[gropedData[i].id] = gropedData[i].qty
        }
        
    }
}

struct ProductViewModalBundleItem: ProductViewModalItem {
    var type: ProductItemTyoe {
        return .bundle
    }
    
    var selectedRow = 0
    
    var heading: String {
        return ""
    }
    
    var tableRowCount: Int {
        return bundleData.count
    }
    
    var collectionRowCount: Int {
        return 1
    }
    var height: CGFloat {
        return UITableView.automaticDimension
    }
    
    var bundleData: [BundleOptions]
    
    init(bundleData: [BundleOptions]) {
        self.bundleData = bundleData
    }
    
    mutating func value(index1: Int) {
        if let index = bundleData[index1].optionValues.firstIndex(where: { $0.isDefault == "1" }) {
            selectedRow = index
        }
    }
    
    mutating func setValue(index1: Int) {
        selectedRow = index1
    }
}

struct ProductViewModalLinksDownloadableItem: ProductViewModalItem {
    var type: ProductItemTyoe {
        return .links
    }
    
    var heading: String {
        return ""
    }
    
    var tableRowCount: Int {
        return 1
    }
    
    var collectionRowCount: Int {
        return 1
    }
    var height: CGFloat {
        return UITableView.automaticDimension
    }
    
    var links: Links
    
    init(links: Links) {
        self.links = links
    }
    
}

struct ProductViewModalSampleDownloadableItem: ProductViewModalItem {
    var type: ProductItemTyoe {
        return .sample
    }
    
    var heading: String {
        return samples.title ?? ""
    }
    
    var tableRowCount: Int {
        return samples.linkSampleData.count
    }
    
    var collectionRowCount: Int {
        return 1
    }
    var height: CGFloat {
        return UITableView.automaticDimension
    }
    
    var samples: Samples
    
    init(samples: Samples) {
        self.samples = samples
    }
    
}

struct ProductViewModalCustomOptionItem: ProductViewModalItem {
    var type: ProductItemTyoe {
        return .customOptions
    }
    
    var heading: String {
        return  ""
    }
    
    var tableRowCount: Int {
        return customOptions.count
    }
    
    var selectedRow = 0
    
    var collectionRowCount: Int {
        return 1
    }
    var height: CGFloat {
        return UITableView.automaticDimension
    }
    
    var customOptions: [CustomOptions]
    
    init(customOptions: [CustomOptions]) {
        self.customOptions = customOptions
    }
    
    mutating func value(index1: Int) {
        if let index = customOptions[index1].optionValues.firstIndex(where: { $0.isDefault == "1" }) {
            selectedRow = index
        }
    }
    
    mutating func setValue(index1: Int) {
        selectedRow = index1
    }
}
