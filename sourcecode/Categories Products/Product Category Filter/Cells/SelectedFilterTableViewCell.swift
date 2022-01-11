//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: SelectedFilterTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit
import TagListView

class SelectedFilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tagView: TagListView!
    override func awakeFromNib() {
        super.awakeFromNib()
        tagView.textColor = UIColor.blue
        tagView.tagBackgroundColor = UIColor.clear
        tagView.selectedTextColor = UIColor.blue
        tagView.borderWidth = 0.5
        tagView.borderColor = UIColor.black
        tagView.cornerRadius = 2
        tagView.paddingX = 5
        tagView.alignment = .center
        tagView.textFont = UIFont.systemFont(ofSize: 16)
        tagView.enableRemoveButton = true
        tagView.removeIconLineColor = UIColor.black
    }
    
    var blogTags: [String]! {
        didSet {
            tagView.removeAllTags()
            for tagData in blogTags! {
                tagView.addTag(tagData)
            }
        }
    }
}
