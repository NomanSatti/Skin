//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ConfigurableProductDataTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit
import Kingfisher
import ActionSheetPicker_3_0

class ConfigurableProductDataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headingLabel: UILabel!
    
    var selectedIdDict = [String: String]()
    var unselectedValues = [String]()
    weak var delegate: GettingConfigurableData?
    var type: ConfigurableType = .text
    var swatchData: JSON = ""
    var indexData: JSON = ""
    var options = [Options]()
    var parentId = ""
    var section = 0
    var attributes = [Attributes]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.reloadData()
        collectionView.register(cellType: ConfigurableProductTextCollectionViewCell.self)
        collectionView.register(cellType: ConfigurableVisualCollectionViewCell.self)
        collectionView.register(cellType: ConfigurableTextCollectionViewCell.self)
        collectionView.register(cellType: ConfigurableDropDownCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension ConfigurableProductDataTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if type == .dropDown {
            return 1
        }
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch type {
        case .dropDown:
            if let cell: ConfigurableDropDownCollectionViewCell = collectionView.dequeueReusableCell(with: ConfigurableDropDownCollectionViewCell.self, for: indexPath) {
                cell.dropDownBtn.applyBorder(colours: UIColor.black)
                cell.dropDownBtn.setTitle("Choose an Option".localized, for: .normal)
                if let value = selectedIdDict[parentId], let index = options.firstIndex(where: { $0.id == value }) {
                    cell.dropDownBtn.setTitle(options[index].label, for: .normal)
                }
                cell.dropDownBtn.addTapGestureRecognizer {
                    self.dropDown(collectionView: collectionView, indexPath: indexPath, btn: cell.dropDownBtn)
                }
                return cell
            }
        case .text:
            if let cell: ConfigurableTextCollectionViewCell = collectionView.dequeueReusableCell(with: ConfigurableTextCollectionViewCell.self, for: indexPath) {
                cell.configurableLabel.layer.borderColor = UIColor.clear.cgColor
                if unselectedValues.contains(options[indexPath.row].id) {
                    cell.diagonalView.isHidden = false
                } else {
                    cell.diagonalView.isHidden = true
                }
                cell.configurableLabel.text = options[indexPath.row].label
                cell.configurableLabel.backgroundColor = AppStaticColors.shadedColor
                cell.configurableLabel.addTapGestureRecognizer {
                    self.didSelectItemAt(collectionView: collectionView, indexPath: indexPath)
                }
                if let value = selectedIdDict[parentId], value == options[indexPath.row].id {
                    cell.configurableLabel.backgroundColor = .black
                    cell.configurableLabel.textColor = .white
                } else {
                    cell.configurableLabel.backgroundColor = AppStaticColors.shadedColor
                    cell.configurableLabel.textColor = .black
                }
                return cell
            }
        case .visual:
            if let cell: ConfigurableVisualCollectionViewCell = collectionView.dequeueReusableCell(with: ConfigurableVisualCollectionViewCell.self, for: indexPath) {
                cell.imageView.layer.borderColor = UIColor.clear.cgColor
                if unselectedValues.contains(options[indexPath.row].id) {
                    cell.diagonalView.isHidden = false
                } else {
                    cell.diagonalView.isHidden = true
                }
                cell.imageView.clipsToBounds = true
                if swatchData[parentId][options[indexPath.row].id ?? ""]["type"].stringValue == "2" {
                    print(indexPath.row)
                    if let value = selectedIdDict[parentId], value == options[indexPath.row].id {
                        cell.subImageView.image = UIImage(named: "sharp-done-24px-bright")
                        cell.imageView.applyConfigBorder(colours: UIColor.black)
                    } else {
                        cell.imageView.applyBorder(colours: UIColor.gray)
                        cell.subImageView.image = nil
                    }
                    cell.imageView.backgroundColor = UIColor.clear
                    let url =  swatchData[parentId][options[indexPath.row].id ?? ""]["thumb"].stringValue
                    cell.imageView.setImage(fromURL: url)
                    cell.imageView.addTapGestureRecognizer {
                        self.didSelectItemAt(collectionView: collectionView, indexPath: indexPath)
                    }
                } else if swatchData[parentId][options[indexPath.row].id ?? ""]["type"].stringValue == "1" {
                    if let value = selectedIdDict[parentId], value == options[indexPath.row].id {
                        if (swatchData[parentId][options[indexPath.row].id ?? ""]["value"].stringValue).contains("ffffff") {
                            let origImage = UIImage(named: "sharp-done-24px-bright")
                            let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                            cell.subImageView.image = tintedImage
                            cell.subImageView.tintColor = UIColor.black
                        } else {
                            cell.subImageView.image = UIImage(named: "sharp-done-24px-bright")
                            cell.subImageView.tintColor = UIColor.white
                        }
                        cell.imageView.applyConfigBorder(colours: UIColor.black)
                    } else {
                        cell.imageView.applyBorder(colours: UIColor.gray)
                        cell.subImageView.image = nil
                    }
                    cell.imageView.image = nil
                    cell.imageView.backgroundColor = UIColor.clear
                    cell.imageView.backgroundColor = UIColor().hexToColor(hexString: swatchData[parentId][options[indexPath.row].id ?? ""]["value"].stringValue)
                    cell.imageView.addTapGestureRecognizer {
                        self.didSelectItemAt(collectionView: collectionView, indexPath: indexPath)
                    }
                    cell.layoutIfNeeded()
                }
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func setUnselectedValues(optionId: String) {
        let intersectarray = self.gettingIntersectValue()
        let keysArray = Array(selectedIdDict.keys)
        for i in 0..<attributes.count {
            var check = false
            var checkOptionId: Int?
            if !keysArray.contains(attributes[i].id ?? "") {
                for j in 0..<attributes[i].options.count {
                    if (attributes[i].options[j].products.intersection(from: intersectarray)).count > 0 {
                        check = true
                        checkOptionId = nil
                    } else {
                        checkOptionId = j
                        check = false
                    }
                }
                if check {
                } else {
                    if let checkOptionId = checkOptionId {
                        unselectedValues.append(attributes[i].options[checkOptionId].id)
                    }
                }
            }
        }
        unselectedValues = unselectedValues.removeDuplicates()
        print(unselectedValues)
    }
    
    func gettingIntersectValue() -> [String] {
        let valuesArray = Array(selectedIdDict.values)
        var array = [[String]]()
        for i in 0..<attributes.count {
            for j in 0..<attributes[i].options.count {
                if valuesArray.contains(attributes[i].options[j].id) {
                    array.append(attributes[i].options[j].products)
                }
            }
        }
        var newArray = [String]()
        for i in 0..<array.count {
            if newArray.count > 0 {
                newArray =   newArray.intersection(from: array[i])
            } else {
                if  i+1 < array.count {
                    newArray =  array[i].intersection(from: array[i+1])
                } else {
                    newArray =  array[i]
                }
            }
        }
        print(newArray)
        return newArray
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch type {
        case .dropDown:
            return CGSize(width: self.collectionView.frame.width - 16, height: 32)
        case .text:
            return CGSize(width: (options[indexPath.row].label?.widthOfString(usingFont: UIFont.boldSystemFont(ofSize: 14)))! + 18, height: 32)
        case .visual:
            return CGSize(width: 44, height: 32)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch type {
        case .dropDown:
            break
        case .text, .visual:
            self.didSelectItemAt(collectionView: collectionView, indexPath: indexPath)
        }
    }
    
    func didSelectItemAt(collectionView: UICollectionView, indexPath: IndexPath) {
        if !unselectedValues.contains(options[indexPath.row].id ) {
            selectedIdDict[parentId] = options[indexPath.row].id
            self.setUnselectedValues(optionId: options[indexPath.row].id)
            delegate?.gettingConfigurablData(data: selectedIdDict, unselectedValues: unselectedValues, productId: self.getProductId(), optionProductId: options[indexPath.row].products.first)
            self.reload()
        }
    }
    
    func getProductId() -> String? {
        var selectedArray = [JSON]()
        for (key, value) in selectedIdDict {
            selectedArray += (self.gettingCommonIndex(key: key, value: value))
        }
        var val: String? = nil
        while let c = selectedArray.popLast()  {
            selectedArray.forEach() {
                if $0 == c {
                    Swift.print("Duplication: \(c)")
                    val = c["product"].stringValue
                }
            }
        }
        return val
    }
    
    func gettingCommonIndex(key: String, value: String) -> [JSON] {
        let arr = indexData.arrayValue
        return arr.filter { $0[key].stringValue ==  value }
    }
    
    func reload() {
        if let tableView = self.superview as? UITableView {
            UIView.performWithoutAnimation {
                tableView.reloadSections([section], with: .none)
                tableView.beginUpdates()
                tableView.endUpdates()
                
                //tableView.layer.removeAllAnimations()
                //let loc = tableView.contentOffset
                //tableView.setContentOffset(loc, animated: false)
                //tableView.beginUpdates()
                //tableView.setContentOffset(loc, animated: false)
                //tableView.reloadSections([section], with: .none)
                //tableView.setContentOffset(loc, animated: false)
                //tableView.endUpdates()
                //tableView.setContentOffset(loc, animated: false)
            }
        }
    }
    
    func dropDown(collectionView: UICollectionView, indexPath: IndexPath, btn: UIButton) {
        for i in 0..<unselectedValues.count {
            if let index = options.firstIndex(where: { $0.id == unselectedValues[i] }) {
                options.remove(at: index)
            }
        }
        let gg =  ActionSheetStringPicker(title: headingLabel.text ?? "", rows: options.map { $0.label }, initialSelection: 0, doneBlock: { _, indexes, _  in
            self.selectedIdDict[self.parentId] = self.options[indexes].id
            self.setUnselectedValues(optionId: self.options[indexPath.row].id)
            self.delegate?.gettingConfigurablData(data: self.selectedIdDict, unselectedValues: self.unselectedValues, productId: self.getProductId(), optionProductId: self.options[indexPath.row].products.first)
            self.reload()
        }, cancel: { _ in
            return }, origin: self)
        gg?.setCancelButton(UIBarButtonItem.init(title: "Cancel".localized, style: .done, target: self, action: nil))
        gg?.setDoneButton(UIBarButtonItem.init(title: "Done".localized, style: .done, target: self, action: nil))
        gg?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]//this is actually the title of toolbar
        gg?.toolbarButtonsColor = UIColor.black
        gg?.show()
    }
}

enum ConfigurableType: String {
    case visual = "visual"
    case text = "text"
    case dropDown = ""
}

@IBDesignable class DiagonalLine: UIView {
    
    @IBInspectable var lineWidth: CGFloat = 1
    @IBInspectable var flip: Bool = false
    @IBInspectable var color: UIColor = UIColor.black
    
    override func draw(_ rect: CGRect) {
        let aPath = UIBezierPath()
        aPath.lineWidth = self.lineWidth
        if self.flip {
            aPath.move(to: CGPoint(x: 0, y: 0))
            aPath.addLine(to: CGPoint(x: rect.width, y: rect.height))
        } else {
            aPath.move(to: CGPoint(x: 0, y: rect.height))
            aPath.addLine(to: CGPoint(x: rect.width, y: 0))
        }
        aPath.close()
        self.color.set()
        aPath.stroke()
    }
}

//extension Sequence where Element : Hashable {
//    func contains(_ elements: [Element]) -> Bool {
//        return Set(elements).isSubset(of:Set(self))
//    }
//}

extension Array where Element: Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
    
    func containDuplicates() -> [Element] {
        var result = [Element]()
        for value in self {
            if result.contains(value) == true {
                result.append(value)
            }
        }
        return result
    }
}

extension Array where Element: Hashable {
    func intersection(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.intersection(otherSet))
    }
}

//extension Sequence {
//    func frequencies( isEquivalent: (Iterator.Element,Iterator.Element) -> Bool) -> [(Iterator.Element,Int)] {
//        var frequency: [(Iterator.Element,Int)] = []
//
//        for x in self {
//
//            // find the index of the equivalent entry
//            if let idx = frequency.firstIndex(where: { isEquivalent($0.0, x)}) {
//                // and bump the frequency
//                frequency[idx].1 += 1
//            }
//            else {
//                // add a new entry
//                frequency.append((x,1))
//            }
//
//        }
//
//        return frequency.sort { $0.1 > $1.1 }
//    }
//}
