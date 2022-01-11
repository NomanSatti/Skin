//
//  AlwaysPresentAsPopover.swift
/**
 * Webkul Software.
 *
 * @Mobikul
 * @PrestashopMobikulAndMarketplace
 * @author Webkul
 * @copyright Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 */

import Foundation
import UIKit

class AlwaysPresentAsPopover: NSObject, UIPopoverPresentationControllerDelegate {
    
    private static let sharedInstance = AlwaysPresentAsPopover()
    
    private override init() {
        super.init()
    }
    
    static var delegate: UIPopoverPresentationControllerDelegate?
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    static func configurePresentation(forController controller: UIViewController, delegate: UIPopoverPresentationControllerDelegate) -> UIPopoverPresentationController? {
        controller.modalPresentationStyle = .popover
        let presentationController = controller.presentationController as? UIPopoverPresentationController
        presentationController?.delegate = AlwaysPresentAsPopover.sharedInstance
        return presentationController
    }
    
    internal func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        _ = AlwaysPresentAsPopover.delegate?.popoverPresentationControllerShouldDismissPopover?(popoverPresentationController)
        return true
    }
    
    internal func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        _ = AlwaysPresentAsPopover.delegate?.prepareForPopoverPresentation?(popoverPresentationController)
    }
    
    internal func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        _ = AlwaysPresentAsPopover.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController)
    }
    
}
