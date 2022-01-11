//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: LottieHandler.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import Lottie

class LottieHandler {
    private init() {
    }
    
    static let sharedInstance  = LottieHandler()
    var loattieAnimation: AnimationView?
    
    func initializeLottie(bounds: CGRect, fileName: String) ->  AnimationView {
        self.loattieAnimation = AnimationView(name: fileName)
        self.loattieAnimation!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.loattieAnimation!.contentMode = .scaleAspectFill
        loattieAnimation!.loopMode = .playOnce
        self.loattieAnimation!.frame = bounds
        return loattieAnimation!
    }
    
    func playLoattieAnimation() {
        self.loattieAnimation?.play(completion: { (_) in
            self.loattieAnimation!.loopMode = .playOnce
        })
    }
}
