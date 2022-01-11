import UIKit
import Reusable

class AddressMoveTableViewCell: UITableViewCell, FormConformity, NibReusable {
    var formItem: FormItem?
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.isUserInteractionEnabled = true
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap))
        mainView.addGestureRecognizer(doubleTap)
        // Initialization code
    }
    
    @objc func handleDoubleTap(_ gestureRecognizer: UIGestureRecognizer) {
        //        if let vc1 =  self.inputViewController(){
        //            let str = UIStoryboard(name: "Main", bundle: nil)
        //            let vc = str.instantiateViewController(withIdentifier: "addressBookController") as! AddressBookController
        //            vc1.navigationController?.pushViewController(vc, animated: true)
        //        }
        
        //        self.viewController()?.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
extension AddressMoveTableViewCell: FormUpdatable {
    func update(with formItem: FormItem) {
        self.formItem = formItem
        headingLabel.text = formItem.placeholder
    }
}
