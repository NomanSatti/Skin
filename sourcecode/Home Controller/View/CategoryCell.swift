import UIKit
import QuartzCore

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        labelName.font = UIFont(name: "Montserrat-SemiBold", size: 12)
        labelName.textColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.56 / 1.0)
        
        //        backView.layer.shadowColor = UIColor(white: 0.0, alpha: 0.5).cgColor
        //        backView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        //        backView.layer.shadowOpacity = 1.0
        //        backView.layer.shadowRadius = 6.0
        //        backView.layer.borderWidth = 1.0
         
//        backView.shadowBorder()
        //        backView.layer.shadowColor = UIColor.black.cgColor
        //        backView.layer.shadowOffset = CGSize(width: 0, height: 0)
        //        backView.layer.shadowOpacity = 0.7
        //        backView.layer.shadowRadius = 4.0
        
    }
    
}
