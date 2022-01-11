import Foundation
import UIKit

protocol SeachProtocols: class {
    func productListFromQuery(query: String)
    func productListFromCategory(id: String, name: String)
    func productFromCategory(id: String, name: String)
    func productFromSubCategory(id: String, name: String)
    
}

class SearchViewModel: NSObject {
    weak var tableView: UITableView?
    var items = [SearchViewModelItem]()
    var products = [SearchSuggestionProduct]()
    var suggestions = [SearchSuggestion]()
    var categories = [Categories]()
    private var throttler: Throttler?
    weak var delegate: SeachProtocols?
    
    func serachQueryText(query: String, taskCallback: @escaping (Bool) -> Void) {
        defer {
            self.throttler?.throttle(searchText: query) {[weak self](products, suggestions) in
                self?.throttler = nil
                self?.products = products
                self?.suggestions = suggestions
                taskCallback(true)
            }
        }
        guard self.throttler != nil else {
            self.throttler = Throttler()
            return
        }
    }
    
    func reloadInfoWithData() {
        items.removeAll()
        if !products.isEmpty {
            let item = SearchViewModelSuggestionItem(products: products)
            self.items.append(item)
        }
        if let data = getSearchedQuery(), !data.isEmpty {
            let item = SearchViewModelRecentSearchItem(suggestions: data)
            self.items.append(item)
        }
        if !categories.isEmpty {
            let item = SearchViewModelCategoryItem(categories: categories)
            self.items.append(item)
        }
        self.tableView?.reloadData()
    }
}

extension SearchViewModel: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].tableRowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .suggestions:
            if let item = item as? SearchViewModelSuggestionItem {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                //cell.textLabel?.text = item.products[indexPath.row].productName.html2String
                
                if item.products[indexPath.row].hasSpecialPrice {
                    let productName = item.products[indexPath.row].productName.html2String + "\n" + item.products[indexPath.row].price + "\n" + item.products[indexPath.row].specialPrice
                    let somePartStringRange = (productName as NSString).range(of: item.products[indexPath.row].specialPrice)
                    let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: productName)
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: somePartStringRange)
                    cell.textLabel?.attributedText = attributeString
                } else {
                    cell.textLabel?.text = item.products[indexPath.row].productName.html2String + "\n" + item.products[indexPath.row].price
                }
                cell.textLabel?.numberOfLines = 0
                if Defaults.language == "ar" {
                    cell.textLabel?.textAlignment = .right
                } else {
                    cell.textLabel?.textAlignment = .left
                }
                return cell
            }
        case .recentSearch:
            if let item = item as? SearchViewModelRecentSearchItem {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                cell.textLabel?.text = item.recentSearch[indexPath.row].searchSuggestions
                cell.accessoryType = UITableViewCell.AccessoryType.none
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                imageView.image = UIImage(named: "sharp-remove")
                cell.accessoryView = imageView
                cell.accessoryView?.addTapGestureRecognizer {
                    self.removeSearchedQuery(index: indexPath.row)
                }
                if Defaults.language == "ar" {
                    cell.textLabel?.textAlignment = .right
                } else {
                    cell.textLabel?.textAlignment = .left
                }
                cell.selectionStyle = .none
                return cell
            }
        case .categories:
            if let item = item as? SearchViewModelCategoryItem {
                if let cell = tableView.dequeueReusableCell(with: SearchCategoryTableViewCell.self, for: indexPath) {
                    cell.delegate = self.delegate
                    cell.categories = item.categories
                    cell.categoryCollectionView.reloadData()
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.section]
        switch item.type {
        case .suggestions:
            self.delegate?.productFromCategory(id: products[indexPath.row].productId, name: products[indexPath.row].productName.html2String)
        //            self.delegate?.productListFromQuery(query: suggestions[indexPath.row].label.html2String)
        case .recentSearch:
            if let string = getSearchedKey(index: indexPath.row) {
                delegate?.productListFromQuery(query: string)
            }
            print()
        //            self.removeSearchedQuery(index: indexPath.row)
        case .categories:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let item = items[section]
        switch item.type {
        case .suggestions:
            return nil
        case .recentSearch:
            let view = SearchHeader(frame: CGRect(x: 0, y: 0, width: AppDimensions.screenWidth, height: 50))
            view.nameLbl.text = "Recent Searches".localized
            view.clearBtn.setTitle("Clear All".localized, for: .normal)
            view.clearBtn.addTapGestureRecognizer {
                if let database = DBManager.sharedInstance.database {
                    try? SearchModel.self.deleteAll(in: database)
                    self.reloadInfoWithData()
                }
                
            }
            return view
        case .categories:
            let view = SearchHeader(frame: CGRect(x: 0, y: 0, width: AppDimensions.screenWidth, height: 50))
            view.nameLbl.text = "Categories".localized
            view.clearBtn.setTitle("", for: .normal)
            view.clearBtn.isHidden = true
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let item = items[section]
        switch item.type {
        case .suggestions:
            return CGFloat.leastNonzeroMagnitude
        case .recentSearch:
            return 50
        case .categories:
            return 50
        }
    }
    
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //        if let data = getSearchedQuery() {
        //            do {
        //                try DBManager.sharedInstance.database?.write {
        //                    DBManager.sharedInstance.database?.delete(data[indexPath.row])
        //                }
        //            } catch  let error {
        //                print(error.localizedDescription)
        //            }
        //            DispatchQueue.main.async {
        //                self.tableView?.reloadData()
        //            }
        //        }
    }
    
    func getSearchedQuery() -> [SearchModel]? {
        if let data = DBManager.sharedInstance.database?.objects(SearchModel.self) {
            return Array(data)
        } else {
            return nil
        }
    }
    
    func getSearchedKey(index: Int) -> String? {
        if let data = DBManager.sharedInstance.database?.objects(SearchModel.self) {
            return Array(data)[index].searchSuggestions
        } else {
            return nil
        }
    }
    
    func removeSearchedQuery(index: Int) {
        if let data = getSearchedQuery() {
            do {
                try DBManager.sharedInstance.database?.write {
                    DBManager.sharedInstance.database?.delete(data[index])
                }
            } catch  let error {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.reloadInfoWithData()
            }
        }
    }
}

extension SearchViewModel: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text, text.count > 0 {
            delegate?.productListFromQuery(query: text)
            if Defaults.searchEnable == "1" {
                self.addSearcheQueryToDatabase(text: text)
            }
            
        }
        return true
    }
    
    func addSearcheQueryToDatabase(text: String) {
        let searchedData = SearchModel(data: text)
        do {
            try DBManager.sharedInstance.database?.write {
                DBManager.sharedInstance.database?.add(searchedData, update: .all)
            }
        } catch  let error {
            print(error.localizedDescription)
        }
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
}

