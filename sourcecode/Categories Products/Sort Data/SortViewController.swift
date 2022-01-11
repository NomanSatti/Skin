//
//  SortViewController.swift
//  Mobikul Single App
//
//  Created by akash on 19/01/19.
//  Copyright © 2019 kunal. All rights reserved.
//

import UIKit

@objc protocol SortingDelegate: class {
    func sortBy(index: Int)
}

class SortViewController: UIViewController {
    
    @IBOutlet weak var sortListTableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    var getSortCollectionData = [SortingData]()
    weak var delegate: SortingDelegate?
    var selectedSortIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CGFloat((getSortCollectionData.count + 1) * 60) < AppDimensions.screenHeight - 60 {
            self.sortListTableView.isScrollEnabled = false
            self.tableHeight.constant = CGFloat((getSortCollectionData.count + 1) * 60)
        } else {
            self.sortListTableView.isScrollEnabled = true
            self.tableHeight.constant = AppDimensions.screenHeight - 60
        }
        self.view.isOpaque = false
        self.sortListTableView.register(SortTableViewCell.nib, forCellReuseIdentifier: SortTableViewCell.identifier)
        self.sortListTableView.delegate = self
        self.sortListTableView.dataSource = self
        self.sortListTableView.reloadData()
        //NetworkManager.sharedInstance.presentView(Duration: 1.0, direction: .bottom, animateView: self.sortListTableView)
    }
    
    @IBAction func tapDismissBtn(_ sender: Any) {
        //NetworkManager.sharedInstance.dissmissView(Duration: 1.0, direction: .bottom, animateView: self.sortListTableView, dissmissView: self.view)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SortViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: AppDimensions.screenWidth - 15, height: 60))
        lbl.text = "sortby".localized
        lbl.font = UIFont.boldSystemFont(ofSize: 17.0)
        view.addSubview(lbl)
        view.backgroundColor = .white
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getSortCollectionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SortTableViewCell.identifier) as? SortTableViewCell {
            cell.textLbl.text = getSortCollectionData[indexPath.row].label
            if let selected = selectedSortIndex, selected == indexPath.row {
                cell.radioBtn.isSelected = true
            } else {
                cell.radioBtn.isSelected = false
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sortBy(index: indexPath.row)
        self.dismiss(animated: true, completion: nil)
    }
    
}
