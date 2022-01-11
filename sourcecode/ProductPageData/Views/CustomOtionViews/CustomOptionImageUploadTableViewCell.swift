//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CustomOptionImageUploadTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class CustomOptionImageUploadTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var imageTop: UIImageView!
    var customDataDict = [String: FileInfo]()
    var parentID = ""
    weak var delegate: GettingCustomData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageTop.layer.masksToBounds = true
        imageTop.layer.borderWidth = 1
        imageTop.layer.borderColor = UIColor.lightGray.cgColor
        imageTop.isUserInteractionEnabled = true
        imageTop.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
        // Initialization code
    }
    
    @objc private func didTapHeader() {
        print("fsfskfhs")
        self.passData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func passData() {
        if let obj = self.viewContainingController {
            let alert = UIAlertController(title: "UPLOAD".localized, message: nil, preferredStyle: .actionSheet)
            
            let takeAction = UIAlertAction(title: "Take a photo".localized, style: .default, handler: take)
            let upload = UIAlertAction(title: "Upload from library".localized, style: .default, handler: uploadImage)
            let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: cancel)
            
            alert.addAction(takeAction)
            alert.addAction(upload)
            alert.addAction(cancelAction)
            alert.popoverPresentationController?.sourceView = obj.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: obj.view.bounds.size.width / 2.0, y: obj.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
            
            obj.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func take(alertAction: UIAlertAction!) {
        if let obj = self.viewContainingController {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = false
            picker.delegate = self
            obj.present(picker, animated: true, completion: nil)
        }
    }
    func uploadImage(alertAction: UIAlertAction!) {
        if let obj = self.viewContainingController {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = false
            obj.present(picker, animated: true, completion: nil)
        }
        
    }
    func cancel(alertAction: UIAlertAction!) {
        
    }
    
    @IBAction func cameraPressed(_ sender: Any) {
        self.passData()
    }
    
}
extension CustomOptionImageUploadTableViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print(image)
            self.imageTop.image = image
            if let data = image.jpegData(compressionQuality: 0.8) {
                print(data)
                let fileKey = "options_"+parentID+"_file"
                let fileInfo = FileInfo(fileKey: fileKey, fileName: "image.jpeg", fileData: data)
                customDataDict[parentID] = fileInfo
                delegate?.gettingCustomFileData(data: customDataDict)
            }
        }
        if let obj = self.viewContainingController {
            obj.dismiss(animated: true, completion: nil)
        }
    }
    
}
