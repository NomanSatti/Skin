import UIKit
import Alamofire
import SwiftyJSON
import SnapKit
import ActionSheetPicker_3_0
import SwiftMessages
import MaterialComponents.MaterialTextFields
import MaterialComponents.MaterialTextFields_ColorThemer

class MaintenanceViewController: UIViewController {
    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var deviceModelLabel: UILabel!
    @IBOutlet weak var problemTypeLabel: UILabel!
    @IBOutlet weak var uploadFrontImageLabel: UILabel!
    @IBOutlet weak var uploadBackImageLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var mobileNoLabel: UILabel!
    @IBOutlet weak var cityAddressLabel: UILabel!
    
    @IBOutlet weak var selectDeviceModelButton: UIButton!
    @IBOutlet weak var cityAddressTextField: CustomOutlinedTxtField!
    @IBOutlet weak var fullNameTextField: CustomOutlinedTxtField!
    @IBOutlet weak var mobileNoTextField: CustomOutlinedTxtField!
    @IBOutlet weak var problemTypeTextField: CustomOutlinedTxtField!
    
    @IBOutlet weak var doneButton: UIButton!
    
    var models = [String]()
    var bannerUrl = ""
    var selectedDevice = ""
    
    var frontImage: UIImage? {
        didSet{
            frontImageView.contentMode = .scaleAspectFill
            frontImageView.image = frontImage
        }
    }
    
    var backImage: UIImage? {
        didSet{
            backImageView.contentMode = .scaleAspectFill
            backImageView.image = backImage
        }
    }
    
    override func viewDidLoad() {
        setupViews()
        self.navigationItem.title = "Maintenance"
        getMainenanceData()
    }
    func setupViews() {
        deviceModelLabel.text = "Device Model".localized
        deviceModelLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        selectDeviceModelButton.borderWidth1 = 1
        selectDeviceModelButton.borderColor1 = .black
        selectDeviceModelButton.titleLabel?.font =  UIFont.systemFont(ofSize: 17)
        selectDeviceModelButton.setTitle("Select Device Model", for: .normal)
        selectDeviceModelButton.titleLabel!.textColor = UIColor.black
        
        problemTypeLabel.text = " Type The Problem".localized
        problemTypeLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        problemTypeTextField.textField.font = UIFont.systemFont(ofSize: 14)
        mobileNoTextField.textField.font = UIFont.systemFont(ofSize: 14)
        cityAddressTextField.textField.font = UIFont.systemFont(ofSize: 14)
        uploadFrontImageLabel.font = UIFont.boldSystemFont(ofSize: 15)
        uploadBackImageLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        fullNameLabel.text = "Full Name".localized
        fullNameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        fullNameTextField.textField.font = UIFont.boldSystemFont(ofSize: 14)
        
        mobileNoLabel.text = "Mobile Number".localized
        mobileNoLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        cityAddressLabel.text = "City & Address".localized
        cityAddressLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
    }
    private func getMainenanceData(){
        let url: String = API_ROOT_DOMAIN + "rest/V1/get-maintenance"
        var request = URLRequest(url:  NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(ADMIN_TOKEN)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        Alamofire.request(request).responseJSON { (responseObject) -> Void in
            
            if let data =  responseObject.result.value {
                
                let json = JSON(data)
                if let first = json.array?.first {
                    
                    if let banner = first["banner"].string{
                        
                        self.bannerUrl = banner
                        
                        if let models = first["models"].array{
                            
                            for model in models {
                                
                                if let new = model.string{
                                    self.models.append(new)
                                }
                                
                            }
                            
                            self.setupData()
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func setupData(){
        banner.af_setImage(withURL: URL(string: self.bannerUrl)!)
        selectDeviceModelButton.addTarget(self, action: #selector(showPicker(_:)), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        frontImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(frontImageSelected)))
        
        backImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backImageSelected)))
    }
    
    @objc private func showPicker(_ sender: UIButton)
    {
        ActionSheetStringPicker.show(withTitle: "Select Device",
                                     rows: models,
                                     initialSelection: 1,
                                     doneBlock: { picker, value, index in
                                        self.selectedDevice =  self.models[value]
                                        self.selectDeviceModelButton.setTitle(self.models[value], for: .normal)
                                        return
        },
                                     cancel: { picker in
                                        return
        },
                                     origin: sender)
        
        selectDeviceModelButton.titleLabel?.textColor = UIColor.black
    }
    
    @objc func donePressed(){
        
        self.doneButton.isEnabled = false
        
        NetworkManager.sharedInstance.showLoader()
        guard let address = cityAddressTextField.textField.text else {
            SwiftMessages.showToast(NSLocalizedString("Somthing is Missing", comment: ""))
            self.doneButton.isEnabled = true
            NetworkManager.sharedInstance.dismissLoader()
            return
            
        }
        guard let  problem = problemTypeTextField.textField.text else {
            SwiftMessages.showToast(NSLocalizedString("Somthing is Missing", comment: ""))
            self.doneButton.isEnabled = true
            NetworkManager.sharedInstance.dismissLoader()
            return
            
        }
        guard let  fullname = fullNameTextField.textField.text else {
            SwiftMessages.showToast(NSLocalizedString("Somthing is Missing", comment: ""))
            self.doneButton.isEnabled = true
            NetworkManager.sharedInstance.dismissLoader()
            return
            
        }
        guard let  mobile = mobileNoTextField.textField.text else {
            SwiftMessages.showToast(NSLocalizedString("Somthing is Missing", comment: ""))
            self.doneButton.isEnabled = true
            NetworkManager.sharedInstance.dismissLoader()
            return
            
        }
        
        guard let fImage = frontImage else {
            SwiftMessages.showToast(NSLocalizedString("Somthing is Missing", comment: ""))
            self.doneButton.isEnabled = true
            NetworkManager.sharedInstance.dismissLoader()
            return
            
        }
        
        guard let bImage = backImage else {
            SwiftMessages.showToast(NSLocalizedString("Somthing is Missing", comment: ""))
            self.doneButton.isEnabled = true
            NetworkManager.sharedInstance.dismissLoader()
            return
            
        }
        
        var parameters = [
            "params": [
                "model": self.selectedDevice,
                "problem": problem,
                "frontend_image": "data:image/png;base64," + (self.frontImage?.toBase64())!,
                "backend_image": "data:image/png;base64," + (self.backImage?.toBase64())!,
                "fullname": fullname,
                "mobile": mobile,
                "address": address
            ]
            ] as! [String: Any]
        
        
        
        
        let url: String = API_ROOT_DOMAIN + "rest/V1/maintenance"
        var request = URLRequest(url:  NSURL(string: url)! as URL)
        
        // Your request method type Get or post etc according to your requirement
        request.httpMethod = "POST"
        
        request.setValue("Bearer \(ADMIN_TOKEN)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters )
        
        Alamofire.request(request).responseJSON { (responseObject) -> Void in
            
            self.doneButton.isEnabled = true
            NetworkManager.sharedInstance.dismissLoader()
            if let data =  responseObject.result.value {
                
                
                let json = JSON(data)
                print(json)
                SwiftMessages.showToast(NSLocalizedString("Maintenance request made succesfully.", comment: ""))
            }
            
        }
        
    }
    
    @objc func frontImageSelected(){
        self.showActionSheetForImageInput { [unowned self](imageSource) in
            
            let imagePicker = UIImagePickerController()
            imagePicker.view.tag = 1
            imagePicker.delegate = self
            
            switch imageSource {
            case .camera:
                imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera:.photoLibrary;
                
            case .imageLibrary:
                imagePicker.sourceType = .photoLibrary;
            }
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func backImageSelected(){
        self.showActionSheetForImageInput { [unowned self](imageSource) in
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.view.tag = 2
            
            switch imageSource {
            case .camera:
                imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera:.photoLibrary;
                
            case .imageLibrary:
                imagePicker.sourceType = .photoLibrary;
            }
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
}


extension MaintenanceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        
        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            
            
            dismiss(animated: false) {
                DispatchQueue.main.async {
                    if picker.view.tag == 1{
                        self.frontImage = pickedImage
                    }else if picker.view.tag == 2 {
                        self.backImage = pickedImage
                    }
                    
                    
                }
            }
            
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}


class CustomOutlinedTxtField: UIView {
    private var textFieldControllerFloating: MDCTextInputControllerOutlined!
    var textField: MDCTextField!

    @IBInspectable var placeHolder: String!
    @IBInspectable var value: String!
    @IBInspectable var primaryColor: UIColor! = .black

    override open func draw(_ rect: CGRect) {
        super.draw(rect)

        textField.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)

    }
    open override func awakeFromNib() {
        super.awakeFromNib()
        setUpProperty()
    }
    func setUpProperty() {
        //Change this properties to change the propperties of text
        textField = MDCTextField(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        textField.placeholder = placeHolder
        textField.text = value

        //Change this properties to change the colors of border around text
        textFieldControllerFloating = MDCTextInputControllerOutlined(textInput: textField)

        textFieldControllerFloating.activeColor = primaryColor
        textFieldControllerFloating.floatingPlaceholderActiveColor = primaryColor
        textFieldControllerFloating.normalColor = UIColor.lightGray
        textFieldControllerFloating.inlinePlaceholderColor = UIColor.lightGray

        //Change this font to make borderRect bigger
        textFieldControllerFloating.inlinePlaceholderFont = UIFont.systemFont(ofSize: 14)
        textFieldControllerFloating.textInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))

        self.addSubview(textField)
    }
}
