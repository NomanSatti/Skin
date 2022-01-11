import Foundation
import UIKit

class ThemeManager {
    
    static func applyTheme(bar: UINavigationBar) {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
        UITabBar.appearance().barStyle = .default
        UISwitch.appearance().onTintColor =  AppStaticColors.primaryColor.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor =  AppStaticColors.primaryColor
        UITabBar.appearance().tintColor =   AppStaticColors.primaryColor
        
        let backButton = UIImage(named: "backArrow")
        let backButtonImage = backButton?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 10)
        let backBarButtonApperance = UIBarButtonItem.appearance()
        backBarButtonApperance.setBackButtonBackgroundImage(backButtonImage, for: .normal, barMetrics: .default)
        
    }
    
}

struct AppStaticColors {
    static let labelSecondaryColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.58 / 1.0)
    static let accentColor = UIColor(named: "AccentColor") ?? .black
    static let primaryColor = UIColor(named: "primary") ?? .white
    static let priceOrangeColor = UIColor(named: "PriceOrangeColor")
    static let mainHeadingDarkBlack = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.87 / 1.0)
    static let linkColor = UIColor().hexToColor(hexString: "000000")
    static let shadedColor = UIColor(named: "ShadedColor")
    static let itemTintColor = UIColor(named: "itemTintColor") ?? UIColor.black
    static let defaultColor = UIColor(named: "DefaultColor") ?? UIColor.white
    static let disabledColor = UIColor(named: "DisabledColor") ?? UIColor.gray
    
    static let oneStar = UIColor(named: "oneStar")!
    static let twoStar = UIColor(named: "twoStar")!
    static let threeStar = UIColor(named: "threeStar")!
    static let fourStar = UIColor(named: "fourStar")!
    static let fiveStar = UIColor(named: "fiveStar")!
    
    static func applyTheme() {
        UITabBar.appearance().barTintColor = AppStaticColors.primaryColor
        UITabBar.appearance().unselectedItemTintColor = AppStaticColors.disabledColor
        UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
        UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
        UISwitch.appearance().onTintColor = AppStaticColors.accentColor.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor =  AppStaticColors.accentColor
        UITableView.appearance().backgroundColor = AppStaticColors.defaultColor
        UITableViewCell.appearance().backgroundColor = AppStaticColors.defaultColor
        UICollectionView.appearance().backgroundColor = AppStaticColors.defaultColor
        UICollectionViewCell.appearance().backgroundColor = AppStaticColors.defaultColor
    }
}
