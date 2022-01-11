//
//  DetectorViewController.swift
/**
 * Webkul Software.
 *
 * @Mobikul
 * @PrestashopMobikulAndMarketplace
 * @author Webkul
 * @copyright Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 */

import UIKit
import AVFoundation
import Firebase

protocol SuggestionDataHandlerDelegate: class {
    func suggestedData(data: String)
}

class DetectorViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, UIPopoverPresentationControllerDelegate, DetectedItem {
    
    @IBOutlet var captureView: UIImageView!
    @IBOutlet weak var suggestionView: UIView!
    @IBOutlet weak var arrowImg: UIImageView!
    @IBOutlet weak var suggestionBtn: UIButton!
    @IBOutlet weak var suggestionTableView: UITableView!
    @IBOutlet weak var suggestionViewLeading: NSLayoutConstraint!
    @IBOutlet weak var suggestionViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var suggestionViewBottom: NSLayoutConstraint!
    @IBOutlet weak var suggestionViewHeight: NSLayoutConstraint!
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var captureDevice: AVCaptureDevice!
    let imageDetector = Vision.vision().onDeviceImageLabeler()
    var textDetector = Vision.vision().onDeviceTextRecognizer()
    weak var delegate: SuggestionDataHandlerDelegate!
    var totalTextString  = [String]()
    var flag = Bool()
    var shouldTakePhoto = false
    var frameCount = 0
    static let labelConfidenceThreshold: Float = 0.75
    let detectViewModel = DetectViewModel()
    var isSuggestionsShowing = false
    var detectorType: DetectorType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalTextString.reserveCapacity(20)
        view.backgroundColor = UIColor.clear
        view.isOpaque = true
        self.suggestionView.layer.cornerRadius = 8
        prepareCamera()
        self.navigationController?.navigationBar.transparentNavigation()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "sharp-cross")?.withRenderingMode(.alwaysTemplate), style: .done, target: self, action: #selector(tapCrossBtn))
        self.navigationItem.leftBarButtonItem?.tintColor = AppStaticColors.itemTintColor
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.toggleTorch(on: false)
        captureSession.stopRunning()
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                captureSession.removeInput(input)
            }
        }
    }
    
    @objc func tapCrossBtn() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapSuggestionBtn(_ sender: Any) {
        if isSuggestionsShowing {
            isSuggestionsShowing = false
            self.suggestionViewLeading.constant = 20
            self.suggestionViewTrailing.constant = 20
            self.suggestionViewBottom.constant = 20
            self.suggestionViewHeight.constant = 40
            UIView.animate(withDuration: 0.5) {
                self.suggestionView.layer.cornerRadius = 8
                self.suggestionView.layoutIfNeeded()
                self.arrowImg.transform = CGAffineTransform(rotationAngle: 0)
            }
        } else {
            isSuggestionsShowing = true
            self.suggestionViewLeading.constant = 0
            self.suggestionViewTrailing.constant = 0
            self.suggestionViewBottom.constant = 0
            let height = CGFloat(40 * (self.detectViewModel.TextStringValue.count + 1)) > (AppDimensions.screenHeight*3/4) ? (AppDimensions.screenHeight*3/4):CGFloat(40 * (self.detectViewModel.TextStringValue.count + 1))
            print(height)
            self.suggestionViewHeight.constant = height
            UIView.animate(withDuration: 0.5) {
                self.suggestionView.layer.cornerRadius = 0
                self.suggestionView.layoutIfNeeded()
                self.arrowImg.transform = CGAffineTransform(rotationAngle: .pi)
            }
        }
    }
    
    func DetectedValue(value: String) {
        self.navigationController?.popViewController(animated: true)
        delegate.suggestedData(data: value)
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func prepareCamera() {
        captureSession.sessionPreset = AVCaptureSession.Preset.medium
        captureDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back).devices.first
        beginSession()
    }
    
    func beginSession() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
        } catch {
            print(error.localizedDescription)
            presentCameraSettings()
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: AppDimensions.screenWidth, height: AppDimensions.screenHeight)
        previewLayer.bounds = CGRect(x: CGFloat(0), y: CGFloat(0), width: AppDimensions.screenWidth, height: AppDimensions.screenHeight)
        self.view.bringSubviewToFront(self.suggestionView)
        captureSession.startRunning()
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [
            ((kCVPixelBufferPixelFormatTypeKey as NSString) as String): NSNumber(value: kCVPixelFormatType_32BGRA)
        ]
        dataOutput.alwaysDiscardsLateVideoFrames = true
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        captureSession.commitConfiguration()
        let queue = DispatchQueue(label: "captureQueue")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
    }
    
    func presentCameraSettings() {
        let alertController = UIAlertController(title: applicationName, message: "cameraAccessDenied".localized, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "cancel".localized, style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(UIAlertAction(title: "settings".localized, style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    self.prepareCamera()
                })
            }
        })
        self.present(alertController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.makeDefaultNavigation()
    }
    
    // Process frames only at a specific duration. This skips redundant frames and
    // avoids memory issues.
    func proccess(every: Int, callback: () -> Void) {
        frameCount += 1
        // Process every nth frame
        if frameCount % every == 0 {
            callback()
        }
    }
    
    // Combine all VisionText into one String
    private func flattenVisionImage(visionImageLabel: [VisionImageLabel]?) -> String {
        var text = ""
        
        for label in visionImageLabel ?? [] {
            text += " " + label.text
        }
        if let vision = visionImageLabel {
            for i in 0..<vision.count {
                if totalTextString.contains(vision[i].text) == false {//&& totalTextString.count<=9{
                    print(totalTextString)
                    if totalTextString.count < 21 {
                        totalTextString.append(vision[i].text.trimmingCharacters(in: .whitespacesAndNewlines))
                        self.detectViewModel.getValue(data: totalTextString) { (check) in
                            if check {
                                self.suggestionView.isHidden = false
                                self.detectViewModel.delegate = self
                                self.suggestionTableView.delegate = detectViewModel
                                self.suggestionTableView.dataSource = detectViewModel
                                self.suggestionTableView.alpha = 1
                                self.suggestionTableView.reloadData()
                                let dataStr = "\(self.detectViewModel.TextStringValue.count) Suggestions"
                                self.suggestionBtn.setTitle(dataStr, for: .normal)
                            }
                        }
                    } else {
                        ShowNotificationMessages.sharedInstance.warningView(message: "You can scan only 21 results".localized)
                    }
                    
                }
            }
        }
        return text
    }
    
    private func flattenVisionText(visionText: VisionText?) -> String {
        var text = ""
        print(visionText?.blocks as Any)
        visionText?.blocks.forEach() { vText in
            text += " " + vText.text
        }
        if let vision = visionText?.blocks {
            for i in 0..<vision.count {
                if totalTextString.contains(vision[i].text) == false {//&& totalTextString.count<=9{
                    print(totalTextString)
                    if totalTextString.count < 21 {
                        totalTextString.append(vision[i].text.trimmingCharacters(in: .whitespacesAndNewlines))
                        self.detectViewModel.getValue(data: totalTextString) { (check) in
                            if check {
                                self.suggestionView.isHidden = false
                                self.detectViewModel.delegate = self
                                self.suggestionTableView.delegate = detectViewModel
                                self.suggestionTableView.dataSource = detectViewModel
                                self.suggestionTableView.alpha = 1
                                self.suggestionTableView.reloadData()
                                let dataStr = "\(self.detectViewModel.TextStringValue.count) Suggestions"
                                self.suggestionBtn.setTitle(dataStr, for: .normal)
                            }
                        }
                    } else {
                        ShowNotificationMessages.sharedInstance.warningView(message: "You can scan only 21 results".localized)
                    }
                }
            }
        }
        return text
    }
    
    // Detect text in a CMSampleBuffer by converting to a UIImage to determine orientation
    func detectText(in buffer: CMSampleBuffer, completion: @escaping (_ text: String, _ image: UIImage) -> Void) {
        if let image = buffer.toUIImage() {
            let viImage = image.toVisionImage()
            switch detectorType {
            case .image?:
                if totalTextString.count < 21 {
                    imageDetector.process(viImage) { labels, error in
                        guard error == nil, let labels = labels else { return }
                        completion(self.flattenVisionImage(visionImageLabel: labels), image)
                    }
                } else {
                    DispatchQueue.main.async {
                        ShowNotificationMessages.sharedInstance.warningView(message: "You can scan only 21 results".localized)
                        self.captureSession.stopRunning()
                    }
                    
                }
            case .text?:
                if totalTextString.count < 21 {
                    textDetector.process(viImage) { visionText, error in
                        guard error == nil, let visionText = visionText else { return }
                        completion(self.flattenVisionText(visionText: visionText), image)
                    }
                } else {
                    DispatchQueue.main.async {
                        ShowNotificationMessages.sharedInstance.warningView(message: "You can scan only 21 results".localized)
                        self.captureSession.stopRunning()
                    }
                }
            default:
                break
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Detect text every 10 frames
        proccess(every: 10) {
            self.detectText(in: sampleBuffer) { text, image in
                print("sss", text)
            }
        }
    }
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video)
            else {return}
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
}

extension CMSampleBuffer {
    // Converts a CMSampleBuffer to a UIImage
    //
    // Return: UIImage from CMSampleBuffer
    func toUIImage() -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(self) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
        }
        return nil
    }
}
