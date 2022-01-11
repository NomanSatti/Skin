import UIKit

class CustomTableHeaderView: UIView {
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var editInfoBtn: UIButton!
    var type: String = ""
    @IBOutlet weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = 36
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bannerImage.bounds
        blurEffectView.alpha = 0.5
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bannerImage.addSubview(blurEffectView)
        editInfoBtn.setTitle("Edit Info".localized.uppercased(), for: .normal)
        
        //        stackView.shadowBorder()
    }
    
    
    @IBAction func profleClicked(_ sender: UIButton) {
        type = "profile"
        self.passData()
    }
    @IBAction func editBaneerClicked(_ sender: Any) {
        type = "banner"
        self.passData()
    }
    
    @IBAction func editInfoClicked(_ sender: UIButton) {
        let viewController = AccountInformationViewController.instantiate(fromAppStoryboard: .customer)
        self.viewContainingController?.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension CustomTableHeaderView {
    func passData() {
        
        let alert = UIAlertController(title: "UPLOAD", message: nil, preferredStyle: .actionSheet)
        
        let takeAction = UIAlertAction(title: "Take a photo", style: .default, handler: take)
        let upload = UIAlertAction(title: "Upload from library", style: .default, handler: uploadImage)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancel)
        
        alert.addAction(takeAction)
        alert.addAction(upload)
        alert.addAction(CancelAction)
        alert.popoverPresentationController?.sourceView = self
        alert.popoverPresentationController?.sourceRect = CGRect(x:self.bounds.size.width / 2.0, y: self.bounds.size.height / 2.0, width : 1.0, height : 1.0)
        
        self.viewContainingController?.present(alert, animated: true, completion: nil)
    }
    
    func take(alertAction: UIAlertAction!) {
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = false
        picker.delegate = self
        self.viewContainingController?.present(picker, animated: true, completion: nil)
    }
    func uploadImage(alertAction: UIAlertAction!) {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = false
        self.viewContainingController?.present(picker, animated: true, completion: nil)
        
    }
    func cancel(alertAction: UIAlertAction!) {
        
    }
    
}

extension CustomTableHeaderView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print(image)
            if let data = image.jpegCompressToMaxLimit() {
                print(data, data.count)
                var fileName = "image.jpeg"
                if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                    fileName = url.lastPathComponent
                }
                let fileInfo = FileInfo(fileKey: "imageFormKey", fileName: fileName, fileData: data)
                NetworkManager.sharedInstance.uploadMultipleFilesToServer(dict: [:], apiCall: type == "banner" ? .uploadBannerPic:.uploadProfilePic, fileInfo: [fileInfo]) { (success, response) in
                    if success {
                        if response["success"].boolValue {
                            if self.type == "banner" {
                                let imageUrl = response["url"].stringValue
                                Defaults.profileBanner = imageUrl
                                self.bannerImage.setImage(fromURL: Defaults.profileBanner)
                            } else {
                                let imageUrl = response["url"].stringValue
                                Defaults.profilePicture = imageUrl
                                self.profileImage.setImage(fromURL: Defaults.profilePicture)
                            }
                        } else {
                            ShowNotificationMessages.sharedInstance.warningView(message: response["message"].stringValue)
                        }
                    } else {
                        ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                    }
                }
            }
        } else {
            print("Something went wrong")
        }
        
        self.viewContainingController?.dismiss(animated: true, completion: nil)
    }
}
