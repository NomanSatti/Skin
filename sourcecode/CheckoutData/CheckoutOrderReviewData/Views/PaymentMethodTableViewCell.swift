//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: PaymentMethodTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class PaymentMethodTableViewCell: UITableViewCell {
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var paymentMethodHeading: UILabel!
    
    @IBOutlet weak var extraInfoLabel: UILabel!
    
    private var paymentMethods = [PaymentMethods]()
    var paymentId = ""
    weak var delegate: SendPaymentId?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        paymentMethodHeading.text = "Payment Method".localized
        tableView.register(cellType: SelectionMethodTableViewCell.self)
        tableView.separatorStyle = .none
        // Initialization code
        self.extraInfoLabel.text = "Select a Payment Method to view its detals."
        self.extraInfoLabel.textAlignment = .center
       
        
        self.extraInfoLabel.adjustsFontSizeToFitWidth = true
        self.extraInfoLabel.numberOfLines = 0
        self.extraInfoLabel.textColor = UIColor.red
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var paymentMethod: [PaymentMethods]! {
        didSet {
            let payments = paymentMethod.filter {(PaymentData.supportedPaymnets.contains($0.code))}
            self.paymentMethods = payments
            self.tableViewHeight.constant = CGFloat(56 * paymentMethods.count)
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }
    }
}

extension PaymentMethodTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentMethods.count
    }
    


    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: SelectionMethodTableViewCell = tableView.dequeueReusableCell(with: SelectionMethodTableViewCell.self, for: indexPath) {
          
            print(paymentMethods[indexPath.row])
            
            
            cell.methodName.text = paymentMethods[indexPath.row].title 
            if paymentId == paymentMethods[indexPath.row].code {
                cell.internalImageView.backgroundColor = AppStaticColors.accentColor
            } else {
                cell.internalImageView.backgroundColor = UIColor.white
            }
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.red
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        paymentId = paymentMethods[indexPath.row].code
        
        self.extraInfoLabel.text = paymentMethods[indexPath.row].extraInformation
        
        //delegate?.sendPaymentId(paymentId: paymentId)
        delegate?.sendPaymentId(paymentData: paymentMethods[indexPath.row])
//        if paymentMethods[indexPath.row].webview {
//            if !PaymentData.webviewSupportedPaymnets.contains(paymentMethods[indexPath.row].code) {
//                PaymentData.webviewSupportedPaymnets.append(paymentMethods[indexPath.row].code)
//            }
//            PaymentData.webViewPaymentURL = paymentMethods[indexPath.row].redirectUrl ?? ""
//            PaymentData.webviewPaymentSuccessKeys = paymentMethods[indexPath.row].successUrl ?? []
//            PaymentData.webviewPaymentCancelKeys = paymentMethods[indexPath.row].cancelUrl ?? []
//            PaymentData.webviewPaymentFailureKeys = paymentMethods[indexPath.row].failureUrl ?? []
//        }
        self.tableView.reloadData()
    }
    
}

protocol SendPaymentId: NSObjectProtocol {
    func sendPaymentId(paymentData: PaymentMethods)
}


class PaddingLabel: UILabel {

    var topInset: CGFloat
    var bottomInset: CGFloat
    var leftInset: CGFloat
    var rightInset: CGFloat

    required init(withInsets top: CGFloat, _ bottom: CGFloat,_ left: CGFloat,_ right: CGFloat) {
        self.topInset = top
        self.bottomInset = bottom
        self.leftInset = left
        self.rightInset = right
        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}
