//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ProductCategoryFilterViewModel.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit
import TagListView

class ProductCategoryFilterViewModel: NSObject {
    var layeredData = [LayeredData]()
    var topIdArray = [String]()
    var subIdArray = [String]()
    var subNameArray = [String]()
    weak var filterDelegate: FilterDelegate?
}

// MARK: - UITableView
extension ProductCategoryFilterViewModel: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return layeredData.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return subIdArray.count > 0 ? 1 : 0
        }
        return layeredData[section - 1].option.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0, let headerView = Bundle.main.loadNibNamed("filterHeaderView", owner: self, options: nil)?[0] as?  UIView {
            if let title = headerView.viewWithTag(11) as? UILabel {
                title.text = layeredData[section - 1].label
            }
            
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 && subIdArray.count > 0 {
            return  "Selected Filters".localized
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell: SelectedFilterTableViewCell = tableView.dequeueReusableCell(with: SelectedFilterTableViewCell.self, for: indexPath) {
                //                cell.tagView.addTag("fsjfsjf") s(subNameArray)
                cell.tagView.delegate = self
                cell.blogTags = subNameArray
                cell.selectionStyle = .none
                //                 cell.tagView.addTag("fsjfsjf")
                //                 cell.tagView.addTag("fsjfsjf")
                //
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: FilterListTableViewCell.identifier, for: indexPath) as? FilterListTableViewCell {
                cell.item = layeredData[indexPath.section - 1].option[indexPath.row]
                cell.selectedBtn.isUserInteractionEnabled = false
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section > 0 {
            if let index = layeredData[indexPath.section - 1].option.firstIndex(where: {$0.isSelected == true} ) {
                layeredData[indexPath.section - 1].option[index].isSelectd(isSelected: false)
            }
            
            if layeredData[indexPath.section - 1].option[indexPath.row ].isSelected {
                
                layeredData[indexPath.section - 1].option[indexPath.row].isSelectd(isSelected: false)
            } else {
                layeredData[indexPath.section - 1].option[indexPath.row].isSelectd(isSelected: true)
            }
            tableView.reloadData()
        }
        
    }
    
    func clearAll(completion: ( (Bool) -> Void )) {
        for i in 0..<layeredData.count {
            for j in 0..<layeredData[i].option.count {
                layeredData[i].option[j].isSelectd(isSelected: false)
            }
        }
        subNameArray.removeAll()
        subIdArray.removeAll()
        topIdArray.removeAll()
        completion(true)
    }
    
    func fetchSelectedArray(completion: ( (_ topIdArray: [String], _ subIdArray: [String], _ subNameArray: [String]) -> Void ))  {
        
        for i in 0..<layeredData.count {
            for j in 0..<layeredData[i].option.count {
                if layeredData[i].option[j].isSelected {
                    subIdArray.append(layeredData[i].option[j].id)
                    subNameArray.append(layeredData[i].option[j].label)
                    topIdArray.append(layeredData[i].code)
                }
            }
        }
        subNameArray = subNameArray.removeDuplicates()
        subIdArray = subIdArray.removeDuplicates()
        topIdArray = topIdArray.removeDuplicates()
        completion(topIdArray, subIdArray, subNameArray)
    }
}

extension ProductCategoryFilterViewModel: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) -> Void {
        //        if
        print("Tag pressed: \(title), \(sender)")
        if let index = subNameArray.firstIndex(of: title) {
            subNameArray.remove(at: index)
            subIdArray.remove(at: index)
            topIdArray.remove(at: index)
            filterDelegate?.filterData(topIdArray: topIdArray, subIdArray: subIdArray, subNameArray: subNameArray)
        }
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) -> Void {
        print("Tag pressed: \(title), \(sender)")
        if let index = subNameArray.firstIndex(of: title) {
            subNameArray.remove(at: index)
            subIdArray.remove(at: index)
            topIdArray.remove(at: index)
            filterDelegate?.filterData(topIdArray: topIdArray, subIdArray: subIdArray, subNameArray: subNameArray)
        }
    }
}
