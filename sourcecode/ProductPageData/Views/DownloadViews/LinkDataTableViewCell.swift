//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: LinkDataTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit
import MobileCoreServices

class LinkDataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var checkboxTableView: UITableView!
    @IBOutlet weak var headingLabel: UILabel!
    var options = [LinkData]()
    var value = [String]()
    weak var delegate: GettingDownloadableData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkboxTableView.register(cellType: LinkSelectionTableViewCell.self)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var items: [LinkData]! {
        didSet {
            self.options = items
            self.tableViewHeight.constant = CGFloat(options.count * 54)
            self.checkboxTableView.delegate = self
            self.checkboxTableView.dataSource = self
            self.checkboxTableView.reloadData()
        }
    }
}

extension LinkDataTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: LinkSelectionTableViewCell = tableView.dequeueReusableCell(with: LinkSelectionTableViewCell.self, for: indexPath) {
            cell.selectionImage.image = UIImage(named: "icon-radio-off")
            if  value.contains(options[indexPath.row].id) {
                cell.selectionImage.image = UIImage(named: "icon-radio-on")
            }
            cell.labelData.text = options[indexPath.row].linkTitle
            cell.btn.setTitle(options[indexPath.row].linkSampleTitle, for: .normal)
            cell.btn.addTapGestureRecognizer {
                self.open(row: indexPath.row)
            }
            cell.selectionStyle = .none
            return cell
        }
        //
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = value.firstIndex(of: options[indexPath.row].id) {
            value.remove(at: index)
        } else {
            value.append(options[indexPath.row].id)
        }
        delegate?.gettingDownloadableData(data: (value.toDictionary { String(value.firstIndex(of: $0)!) }))
        self.checkboxTableView.reloadData()
    }
    
    func open(row: Int) {
        
        let mimeType: CFString = options[row].mimeType as CFString
        guard
            let mimeUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType, nil)?.takeUnretainedValue()
            else { return }
        
        guard
            let extUTI = UTTypeCopyPreferredTagWithClass(mimeUTI, kUTTagClassFilenameExtension)
            else { return }
        
        print(extUTI.takeRetainedValue() as String)
        
        let ext = options[row].linkSampleTitle + "." + (extUTI.takeRetainedValue() as String)
        NetworkManager.sharedInstance.download(downloadUrl: options[row].url, saveUrl: ext, completion: { (_, results) in
            print("Success post title:", results)
        })
    }
}
