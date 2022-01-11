////
////  MaintenanceViewController.swift
////  sourcecode
////
////  Created by Work on 5/19/20.
////  Copyright © 2020 ranjit. All rights reserved.
////
//
//import UIKit
//import Alamofire
//import SwiftyJSON
//import SnapKit
//import ActionSheetPicker_3_0
//import SwiftMessages
//import MaterialComponents.MaterialTextFields
//import MaterialComponents.MaterialTextFields_ColorThemer
//
//class MaintenanceViewController: UIViewController {
//    
//    var models = [String]()
//    var bannerUrl = ""
//    var selectedDevice = ""
//    
//    var frontImage: UIImage? {
//        didSet{
//            self.maintainView.frontImageView.contentMode = .scaleAspectFill
//            self.maintainView.frontImageView.image = frontImage
//        }
//    }
//    
//    var backImage: UIImage? {
//           didSet{
//               self.maintainView.backImageView.contentMode = .scaleAspectFill
//                 self.maintainView.backImageView.image = backImage
//           }
//       }
//    
//    override func viewDidLayoutSubviews() {
//        self.maintainView.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.maintainView.doneButton.frame.maxY + 100)
//    }
//    
//    lazy var maintainView: MaintainceView = {
//        
//        let x = self.view.frame.minX
//        print(self.view.safeAreaTop)
//        
//        let y = self.view.frame.minY + self.view.safeAreaTop + (self.navigationController?.navigationBar.frame.height)!
//        let width = self.view.frame.width
//        let height = self.view.frame.height - (self.view.safeAreaTop + self.view.safeAreaBottom)
//        
//        let view = MaintainceView(frame: CGRect(x: x, y: y, width: width, height: height))
//        return view
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        getMainenanceData()
//        self.navigationItem.title = "Maintenance"
//        self.view.addSubview(maintainView)
//    }
//    
//    private func getMainenanceData(){
//        let url: String = API_ROOT_DOMAIN + "rest/V1/get-maintenance"
//        var request = URLRequest(url:  NSURL(string: url)! as URL)
//        
//        // Your request method type Get or post etc according to your requirement
//        request.httpMethod = "GET"
//        
//        request.setValue("Bearer \(ADMIN_TOKEN)", forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        
//        Alamofire.request(request).responseJSON { (responseObject) -> Void in
//            
//            if let data =  responseObject.result.value {
//                
//                let json = JSON(data)
//                if let first = json.array?.first {
//                    
//                    if let banner = first["banner"].string{
//                        
//                        self.bannerUrl = banner
//                        
//                        if let models = first["models"].array{
//                            
//                            for model in models {
//                                
//                                if let new = model.string{
//                                    self.models.append(new)
//                                }
//                                
//                            }
//                            
//                            self.setupData()
//                            
//                        }
//                        
//                    }
//                    
//                }
//                
//            }
//            
//        }
//        
//    }
//    
//    func setupData(){
//        self.maintainView.banner.af_setImage(withURL: URL(string: self.bannerUrl)!)
//        self.maintainView.devicePickerView.addTarget(self, action: #selector(showPicker(_:)), for: .touchUpInside)
//        self.maintainView.doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
//        self.maintainView.frontImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(frontImageSelected)))
//        
//         self.maintainView.backImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backImageSelected)))
//        
//        self.maintainView.devicePickerView.titleLabel?.textColor = UIColor.black
//    }
//    
//    
//    @objc private func showPicker(_ sender: UIButton)
//    {
//       ActionSheetStringPicker.show(withTitle: "Select Device",
//                                          rows: models,
//                                          initialSelection: 1,
//                                          doneBlock: { picker, value, index in
//                                            self.selectedDevice =  self.models[value]
//                                             self.maintainView.devicePickerView.titleLabel?.textColor = UIColor.black
//                                            self.maintainView.devicePickerView.setTitle(self.models[value], for: .normal)
//                                             return
//                                          },
//                                          cancel: { picker in
//                                             return
//                                          },
//                                          origin: sender)
//        
//        self.maintainView.devicePickerView.titleLabel?.textColor = UIColor.black
//    }
//
//    
//    @objc func donePressed(){
//        
//        self.maintainView.doneButton.isEnabled = false
//        
//        NetworkManager.sharedInstance.showLoader()
//        guard let address = self.maintainView.cityandaddressTextField.text else {
//            SwiftMessages.showToast(NSLocalizedString("Somthing is Missing", comment: ""))
//            NetworkManager.sharedInstance.dismissLoader()
//            return
//            
//        }
//        guard let  problem = self.maintainView.problemTextField.text else {
//            SwiftMessages.showToast(NSLocalizedString("Somthing is Missing", comment: ""))
//            NetworkManager.sharedInstance.dismissLoader()
//            return
//            
//        }
//        guard let  fullname = self.maintainView.fullNameTextField.text else {
//            SwiftMessages.showToast(NSLocalizedString("Somthing is Missing", comment: ""))
//            NetworkManager.sharedInstance.dismissLoader()
//            return
//            
//        }
//        guard let  mobile = self.maintainView.mobileNumberTextField.text else {
//            SwiftMessages.showToast(NSLocalizedString("Somthing is Missing", comment: ""))
//            NetworkManager.sharedInstance.dismissLoader()
//            return
//            
//        }
//        
//        
//        guard let fImage = frontImage else {
//             SwiftMessages.showToast(NSLocalizedString("Somthing is Missing", comment: ""))
//            NetworkManager.sharedInstance.dismissLoader()
//            return
//            
//        }
//        
//        guard let bImage = backImage else {
//                  SwiftMessages.showToast(NSLocalizedString("Somthing is Missing", comment: ""))
//            NetworkManager.sharedInstance.dismissLoader()
//                  return
//                 
//             }
// 
//        var parameters = [
//            "params": [
//                "model": self.selectedDevice,
//                "problem": problem,
//                "frontend_image": "data:image/png;base64," + (self.frontImage?.toBase64())!,
//                "backend_image": "data:image/png;base64," + (self.backImage?.toBase64())!,
//                "fullname": fullname,
//                "mobile": mobile,
//                "address": address
//            ]
//        ] as! [String: Any]
//        
//        
//
//        
//        let url: String = API_ROOT_DOMAIN + "rest/V1/maintenance"
//              var request = URLRequest(url:  NSURL(string: url)! as URL)
//
//              // Your request method type Get or post etc according to your requirement
//              request.httpMethod = "POST"
//
//              request.setValue("Bearer \(ADMIN_TOKEN)", forHTTPHeaderField: "Authorization")
//              request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.httpBody = try! JSONSerialization.data(withJSONObject: parameters )
//           
//              Alamofire.request(request).responseJSON { (responseObject) -> Void in
//
//                self.maintainView.doneButton.isEnabled = true
//                NetworkManager.sharedInstance.dismissLoader()
//                if let data =  responseObject.result.value {
//                    
//                    
//                    let json = JSON(data)
//                    print(json)
//                    SwiftMessages.showToast(NSLocalizedString("Maintenance request made succesfully.", comment: ""))
//                }
//                
//            }
//            
//        
//        
//        
//    }
//    
//    @objc func frontImageSelected(){
//        self.showActionSheetForImageInput { [unowned self](imageSource) in
//                         
//                         let imagePicker = UIImagePickerController()
//            imagePicker.view.tag = 1
//                         imagePicker.delegate = self
//                         
//                         switch imageSource {
//                         case .camera:
//                             imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera:.photoLibrary;
//                             
//                         case .imageLibrary:
//                             imagePicker.sourceType = .photoLibrary;
//                         }
//                         
//                         self.present(imagePicker, animated: true, completion: nil)
//                     }
//    }
//    
//    @objc func backImageSelected(){
//        self.showActionSheetForImageInput { [unowned self](imageSource) in
//                         
//                         let imagePicker = UIImagePickerController()
//                         imagePicker.delegate = self
//                      imagePicker.view.tag = 2
//                         
//                         switch imageSource {
//                         case .camera:
//                             imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera:.photoLibrary;
//                             
//                         case .imageLibrary:
//                             imagePicker.sourceType = .photoLibrary;
//                         }
//                         
//                         self.present(imagePicker, animated: true, completion: nil)
//                     }
//    }
//    
//    
//    
//}
//
//
//extension MaintenanceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//// Local variable inserted by Swift 4.2 migrator.
//let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
//
//        
//        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
//            
//            
//            dismiss(animated: false) {
//                DispatchQueue.main.async {
//                    if picker.view.tag == 1{
//                        self.frontImage = pickedImage
//                    }else if picker.view.tag == 2 {
//                         self.backImage = pickedImage
//                    }
//                    
//                    
//                }
//            }
//            
//            
//        }
//    }
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        
//        dismiss(animated: true, completion: nil)
//    }
//}
//        
//        
//        
//        // Helper function inserted by Swift 4.2 migrator.
//        fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
//            return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
//        }
//
//        // Helper function inserted by Swift 4.2 migrator.
//        fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
//            return input.rawValue
//        }
//
//
//
//
//class MaintainceView: UIView {
//    
//    lazy var scrollView: UIScrollView = {
//        let view = UIScrollView()
//        view.isScrollEnabled = true
//        return view
//    }()
//    
//    lazy var banner: UIImageView = {
//        let view = UIImageView()
//        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
//        return view
//    }()
//    
//    lazy var deviceModelLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Device Model".localized
//        label.font = UIFont.boldSystemFont(ofSize: 18)
//           label.adjustsFontSizeToFitWidth = true
//        return label
//    }()
//    
//    lazy var devicePickerView: UIButton = {
//        
//        let view = UIButton()
//        view.borderWidth1 = 1
//        view.borderColor1 = .black
//        view.titleLabel?.font =  UIFont.systemFont(ofSize: 16)
//        view.setTitle("Select Device Model", for: .normal)
//        view.titleLabel!.textColor = UIColor.black
//        
//        return view
//    }()
//    
//    lazy var problemLabel: UILabel = {
//        let label = UILabel()
//        label.text = " Type The Problem".localized
//        label.font = UIFont.boldSystemFont(ofSize: 18)
//           label.adjustsFontSizeToFitWidth = true
//        return label
//    }()
//    
//    lazy var problemTextField: UITextField = {
//        let label = UITextField()
//        label.borderWidth1 = 1
//        label.borderColor1 = .black
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.placeholder = "Enter the problem "
//        return label
//    }()
//    
//    lazy var fullNameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Full Name".localized
//        label.font = UIFont.boldSystemFont(ofSize: 18)
//           label.adjustsFontSizeToFitWidth = true
//        return label
//    }()
//    
//    lazy var fullNameTextField: UITextField = {
//        let label = UITextField()
//        label.placeholder = "Enter Fullname"
//        label.borderWidth1 = 1
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.borderColor1 = .black
//        return label
//    }()
//    
//    lazy var mobileNumberlabel: UILabel = {
//        let label = UILabel()
//        label.text = "Mobile Number".localized
//        label.font = UIFont.boldSystemFont(ofSize: 18)
//        label.adjustsFontSizeToFitWidth = true
//        return label
//    }()
//    
//    
//    lazy var mobileNumberTextField: UITextField = {
//        let label = UITextField()
//        label.borderWidth1 = 1
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.borderColor1 = .black
//        label.placeholder = "Enter Mobile number"
//        return label
//    }()
//    
//    lazy var cityandaddress: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 18)
//        label.adjustsFontSizeToFitWidth = true
//        label.text = "City & Address".localized
//        return label
//    }()
//    
//    lazy var cityandaddressTextField: UITextField = {
//        let label = UITextField()
//        label.borderWidth1 = 1
//        label.borderColor1 = .black
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.placeholder = "Enter City&Address"
//        return label
//    }()
//    
//    lazy var frontImageView: UIImageView = {
//        let view = UIImageView()
//        view.layer.cornerRadius = 12
//        view.isUserInteractionEnabled = true
//        view.layer.masksToBounds = true
//        view.image = UIImage(named: "sharp-upload")
//        view.borderColor1 = .black
//        view.borderWidth1 = 1
//        view.contentMode = .scaleAspectFit
//        return view
//    }()
//    
//    lazy var backImageView: UIImageView = {
//        let view = UIImageView()
//        view.layer.cornerRadius = 12
//        view.layer.masksToBounds = true
//        view.isUserInteractionEnabled = true
//        view.image = UIImage(named: "sharp-upload")
//       
//        view.borderColor1 = .black
//              view.borderWidth1 = 1
//        view.contentMode = .scaleAspectFit
//        return view
//      }()
//    
//    lazy var frontImageLabel: UILabel = {
//        
//        let label = UILabel()
//        label.text = "Upload Front Image of the Device"
//        label.font = UIFont.boldSystemFont(ofSize: 18)
//        label.adjustsFontSizeToFitWidth = true
//        label.numberOfLines = 0
//        return label
//    }()
//    
//    lazy var backImageLabel: UILabel = {
//          
//          let label = UILabel()
//          label.text = "Upload Back Image of the Device"
//        label.font = UIFont.boldSystemFont(ofSize: 18)
//          label.adjustsFontSizeToFitWidth = true
//          label.numberOfLines = 0
//          return label
//      }()
//    
//    lazy var doneButton: UIButton = {
//       let button = UIButton()
//        button.setTitle("Done", for: .normal)
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
//         //button.titleLabel?.adjustsFontSizeToFitWidth = true
//        button.setTitleColor(.white, for: .normal)
//        //button.titleLabel?.textColor = UIColor.black
//        //button.applyButtonBorder(colours: AppStaticColors.accentColor)
//        button.backgroundColor = UIColor.black.withAlphaComponent(0.75)
//        return button
//    }()
//    
//    
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        self.addSubview(scrollView)
//        
//        scrollView.snp.makeConstraints { (make) in
//            make.top.equalTo(self.snp.top)
//            make.bottom.equalTo(self.snp.bottom)
//            make.leading.equalTo(self.snp.leading)
//            make.trailing.equalTo(self.snp.trailing)
//        }
//        
//        
//       
//        
//        self.scrollView.addSubview(banner)
//        banner.snp.makeConstraints { (make) in
//            make.top.equalTo(self.scrollView.snp.top).offset(5)
//            make.centerX.equalTo(self.snp.centerX)
//            make.width.equalTo(self.snp.width).multipliedBy(0.95)
//            make.height.equalTo(self.snp.height).multipliedBy(0.1)
//         
//        }
//        
//        self.scrollView.addSubview(deviceModelLabel)
//        
//        deviceModelLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(self.banner.snp.bottom).offset(5)
//            make.leading.equalTo(self.banner.snp.leading)
//            make.trailing.equalTo(self.banner.snp.trailing)
//            make.height.equalTo(35)
//            
//        }
//        
//        self.scrollView.addSubview(devicePickerView)
//        
//        devicePickerView.snp.makeConstraints { (make) in
//            make.top.equalTo(self.deviceModelLabel.snp.bottom).offset(5)
//            make.leading.equalTo(self.banner.snp.leading)
//            make.trailing.equalTo(self.banner.snp.trailing)
//              make.height.equalTo(45)
//            
//        }
//        
//        self.scrollView.addSubview(problemLabel)
//        
//        problemLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(self.devicePickerView.snp.bottom).offset(5)
//            make.leading.equalTo(self.banner.snp.leading)
//            make.trailing.equalTo(self.banner.snp.trailing)
//             make.height.equalTo(35)
//            
//        }
//        
//        problemTextField.setLeftPaddingPoints(8)
//        self.scrollView.addSubview(problemTextField)
//        
//        problemTextField.snp.makeConstraints { (make) in
//            make.top.equalTo(self.problemLabel.snp.bottom)
//            make.leading.equalTo(self.banner.snp.leading)
//            make.trailing.equalTo(self.banner.snp.trailing)
//            make.height.equalTo(50)
//            
//        }
//        
//        self.scrollView.addSubview(frontImageView)
//        
//           frontImageView.snp.makeConstraints { (make) in
//            make.top.equalTo(self.problemTextField.snp.bottom).offset(5)
//            make.width.equalTo(self.snp.width).multipliedBy(0.25)
//            make.height.equalTo(70)
//            make.leading.equalTo(self.banner.snp.leading)
//        }
//        
//        self.scrollView.addSubview(frontImageLabel)
//        
//        frontImageLabel.snp.makeConstraints { (make) in
//             make.top.equalTo(self.problemTextField.snp.bottom).offset(5)
//            make.leading.equalTo(self.frontImageView.snp.trailing).offset(5)
//            make.trailing.equalTo(self.banner.snp.trailing)
//              make.height.equalTo(35)
//            
//        }
//        
//        
//        self.scrollView.addSubview(backImageView)
//        
//        backImageView.snp.makeConstraints { (make) in
//            make.top.equalTo(self.frontImageView.snp.bottom).offset(5)
//            make.width.equalTo(self.snp.width).multipliedBy(0.25)
//              make.height.equalTo(70)
//            make.leading.equalTo(self.banner.snp.leading)
//        }
//        
//        
//        self.scrollView.addSubview(backImageLabel)
//        
//        backImageLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(self.frontImageView.snp.bottom).offset(5)
//            make.leading.equalTo(self.backImageView.snp.trailing).offset(5)
//            make.trailing.equalTo(self.banner.snp.trailing)
//              make.height.equalTo(35)
//            
//        }
//        
//        
//        self.scrollView.addSubview(fullNameLabel)
//        
//        fullNameLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(self.backImageView.snp.bottom).offset(5)
//            make.trailing.equalTo(self.banner.snp.trailing)
//               make.height.equalTo(35)
//            make.leading.equalTo(self.banner.snp.leading)
//        }
//        
//        fullNameTextField.setLeftPaddingPoints(8)
//        self.scrollView.addSubview(fullNameTextField)
//        
//        fullNameTextField.snp.makeConstraints { (make) in
//            make.top.equalTo(self.fullNameLabel.snp.bottom).offset(5)
//            make.trailing.equalTo(self.banner.snp.trailing)
//            make.height.equalTo(50)
//            make.leading.equalTo(self.banner.snp.leading)
//        }
//        
//        
//        self.scrollView.addSubview(mobileNumberlabel)
//        mobileNumberlabel.snp.makeConstraints { (make) in
//            make.top.equalTo(self.fullNameTextField.snp.bottom).offset(5)
//            make.trailing.equalTo(self.banner.snp.trailing)
//            make.height.equalTo(35)
//            make.leading.equalTo(self.banner.snp.leading)
//        }
//        
//        mobileNumberTextField.setLeftPaddingPoints(8)
//        self.scrollView.addSubview(mobileNumberTextField)
//        
//        mobileNumberTextField.snp.makeConstraints { (make) in
//            make.top.equalTo(self.mobileNumberlabel.snp.bottom).offset(5)
//            make.trailing.equalTo(self.banner.snp.trailing)
//            make.height.equalTo(50)
//            make.leading.equalTo(self.banner.snp.leading)
//        }
//        
//        
//        self.scrollView.addSubview(cityandaddress)
//        
//        cityandaddress.snp.makeConstraints { (make) in
//            make.top.equalTo(self.mobileNumberTextField.snp.bottom).offset(5)
//            make.trailing.equalTo(self.banner.snp.trailing)
//            make.height.equalTo(35)
//            make.leading.equalTo(self.banner.snp.leading)
//        }
//        
//        cityandaddressTextField.setLeftPaddingPoints(8)
//        self.scrollView.addSubview(cityandaddressTextField)
//        
//        
//        cityandaddressTextField.snp.makeConstraints { (make) in
//            make.top.equalTo(self.cityandaddress.snp.bottom).offset(5)
//            make.trailing.equalTo(self.banner.snp.trailing)
//            make.height.equalTo(50)
//            make.leading.equalTo(self.banner.snp.leading)
//        }
//        
//        self.scrollView.addSubview(doneButton)
//        
//        
//        doneButton.snp.makeConstraints { (make) in
//            make.top.equalTo(self.cityandaddressTextField.snp.bottom).offset(10)
//            make.trailing.equalTo(self.banner.snp.trailing)
//            make.height.equalTo(56) //35
//            make.leading.equalTo(self.banner.snp.leading)
//        }
//        
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    
//}
//
//
//class CustomOutlinedTxtField: UIView {
//    private var textFieldControllerFloating: MDCTextInputControllerOutlined!
//    var textField: MDCTextField!
//
//    @IBInspectable var placeHolder: String!
//    @IBInspectable var value: String!
//    @IBInspectable var primaryColor: UIColor! = .purple
//
//    override open func draw(_ rect: CGRect) {
//        super.draw(rect)
//
//        textField.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
//
//    }
//    open override func awakeFromNib() {
//        super.awakeFromNib()
//        setUpProperty()
//    }
//    func setUpProperty() {
//        //Change this properties to change the propperties of text
//        textField = MDCTextField(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
//        textField.placeholder = placeHolder
//        textField.text = value
//
//        //Change this properties to change the colors of border around text
//        textFieldControllerFloating = MDCTextInputControllerOutlined(textInput: textField)
//
//        textFieldControllerFloating.activeColor = primaryColor
//        textFieldControllerFloating.floatingPlaceholderActiveColor = primaryColor
//        textFieldControllerFloating.normalColor = UIColor.lightGray
//        textFieldControllerFloating.inlinePlaceholderColor = UIColor.lightGray
//
//        //Change this font to make borderRect bigger
//        textFieldControllerFloating.inlinePlaceholderFont = UIFont.systemFont(ofSize: 14)
//        textFieldControllerFloating.textInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
//
//        self.addSubview(textField)
//    }
//}
