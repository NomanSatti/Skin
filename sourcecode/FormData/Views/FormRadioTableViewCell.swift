import UIKit
import Reusable

class FormRadioTableViewCell: UITableViewCell, FormConformity, NibReusable {
    var formItem: FormItem?
    var options = [SearchOptions]()
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var radioTableView: UITableView!
    @IBOutlet weak var headingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        radioTableView.separatorStyle = .none
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension FormRadioTableViewCell: FormUpdatable {
    func update(with formItem: FormItem) {
        self.formItem = formItem
        self.headingLabel.text = formItem.placeholder
        if let options = formItem.countryData as? [SearchOptions] {
            self.options = options
            self.tableViewHeight.constant = CGFloat(options.count * 44)
            self.radioTableView.delegate = self
            self.radioTableView.dataSource = self
            self.radioTableView.reloadData()
        }
        
    }
}

extension FormRadioTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.imageView?.image = UIImage(named: "icon-radio-off")
        if let form = formItem, let value = form.value as? String, value == options[indexPath.row].value {
            cell.imageView?.image = UIImage(named: "icon-radio-on")
        }
        cell.textLabel?.text = options[indexPath.row].label
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let form = formItem, let value = form.value as? String, value == options[indexPath.row].value {
            form.value = nil
        } else {
            formItem?.value = options[indexPath.row].value
        }
        self.radioTableView.reloadData()
    }
}
