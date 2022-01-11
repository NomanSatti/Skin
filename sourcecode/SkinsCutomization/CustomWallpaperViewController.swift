//
//  CustomWallpaperViewController.swift
//  Skins
//
//  Created by Work on 4/15/20.
//  Copyright © 2020 Work. All rights reserved.
//

import UIKit
import iOSPhotoEditor

import PixelEditor
import PixelEngine

class CustomWallpaperViewController: UIViewController, PhotoEditorDelegate {
    
    
    var selectedImage : UIImage?
    var didCancel = false

    override func viewDidLoad() {
  
        super.viewDidLoad()
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if !didCancel{
          let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))

              
               photoEditor.photoEditorDelegate = self
               photoEditor.image = self.selectedImage
            
             for i in 0...10 {
                      photoEditor.stickers.append(UIImage(named: i.description )!)
                  }
          
            photoEditor.hiddenControls = [.crop, .draw, .share]
            photoEditor.colors = [.red,.blue,.green]
    
            //present(photoEditor, animated: true, completion: nil)
            self.navigationController?.pushViewController(photoEditor, animated: true)
        }else{
            self.navigationController?.popToRootViewController(animated: false)
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    
    
    
    func doneEditing(image: UIImage) {
       // let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.DisplayImageVC) as! DisplayImageViewController
        
        let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.customSelectDevice) as! CustomSelectDeviceViewController
        vc.customImage = image
      //  vc.isCustomUpload = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func canceledEditing() {
      //  self.dismiss(animated: true, completion: nil)
        self.didCancel = true
        self.navigationController?.popViewController(animated: true)
    }

}

