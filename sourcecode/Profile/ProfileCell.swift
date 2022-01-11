import UIKit

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        arrow.image = arrow.image?.flipImage()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var item: ProfileItem? {
        didSet {
            profileImage.image = item?.image
            name.text = item?.title
        }
    }
    
}
