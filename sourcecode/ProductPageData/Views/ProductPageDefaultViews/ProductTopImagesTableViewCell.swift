//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ProductTopImagesTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit
import ModelIO
import QuickLook
import AVKit

class ProductTopImagesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var arBtn: UIButton!
    @IBOutlet weak var pageControll: CHIPageControlFresno!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images = [ImageGallery]()
    var arType: String!
    var arUrl: String!
    var fileURL: URL!
    override func awakeFromNib() {
        super.awakeFromNib()
        arBtn.shadowBorder()
        pageControll.radius = 4
        pageControll.tintColor = .white
        pageControll.borderWidth = 1
        pageControll.layer.borderColor = UIColor.white.cgColor
        pageControll.currentPageTintColor = AppStaticColors.accentColor//.white
        pageControll.tintColor = AppStaticColors.accentColor
        self.collectionView.register(cellType: ImageCollectionViewCell.self)
        self.collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        // Initialization code
    }
    
    override func layoutSubviews() {
        if let arType = arType, arType == "3D" {
            arBtn.isHidden = false
        } else {
            arBtn.isHidden = true
        }
        //        arBtn.isHidden = true
    }
    
    @IBAction func arBtnClicked(_ sender: Any) {
        if let vc = self.viewContainingController as? ProductPageDataViewController {
            vc.spinner.startAnimating()
        }
        DownloadManager.shared.download(string:arUrl) { downloadedUrl in
            print(downloadedUrl)
            if let vc = self.viewContainingController as? ProductPageDataViewController {
                vc.spinner.stopAnimating()
            }
            self.fileURL = URL(string: downloadedUrl)!
            let previewController = QLPreviewController()
            previewController.dataSource = self
            previewController.delegate = self
            previewController.modalPresentationStyle = .fullScreen
            self.viewContainingController?.present(previewController, animated: true)
        }
        
//        self.fileURL = Bundle.main.url(forResource: "sofa1", withExtension: "usdz")!
//        let previewController = QLPreviewController()
//        previewController.dataSource = self
//        previewController.delegate = self
//        previewController.modalPresentationStyle = .fullScreen
//        self.viewContainingController?.present(previewController, animated: true)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension ProductTopImagesTableViewCell: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let url = fileURL
        return url! as QLPreviewItem
    }
}

extension ProductTopImagesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControll.numberOfPages = images.count
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(with: ImageCollectionViewCell.self, for: indexPath) {
            cell.imageObject.setImage(fromURL: images[indexPath.row].largeImage, dominantColor: images[indexPath.row].dominantColor)
            cell.imageObject.contentMode = .scaleAspectFit
            if let isVideo = self.images[indexPath.row].isVideo, isVideo {
                cell.playImg.isHidden = false
            } else {
                cell.playImg.isHidden = true
            }
            cell.layoutIfNeeded()
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: AppDimensions.screenHeight/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let isVideo = self.images[indexPath.row].isVideo, isVideo {
            if let videoUrl = self.images[indexPath.row].videoUrl, let url = URL(string: videoUrl) {
                if videoUrl.isValidVideo() {
                    let player = AVPlayer(url: url)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    playerViewController.modalPresentationStyle = .fullScreen
                    self.viewContainingController?.present(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }
                } else {
                    let view  = VideoWebviewViewController.instantiate(fromAppStoryboard: .product)
                    view.videoURL = videoUrl
                    let nav  = UINavigationController(rootViewController: view)
                    //nav.navigationBar.tintColor = AppStaticColors.accentColor
                    nav.modalPresentationStyle = .fullScreen
                    self.viewContainingController?.present(nav, animated: true, completion: nil)
                }
            }
        } else {
            let view  = ZoomImageViewController.instantiate(fromAppStoryboard: .product)
            view.images = images
            view.currentPage = indexPath.row
            let nav  = UINavigationController(rootViewController: view)
            //nav.navigationBar.tintColor = AppStaticColors.accentColor
            self.viewContainingController?.present(nav, animated: false, completion: nil)
        }
    }
}

extension ProductTopImagesTableViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControll?.set(progress: Int(scrollView.contentOffset.x / AppDimensions.screenWidth), animated: true)
        //        currentPage = Int(scrollView.contentOffset.x / SCREEN_WIDTH)
    }
    
}
