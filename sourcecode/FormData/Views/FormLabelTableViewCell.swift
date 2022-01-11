import UIKit
import Reusable

class FormLabelTableViewCell: UITableViewCell, FormConformity, NibReusable {
    var formItem: FormItem?
    
    @IBOutlet weak var headinglabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension FormLabelTableViewCell: FormUpdatable {
    func update(with formItem: FormItem) {
        self.formItem = formItem
        self.headinglabel.text = formItem.heading
    }
}
