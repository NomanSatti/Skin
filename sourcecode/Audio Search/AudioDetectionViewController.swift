//
//  AudioDetectionViewController.swift
//  Mobikul Single App
//
//  Created by akash on 26/02/19.
//  Copyright © 2019 Webkul. All rights reserved.
//

import UIKit
import Speech
import Lottie

class AudioDetectionViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var listeningLbl: UILabel!
    @IBOutlet weak var recordingImg: UIImageView!
    @IBOutlet weak var detectedText: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: Defaults.language ?? "en"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var loattieAnimation: AnimationView?
    //private var sessionTime: Timer!
    weak var delegate: SeachProtocols?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBtn.isHidden = true
        self.searchBtn.setTitle("search".localized, for: .normal)
        self.searchBtn.applyButtonBorder(colours: AppStaticColors.accentColor)
        self.navigationController?.navigationBar.transparentNavigation()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "sharp-cross")?.withRenderingMode(.alwaysTemplate), style: .done, target: self, action: #selector(tapCrossBtn))
        self.navigationItem.leftBarButtonItem?.tintColor = AppStaticColors.itemTintColor
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            var isButtonEnabled = false
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                let alertController = UIAlertController (title: "", message: "Ask again to recognise audio".localized, preferredStyle: .alert)
                let settingsAction = UIAlertAction(title: "Settings".localized, style: .default) { (_) -> Void in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }
                alertController.addAction(settingsAction)
                let cancelAction = UIAlertAction(title: "Cancel".localized, style: .default) { (_) -> Void in
                    self.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            OperationQueue.main.addOperation() {
                if isButtonEnabled {
                    self.loattieAnimation = AnimationView(name: "Boat_Loader")
                    self.loattieAnimation!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                    self.loattieAnimation!.contentMode = .scaleAspectFill
                    self.loattieAnimation!.frame = self.recordingImg.bounds
                    self.recordingImg.addSubview(self.loattieAnimation!)
                    self.playLoattieAnimation()
                    self.speechRecognizer?.delegate = self
                    self.detectedText.text = "Say Something!!!"
                    self.startRecording()
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func playLoattieAnimation() {
        self.loattieAnimation?.play(completion: { (_) in
            self.playLoattieAnimation()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.makeDefaultNavigation()
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        }
    }
    
    @objc func tapCrossBtn() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSearchBtn(_ sender: Any) {
        self.delegate?.productListFromQuery(query: self.detectedText.text ?? "")
        self.dismiss(animated: true, completion: nil)
    }
    
    func startRecording() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.default, options: [])
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            if result != nil {
                print(result?.bestTranscription.formattedString as Any)
                self.detectedText.text = result?.bestTranscription.formattedString
                if self.detectedText.text != "" {
                    self.searchBtn.isHidden = false
                }
                isFinal = (result?.isFinal)!
            }
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        })
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        listeningLbl.text = "Listening".localized
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
        } else {
        }
    }
    
}
