//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ProductViewModal+View+TableView.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit
import MobileCoreServices

// MARK: Designing Views
extension ProductPageViewModal: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch productItems[safe: section]?.type {
        case .description:
            return collapseDescription ? 0 : productItems[section].tableRowCount
        case .features:
            return collapseFeatures ? 0 : productItems[section].tableRowCount
        case .reviews:
            return collapseReviews ? 0 : productItems[section].tableRowCount
        default:
            return productItems[section].tableRowCount
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return productItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        let item = productItems[safe: indexPath.section]?.type
        switch item {
        case .images:
            return self.loadBanners(tableView: tableView, item: productItems[indexPath.section], indexPath: indexPath)
        case .price:
            return self.loadNamePrice(tableView: tableView, item: productItems[indexPath.section], indexPath: indexPath)
        case .rating:
            return self.loadRating(tableView: tableView, item: productItems[indexPath.section], indexPath: indexPath)
        case .actions:
            return self.loadActions(tableView: tableView, item: productItems[indexPath.section], indexPath: indexPath)
        case .shortDescription:
            return self.loadShortDescription(tableView: tableView, item: productItems[indexPath.section], indexPath: indexPath)
        case .tierPrice:
            return self.loadShortDescription(tableView: tableView, item: productItems[indexPath.section], indexPath: indexPath)
        case .quantity:
            return self.loadQuantity(tableView: tableView, item: productItems[indexPath.section], indexPath: indexPath)
        case .buynow:
            return self.loadBuyNow(tableView: tableView, item: productItems[indexPath.section], indexPath: indexPath)
        case .description:
            return self.loadDescription(tableView: tableView, item: productItems[indexPath.section], indexPath: indexPath)
        case .features:
            return self.loadFeatures(tableView: tableView, item: productItems[indexPath.section], indexPath: indexPath)
        case .reviews:
            return self.loadReviews(tableView: tableView, item: productItems[indexPath.section], indexPath: indexPath)
        case .related:
            return self.loadRelated(tableView: tableView, item: productItems[indexPath.section], indexPath: indexPath)
        case .upSell:
            return self.loadUpsell(tableView: tableView, item: productItems[indexPath.section], indexPath: indexPath)
        case .configurable:
            return self.loadConfigurable(tableView: tableView, item: productItems[indexPath.section], indexPath: indexPath)
        case .grouped:
            return self.loadGrouped(tableView: tableView, item: productItems[indexPath.section], indexPath: indexPath)
        case .bundle:
            return self.loadBundle(tableView: tableView, item: productItems[indexPath.section], indexPath: indexPath)
        case .sample:
            return self.loadSamples(tableView: tableView, item: productItems[indexPath.section], indexPath: indexPath)
        case .links:
            return self.loadLinks(tableView: tableView, item: productItems[indexPath.section], indexPath: indexPath)
        case .customOptions:
            customSection = indexPath.section
            return self.loadCustom(tableView: tableView, item: productItems[indexPath.section], indexPath: indexPath)
        case .stock:
            return self.loadStock(tableView: tableView, item: productItems[indexPath.section], indexPath: indexPath)
        
        case .none:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return productItems[safe: indexPath.section]?.height ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch productItems[safe: section]?.type {
        case .description, .features:
            if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProductSectionHeading.identifier) as? ProductSectionHeading {
                headerView.setBackgroundViewColor(color: UIColor.white)
                headerView.titleLabel?.text = productItems[section].heading
                headerView.addTapGestureRecognizer {
                    self.collapseChange(view: headerView, section: section, type: self.productItems[section].type)
                }
                if self.productItems[section].type == .description {
                    headerView.setCollapsed(collapsed: collapseDescription)
                } else {
                    headerView.setCollapsed(collapsed: collapseFeatures)
                }
                return headerView
            }
            return nil
//            if let headerView = (Bundle.main.loadNibNamed("CollapsingHeaderView", owner: self, options: nil)?.first as? CollapsingHeaderView) {
//                headerView.TitleLbl.text = productItems[section].heading
//                headerView.addTapGestureRecognizer {
//                    self.collapseChange(view: headerView, section: section, type: self.productItems[section].type)
//                }
//                if self.productItems[section].type == .description {
//                    headerView.collapsingImg.rotateView(collapseDescription ? 0.0 : .pi)
//                } else {
//                    headerView.collapsingImg.rotateView(collapseFeatures ? 0.0 : .pi)
//                }
//                return headerView
//            }
//            return nil
        case .reviews:
            if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReviewHeaderView.identifier) as? ReviewHeaderView {
                headerView.setBackgroundViewColor(color: UIColor.white)
                headerView.totalRating.text = model.rating
                headerView.addTapGestureRecognizer {
                    self.collapseChange(view: headerView, section: section, type: self.productItems[section].type)
                }
                //headerView.arrowLabel?.rotate(collapseReviews ? 0.0 : .pi)
                headerView.setCollapsed(collapsed: collapseReviews)
                if !model.guestCanReview  && Defaults.customerToken == nil {
                    headerView.addReviewBtn.isHidden = true
                } else {
                    headerView.addReviewBtn.isHidden = false
                }
                if let ratingArray = model.ratingArray {
                    headerView.ratingArray = ratingArray
                }
                if model.reviewCount.count > 0 {
                    headerView.totalReviews.text = model.reviewCount + " " + "Reviews".localized
                } else {
                    headerView.totalReviews.text = "No Reviews".localized
                }
                headerView.id = productId
                headerView.name = model.name
                if let imageGallery = model.imageGallery {
                    headerView.image = imageGallery[0].largeImage ?? ""
                }
                headerView.titleLabel?.text = productItems[section].heading
                return headerView
            }
            return nil
        case .sample:
            if let sample = model.samples, sample.linkSampleData.count > 0, let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProductSectionHeading.identifier) as? ProductSectionHeading {
                headerView.setBackgroundViewColor(color: UIColor.white)
                headerView.titleLabel?.text = productItems[section].heading
                headerView.arrowLabel.isHidden = true
                return headerView
            }
            return nil
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if productItems[safe: indexPath.section]?.type == .sample, let items = productItems[safe: indexPath.section] as? ProductViewModalSampleDownloadableItem {
            let mimeType: CFString = items.samples.linkSampleData[indexPath.row].mimeType as CFString
            guard
                let mimeUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType, nil)?.takeUnretainedValue()
                else { return }
            guard
                let extUTI = UTTypeCopyPreferredTagWithClass(mimeUTI, kUTTagClassFilenameExtension)
                else { return }
            print(extUTI.takeRetainedValue() as String)
            let ext = items.samples.linkSampleData[indexPath.row].sampleTitle + "." + (extUTI.takeRetainedValue() as String)
            NetworkManager.sharedInstance.download(downloadUrl: items.samples.linkSampleData[indexPath.row].url, saveUrl: ext, completion: { (_, results) in
                print("Success post title:", results)
            })
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch productItems[safe: section]?.type {
        case .reviews:
            if !collapseReviews, let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ActionButtonFooterView.identifier) as? ActionButtonFooterView {
                footerView.setBackgroundViewColor(color: UIColor.white)
                footerView.btn.setTitle("View All Product Reviews".localized.uppercased(), for: .normal)
                footerView.btn.addTapGestureRecognizer {
                    self.moveDelegate?.move(id: self.productId, controller: .allReviews)
                }
                return footerView
            }
            return nil
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch productItems[safe: section]?.type {
//        case .description, .features:
//            return 78//56
//        case .sample:
//            return 56
        case .description, .features, .sample:
            return 56
        case .reviews:
            return 224
        case .related, .upSell:
            return 30
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch productItems[safe: section]?.type {
        case .reviews:
            return 56
        default:
            return 0
        }
    }
    
    func loadBanners(tableView: UITableView, item: ProductViewModalItem, indexPath: IndexPath) -> UITableViewCell {
        if let cell: ProductTopImagesTableViewCell = tableView.dequeueReusableCell(with: ProductTopImagesTableViewCell.self, for: indexPath),
            let item = item as? ProductViewModalbannerItem {
            cell.arType = model.arType
            cell.arUrl = model.arUrl
            cell.offerLabel.text = item.offer
            cell.images = item.images
            cell.layoutIfNeeded()
            cell.collectionView.reloadData()
            cell.selectionStyle = .none
            return cell
        }
        tableView.separatorStyle = .none
        return UITableViewCell()
    }
    
    func loadNamePrice(tableView: UITableView, item: ProductViewModalItem, indexPath: IndexPath) -> UITableViewCell {
        if let cell: ProductNamePriceTableViewCell = tableView.dequeueReusableCell(with: ProductNamePriceTableViewCell.self, for: indexPath),
            let item = item as? ProductViewModalNamePriceItem {
            cell.productType = productType.rawValue
            cell.optionProductId = self.optionProductId
            cell.item = item.data
            cell.selectionStyle = .none
            return cell
        }
        tableView.separatorStyle = .none
        return UITableViewCell()
    }
    
    func loadRating(tableView: UITableView, item: ProductViewModalItem, indexPath: IndexPath) -> UITableViewCell {
        if let cell: ProductReviewCountTableViewCell = tableView.dequeueReusableCell(with: ProductReviewCountTableViewCell.self, for: indexPath),
            let item = item as? ProductViewModalRatingDataItem {
            cell.ratingValue.text = item.rating
            cell.reviewsLabel.text = item.numberOfReviews
            cell.id = productId
            cell.name = model.name
            if let imageGallery = model.imageGallery {
                cell.imageData = imageGallery[0].largeImage ?? ""
            }
            if !model.guestCanReview  && Defaults.customerToken == nil {
                cell.addReviewBtn.isHidden = true
            } else {
                cell.addReviewBtn.isHidden = false
            }
            if let reviewList = model.reviewList, reviewList.count > 0 {
                cell.reviewsLabel.addTapGestureRecognizer {
                    let nextController = AllReviewsDataViewController.instantiate(fromAppStoryboard: .product)
                    nextController.productId = self.productId
                    tableView.viewContainingController?.navigationController?.pushViewController(nextController, animated: true)
                }
            } else {                
                cell.reviewWidth.constant = 0
                cell.reviewsLabel.text = "No Reviews yet".localized
            }
            cell.selectionStyle = .none
            return cell
        }
        tableView.separatorStyle = .none
        return UITableViewCell()
    }
    
    func loadActions(tableView: UITableView, item: ProductViewModalItem, indexPath: IndexPath) -> UITableViewCell {
        if let cell: ProductActionTableViewCell = tableView.dequeueReusableCell(with: ProductActionTableViewCell.self, for: indexPath),
            let _ = item as? ProductViewModalActionsItem {
            if self.addedToWishlist {
                cell.wishlishtBtn.setImage(UIImage(named: "ic_wishlist_fill"), for: .normal)
            } else {
                cell.wishlishtBtn.setImage(UIImage(named: "ic_wishlist"), for: .normal)
            }
            cell.wishlishtBtn.addTapGestureRecognizer {
                self.wishlistClicked() { _ in
                    if self.addedToWishlist {
                        cell.wishlishtBtn.setImage(UIImage(named: "ic_wishlist_fill"), for: .normal)
                    } else {
                        cell.wishlishtBtn.setImage(UIImage(named: "ic_wishlist"), for: .normal)
                    }
                }
            }
            cell.compareBtn.addTapGestureRecognizer {
                self.compareClicked()
            }
            cell.shareBtn.addTapGestureRecognizer {
                self.shareClicked()
            }
            cell.selectionStyle = .none
            return cell
        }
        tableView.separatorStyle = .none
        return UITableViewCell()
    }
    
    func loadStock(tableView: UITableView, item: ProductViewModalItem, indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
//        if let item = item as? ProductViewModalStockItem {
//            cell.textLabel?.text = item.stock.uppercased()
//            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
//        }
//        tableView.separatorStyle = .none
//        cell.selectionStyle = .none
//        return cell
        if let cell: StockManagementTableViewCell = tableView.dequeueReusableCell(with: StockManagementTableViewCell.self, for: indexPath) {
            if let item = item as? ProductViewModalStockItem {
                cell.stockLbl.text = item.stock.uppercased()
                cell.notifyPriceBtn.isHidden = !item.showPriceDown
                cell.notifyStockBtn.isHidden = !item.showOutofStock
                cell.notifyPrice = {
                    self.notifyPrice()
                }
                cell.notifyStock = {
                    self.notifyStock()
                }
                return cell
            }
        }
        tableView.separatorStyle = .none
        return UITableViewCell()
    }
    
    func loadShortDescription(tableView: UITableView, item: ProductViewModalItem, indexPath: IndexPath) -> UITableViewCell {
        if let cell: ProductShortDescriptionTableViewCell = tableView.dequeueReusableCell(with: ProductShortDescriptionTableViewCell.self, for: indexPath) {
            if let item = item as? ProductViewModalShortDescriptionItem {
                cell.selectionStyle = .none
                cell.shortDescription.text = item.shortDescription
                cell.lineView.isHidden = false
                return cell
            }
            if let item = item as? ProductViewModalTierPriceItem {
                cell.selectionStyle = .none
                cell.shortDescription.text = item.tierPrice
                cell.lineView.isHidden = true
                return cell
            }
        }
        tableView.separatorStyle = .none
        return UITableViewCell()
    }
    
   
    
    func loadQuantity(tableView: UITableView, item: ProductViewModalItem, indexPath: IndexPath) -> UITableViewCell {
        if let cell: ProductQuantityViewTableViewCell = tableView.dequeueReusableCell(with: ProductQuantityViewTableViewCell.self, for: indexPath),
            let _ = item as? ProductViewModalQuantityItem {
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func loadBuyNow(tableView: UITableView, item: ProductViewModalItem, indexPath: IndexPath) -> UITableViewCell {
        if let cell: ProductCartViewTableViewCell = tableView.dequeueReusableCell(with: ProductCartViewTableViewCell.self, for: indexPath),
            let _ = item as? ProductViewModalBuyNowItem {
            if parentController == "cart" {
                cell.addToCartBtn.setTitle("Update Cart".localized, for: .normal)
            }
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        }
        tableView.separatorStyle = .none
        return UITableViewCell()
    }
    
    func loadDescription(tableView: UITableView, item: ProductViewModalItem, indexPath: IndexPath) -> UITableViewCell {
        if let cell: ProductShortDescriptionTableViewCell = tableView.dequeueReusableCell(with: ProductShortDescriptionTableViewCell.self, for: indexPath),
            let item = item as? ProductViewModalDescriptionItem {
            cell.selectionStyle = .none
            cell.shortDescription.attributedText = item.description
            return cell
        }
        tableView.separatorStyle = .none
        return UITableViewCell()
    }
    
    func loadFeatures(tableView: UITableView, item: ProductViewModalItem, indexPath: IndexPath) -> UITableViewCell {
        if let cell: ProsuctFeaturesTableViewCell = tableView.dequeueReusableCell(with: ProsuctFeaturesTableViewCell.self, for: indexPath),
            let item = item as? ProductViewModalFeaturesItem {
            cell.selectionStyle = .none
            if indexPath.row == 0 {
                cell.lineView.isHidden = true
            } else {
                cell.lineView.isHidden = false
            }
            cell.item = item.additionalInf[indexPath.row]
            return cell
        }
        tableView.separatorStyle = .none
        return UITableViewCell()
    }
    
    func loadReviews(tableView: UITableView, item: ProductViewModalItem, indexPath: IndexPath) -> UITableViewCell {
        if let cell: ProductReviewDataTableViewCell = tableView.dequeueReusableCell(with: ProductReviewDataTableViewCell.self, for: indexPath),
            let item = item as? ProductViewModalReviewsItem {
            cell.selectionStyle = .none
            cell.item = item.reviewList[indexPath.row]
            tableView.separatorStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func loadRelated(tableView: UITableView, item: ProductViewModalItem, indexPath: IndexPath) -> UITableViewCell {
        if let cell: RelatedProductTableViewCell = tableView.dequeueReusableCell(with: RelatedProductTableViewCell.self, for: indexPath),
            let items = item as? ProductViewModalRelatedProductsItem {
            cell.obj = self
            cell.selectionStyle = .none
            cell.headingLabelClicked.text = item.heading
            cell.relatedList = items.relatedList
            cell.viewAllBtn.isHidden = true
            cell.collectionView.reloadData()
            return cell
        }
        tableView.separatorStyle = .none
        return UITableViewCell()
    }
    
    func loadUpsell(tableView: UITableView, item: ProductViewModalItem, indexPath: IndexPath) -> UITableViewCell {
        if let cell: RelatedProductTableViewCell = tableView.dequeueReusableCell(with: RelatedProductTableViewCell.self, for: indexPath),
            let items = item as? ProductViewModalUpSellProductsItem {
            cell.obj = self
            cell.selectionStyle = .none
            cell.headingLabelClicked.text = item.heading
            cell.relatedList = items.upSellList
            cell.viewAllBtn.isHidden = true
            cell.collectionView.reloadData()
            return cell
        }
        tableView.separatorStyle = .none
        return UITableViewCell()
    }
    
    func loadGrouped(tableView: UITableView, item: ProductViewModalItem, indexPath: IndexPath) -> UITableViewCell {
        if let cell: GroupProductTableViewCell = tableView.dequeueReusableCell(with: GroupProductTableViewCell.self, for: indexPath),
            let items = item as? ProductViewModalGroupedItem {
            //cell.index = indexPath.row
            cell.section = indexPath.section
            cell.index = items.gropedData[indexPath.row].id
            cell.groupedDict = self.groupedDict
            cell.selectionStyle = .none
            cell.delegate = self
            cell.item = items.gropedData[indexPath.row]
            tableView.separatorStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func loadSamples(tableView: UITableView, item: ProductViewModalItem, indexPath: IndexPath) -> UITableViewCell {
        if let items = item as? ProductViewModalSampleDownloadableItem {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.selectionStyle = .none
            cell.textLabel?.text = items.samples.linkSampleData[indexPath.row].sampleTitle
            cell.textLabel?.textColor = UIColor.blue
            tableView.separatorStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func loadLinks(tableView: UITableView, item: ProductViewModalItem, indexPath: IndexPath) -> UITableViewCell {
        if let cell: LinkDataTableViewCell = tableView.dequeueReusableCell(with: LinkDataTableViewCell.self, for: indexPath),
            let items = item as? ProductViewModalLinksDownloadableItem {
            cell.selectionStyle = .none
            cell.headingLabel.text = items.links.title
            cell.items = items.links.linkData
            cell.delegate = self
            tableView.separatorStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func loadBundle(tableView: UITableView, item: ProductViewModalItem, indexPath: IndexPath) -> UITableViewCell {
        if let item = item as? ProductViewModalBundleItem {
            switch item.bundleData[indexPath.row].type {
            case "select":
                if let cell: BundleDropDownTableViewCell = tableView.dequeueReusableCell(with: BundleDropDownTableViewCell.self, for: indexPath) {
                    var items = item
                    if self.bundleDict[items.bundleData[indexPath.row].optionId] != nil {
                        if let val =  self.bundleDict[items.bundleData[indexPath.row].optionId] as? String,
                            let index1 = items.bundleData[indexPath.row].optionValues.firstIndex(where: {$0.optionValueId == val}) {
                            items.setValue(index1: index1)
                        }
                    } else {
                        items.value(index1: indexPath.row)
                        self.bundleDict[items.bundleData[indexPath.row].optionId] =  items.bundleData[indexPath.row].optionValues[item.selectedRow].optionValueId
                        self.bundleSelectedRow = item.selectedRow
                        cell.row = self.bundleSelectedRow
                    }
                    cell.bundleDict = self.bundleDict
                    cell.bundleQtyDict = self.bundleQtyDict
                    cell.parentID = items.bundleData[indexPath.row].optionId
                    items.setValue(index1: bundleSelectedRow)
                    cell.delegate = self
                    if items.bundleData[indexPath.row].optionValues[items.selectedRow].isQtyUserDefined == "1" {
                        cell.qtyEnable = true
                    } else {
                        cell.qtyEnable = false
                    }
                    cell.textField.text = items.bundleData[indexPath.row].optionValues[items.selectedRow].title
                    cell.qtyLabel.text = items.bundleData[indexPath.row].optionValues[items.selectedRow].defaultQty
                    cell.selectionStyle = .none
                    cell.headingLabel.text = items.bundleData[indexPath.row].defaultTitle
                    cell.optionValues = (item.bundleData[indexPath.row].optionValues)
                    return cell
                }
            case "radio":
                if let cell: BundleRadioTableViewCell = tableView.dequeueReusableCell(with: BundleRadioTableViewCell.self, for: indexPath) {
                    var items = item
                    cell.delegate = self
                    cell.imagedelegate = self
                    cell.valuedelegate = self
                    if self.bundleDict[items.bundleData[indexPath.row].optionId] != nil {
                        if let val =  self.bundleDict[items.bundleData[indexPath.row].optionId] as? String,
                            let index1 = items.bundleData[indexPath.row].optionValues.firstIndex(where: {$0.optionValueId == val}) {
                            items.setValue(index1: index1)
                        }
                    } else {
                        items.value(index1: indexPath.row)
                        self.bundleDict[items.bundleData[indexPath.row].optionId] =  items.bundleData[indexPath.row].optionValues[items.selectedRow].optionValueId
                    }
                    cell.bundleDict = self.bundleDict
                    cell.bundleQtyDict = self.bundleQtyDict
                    cell.parentID = items.bundleData[indexPath.row].optionId
                    if self.conditionforradiobtn{
                        cell.value = (self.bundleDict[items.bundleData[indexPath.row].optionId] as? String) ?? ""
                    }
                    
                      //items.bundleData[indexPath.row].optionValues[item.selectedRow].optionValueId
                    cell.selectionStyle = .none
                    cell.headingLabel.text = items.bundleData[indexPath.row].defaultTitle
                    cell.items = (items.bundleData[indexPath.row].optionValues)
                    return cell
                }
            case "checkbox", "multi":
                if let cell: BundleCheckboxTableViewCell = tableView.dequeueReusableCell(with: BundleCheckboxTableViewCell.self, for: indexPath) {
                    cell.delegate = self
                    var items = item
                    if self.bundleDict[items.bundleData[indexPath.row].optionId] != nil {
                        if let val =  self.bundleDict[items.bundleData[indexPath.row].optionId] as? String,
                            let index1 = items.bundleData[indexPath.row].optionValues.firstIndex(where: {$0.optionValueId == val}) {
                            items.setValue(index1: index1)
                        }
                    } else {
                        items.value(index1: indexPath.row)
                        self.bundleDict[items.bundleData[indexPath.row].optionId] =  items.bundleData[indexPath.row].optionValues[items.selectedRow].optionValueId
                    }
                    cell.value.append(items.bundleData[indexPath.row].optionValues[items.selectedRow].optionValueId)
                    cell.value = cell.value.removeDuplicates()
                    cell.bundleDict = self.bundleDict
                    cell.bundleQtyDict = self.bundleQtyDict
                    cell.parentID = items.bundleData[indexPath.row].optionId
                    cell.selectionStyle = .none
                    cell.headingLabel.text = items.bundleData[indexPath.row].defaultTitle
                    cell.items = (items.bundleData[indexPath.row].optionValues)
                    cell.radioTableView.reloadData()
                    return cell
                }
            default:
                return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    func loadConfigurable(tableView: UITableView, item: ProductViewModalItem, indexPath: IndexPath) -> UITableViewCell {
        if let cell: ConfigurableProductDataTableViewCell = tableView.dequeueReusableCell(with: ConfigurableProductDataTableViewCell.self, for: indexPath),
            let items = item as? ProductViewModalConfigurableItem {
            cell.delegate = self
            cell.selectedIdDict = configDict
            cell.unselectedValues = unselectedValues
            UIView.performWithoutAnimation {
                cell.collectionView.reloadData()
            }
            cell.attributes = items.configurableData.attributes
            cell.selectionStyle = .none
            cell.section = indexPath.section
            if let type = items.configurableData.attributes[indexPath.row].swatchType,
                let configurable = ConfigurableType(rawValue: type),
                let swatchData = items.configurableData.swatchData,
                let parentId = items.configurableData.attributes[indexPath.row].id,
                let json = swatchData.data(using: String.Encoding.utf8) {
                cell.swatchData = JSON(data: json)
                
                if let json = items.configurableData.index.data(using: String.Encoding.utf8) {
                    cell.indexData = JSON(data: json)
                }
                cell.parentId = parentId
                cell.type = configurable
            }
            cell.headingLabel.text = items.configurableData.attributes[indexPath.row].label
            cell.options = items.configurableData.attributes[indexPath.row].options
            cell.layoutIfNeeded()
            tableView.separatorStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func loadCustom(tableView: UITableView, item: ProductViewModalItem, indexPath: IndexPath) -> UITableViewCell {
        if let item = item as? ProductViewModalCustomOptionItem {
            switch item.customOptions[indexPath.row].type {
            case "drop_down":
                if let cell: BundleDropDownTableViewCell = tableView.dequeueReusableCell(with: BundleDropDownTableViewCell.self, for: indexPath) {
                    var items = item
                    cell.qtyView.isHidden = true
                    cell.qtyHeight.constant = 0
                    cell.customDelegate = self
                    if self.customDict[items.customOptions[indexPath.row].optionId] != nil {
                        if let val =  self.customDict[items.customOptions[indexPath.row].optionId] as? String,
                            let index1 = items.customOptions[indexPath.row].optionValues.firstIndex(where: {$0.optionValueId == val}) {
                            items.setValue(index1: index1)
                        }
                    } else {
                        items.value(index1: indexPath.row)
                        self.customDict[items.customOptions[indexPath.row].optionId] =  items.customOptions[indexPath.row].optionValues[customSelectedRow].optionValueId
                    }
                    cell.selectedIndex = { [unowned self] (selectedIndex: Int) in
                        self.customSelectedRow = selectedIndex
                    }
                    cell.customDict = self.customDict
                    cell.parentID = items.customOptions[indexPath.row].optionId
                    if items.customOptions[indexPath.row].optionValues[customSelectedRow].isQtyUserDefined == "1" {
                        cell.qtyEnable = true
                    } else {
                        cell.qtyEnable = true
                    }
                    cell.textField.text = items.customOptions[indexPath.row].optionValues[customSelectedRow].title
                    cell.qtyLabel.text = items.customOptions[indexPath.row].optionValues[customSelectedRow].defaultQty
                    cell.selectionStyle = .none
                    cell.headingLabel.text = items.customOptions[indexPath.row].defaultTitle
                    cell.optionValues = (item.customOptions[indexPath.row].optionValues)
                    return cell
                }
            case "radio":
                if let cell: BundleRadioTableViewCell = tableView.dequeueReusableCell(with: BundleRadioTableViewCell.self, for: indexPath) {
                    var items = item
                    cell.qtyView.isHidden = true
                    cell.qtyViewHeight.constant = 0
                    cell.valuedelegate = self
                    cell.customDelegate = self
                    if self.conditionforradiobtn{
                        if self.customDict[items.customOptions[indexPath.row].optionId] != nil {
                            if let val =  self.customDict[items.customOptions[indexPath.row].optionId] as? String {
                                cell.value = val
                            }
                        }
                        
                    } else {
                        items.value(index1: indexPath.row)
                        self.customDict[items.customOptions[indexPath.row].optionId] =  items.customOptions[indexPath.row].optionValues[item.selectedRow].optionValueId
                        if self.conditionforradiobtn{
                        cell.value = items.customOptions[indexPath.row].optionValues[item.selectedRow].optionValueId
                        }
                    }
                    cell.customDict = self.customDict
                    cell.parentID = items.customOptions[indexPath.row].optionId
                    if items.customOptions[indexPath.row].optionValues[item.selectedRow].isQtyUserDefined == "1" {
                        cell.qtyEnable = true
                    } else {
                        cell.qtyEnable = true
                    }
                    cell.selectionStyle = .none
                    cell.headingLabel.text = items.customOptions[indexPath.row].defaultTitle
                    cell.items = (item.customOptions[indexPath.row].optionValues)
                    return cell
                }
            case "checkbox", "multi", "multiple":
                if let cell: BundleCheckboxTableViewCell = tableView.dequeueReusableCell(with: BundleCheckboxTableViewCell.self, for: indexPath) {
                    cell.customDelegate = self
                    var items = item
                    if self.customDict[items.customOptions[indexPath.row].optionId] != nil {
                        //                        if let val =  self.customDict[items.customOptions[indexPath.row].optionId] as? String,
                        //                            let index1 = items.customOptions[indexPath.row].optionValues.index(where: {$0.optionValueId == val}) {
                        //                            items.setValue(index1: index1)
                        //                        }
                        
                        
                            if let arr = self.customDict[items.customOptions[indexPath.row].optionId] as? [String] {
                                cell.value = arr
                        
                        }
                    } else {
                        items.value(index1: indexPath.row)
//                        self.customDict[items.customOptions[indexPath.row].optionId] =  [items.customOptions[indexPath.row].optionValues[item.selectedRow].optionValueId]
                        // AHtazaz changing start
                        self.customDict[items.customOptions[indexPath.row].optionId] = []
                        // AHtazaz changing end
//                        cell.value = [items.customOptions[indexPath.row].optionValues[item.selectedRow].optionValueId]
                    }
                    cell.customDict = self.customDict
                    cell.parentID = items.customOptions[indexPath.row].optionId
                    cell.selectionStyle = .none
                    cell.headingLabel.text = items.customOptions[indexPath.row].defaultTitle
                    cell.items = (item.customOptions[indexPath.row].optionValues)
                    return cell
                }
            case "date_time", "time", "date":
                if let cell: CustomOptionsDateAndTimeTableViewCell = tableView.dequeueReusableCell(with: CustomOptionsDateAndTimeTableViewCell.self, for: indexPath) {
                    cell.customDict = self.customDict
                    if item.customOptions[indexPath.row].type == "date_time" {
                        cell.dateType = .dateAndTime
                    } else if item.customOptions[indexPath.row].type == "time" {
                        cell.dateType = .time
                    } else if item.customOptions[indexPath.row].type == "date" {
                        cell.dateType = .date
                    }
                    cell.delegate = self
                    var items = item
                    cell.parentID = items.customOptions[indexPath.row].optionId
                    cell.selectionStyle = .none
                    cell.headingLabel.text = items.customOptions[indexPath.row].defaultTitle
                    //cell.items = (item.customOptions[indexPath.row].optionValues)
                    return cell
                }
            case "field":
                if let cell: CustomTextFieldTableViewCell = tableView.dequeueReusableCell(with: CustomTextFieldTableViewCell.self, for: indexPath) {
                    cell.customDict.removeAll()
                    cell.customDict = self.customDict
                    cell.delegate = self
                    var items = item
                    cell.parentID = items.customOptions[indexPath.row].optionId
                    cell.selectionStyle = .none
                    cell.headinglabel.text = items.customOptions[indexPath.row].defaultTitle
                    return cell
                }
            case "area":
                if let cell: CustomTextFieldTableViewCell = tableView.dequeueReusableCell(with: CustomTextFieldTableViewCell.self, for: indexPath) {
                    cell.customDict.removeAll()
                    cell.customDict = self.customDict
                    cell.delegate = self
                    var items = item
                    cell.parentID = items.customOptions[indexPath.row].optionId
                    cell.selectionStyle = .none
                    cell.headinglabel.text = items.customOptions[indexPath.row].defaultTitle
                    return cell
                }
            case "file":
                if let cell: CustomOptionImageUploadTableViewCell = tableView.dequeueReusableCell(with: CustomOptionImageUploadTableViewCell.self, for: indexPath) {
                    cell.customDataDict.removeAll()
                    cell.customDataDict = self.customDataDict
                    cell.delegate = self
                    var items = item
                    cell.parentID = items.customOptions[indexPath.row].optionId
                    cell.headingLabel.text = items.customOptions[indexPath.row].defaultTitle
                   
                    if uploadFileisVisible {
                        cell.isHidden = false
                        cell.tag = 010
                    }else{
                          cell.isHidden = true
                    }
             
                    return cell
                }
            default:
                return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    func collapseChange(view: UITableViewHeaderFooterView, section: Int, type: ProductItemTyoe) {
        switch type {
        case .description:
            if let view = view as? ProductSectionHeading {
                if collapseDescription {
                    collapseDescription = false
                } else {
                    collapseDescription = true
                }
                view.arrowLabel?.rotate(collapseDescription ? 0.0 : .pi)
            }
            reloadSections?(section, !collapseDescription)
        case .features:
            if let view = view as? ProductSectionHeading {
                if collapseFeatures {
                    collapseFeatures = false
                } else {
                    collapseFeatures = true
                }
                view.arrowLabel?.rotate(collapseFeatures ? 0.0 : .pi)
            }
            reloadSections?(section, !collapseFeatures)
        case .reviews:
            if let view = view as? ReviewHeaderView {
                if collapseReviews {
                    collapseReviews = false
                } else {
                    collapseReviews = true
                }
                view.arrowLabel?.rotate(collapseReviews ? 0.0 : .pi)
            }
            reloadSections?(section, !collapseReviews)
        default:
            print("")
        }
    }
}

extension ProductPageViewModal {
    
    func notifyPrice() {
        self.whichApiCall = .notifyPrice
        self.callingHttppApi { (_) in
            
        }
    }
    
    func notifyStock() {
        self.whichApiCall = .notifyStock
        self.callingHttppApi { (_) in
            
        }
    }
}
