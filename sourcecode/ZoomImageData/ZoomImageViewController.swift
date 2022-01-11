//
//  ZoomImageViewController.swift
//  Odoo iOS
//
//  Created by Bhavuk on 18/11/17.
//  Copyright © 2017 Bhavuk. All rights reserved.
//

import UIKit
import AVKit

class ZoomImageViewController: UIViewController {
    
    var images = [ImageGallery]()
    
    @IBOutlet weak var zoomCollectionVFiew: UICollectionView!
    @IBOutlet weak var croosbtn: UIBarButtonItem!
    @IBOutlet weak var imageController: UIImageView!
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //         navigationController?.navigationBar.applyNavigationGradient(colors: NetworkManager.Credentials.gradientArray)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.view.backgroundColor = UIColor.clear
        zoomCollectionVFiew.isPagingEnabled = true
        //        let image : UIImage? = UIImage(named: "Icon-Close")?.withRenderingMode(.alwaysOriginal)
        //        croosbtn.setBackgroundImage(image, for: .normal, barMetrics: .default)
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let  indexPath1 = IndexPath.init(row: currentPage, section: 0)
        zoomCollectionVFiew.scrollToItem(at: indexPath1, at: .right, animated: true)
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func barButtonClicked(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}

extension ZoomImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(images.count)
        return images.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! CustomCellCollectionViewCell
        cell.imagee.isUserInteractionEnabled = true
        cell.imagee.setImage(fromURL: images[indexPath.row].largeImage)
        cell.imagee.contentMode = .scaleAspectFit
        if let isVideo = self.images[indexPath.row].isVideo, isVideo {
            cell.imagee.isUserInteractionEnabled = false
            cell.playImg.isHidden = false
            cell.playImg.addTapGestureRecognizer {
                if let videoUrl = self.images[indexPath.row].videoUrl, let url = URL(string: videoUrl) {
                    if videoUrl.isValidVideo() {
                        let player = AVPlayer(url: url)
                        let playerViewController = AVPlayerViewController()
                        playerViewController.player = player
                        playerViewController.modalPresentationStyle = .fullScreen
                        self.present(playerViewController, animated: true) {
                            playerViewController.player!.play()
                        }
                    } else {
                        let view  = VideoWebviewViewController.instantiate(fromAppStoryboard: .product)
                        view.videoURL = videoUrl
                        let nav  = UINavigationController(rootViewController: view)
                        //nav.navigationBar.tintColor = AppStaticColors.accentColor
                        nav.modalPresentationStyle = .fullScreen
                        self.present(nav, animated: true, completion: nil)
                    }
                }
            }
        } else {
            cell.playImg.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: AppDimensions.screenWidth, height: (UIScreen.main.bounds.size.height + 20) )
        
    }
    
}

