import UIKit

class CreateAccountModel: NSObject {
    var signUpData: CreateAccountData?
    init?(data: JSON) {
        signUpData = CreateAccountData(data: data)
    }
}

struct CreateAccountData {
    var isDobRequired: Bool!
    var isDobVisible: Bool!
    var isGenderRequired: Bool!
    var isGenderVisible: Bool!
    var isMiddleNameVisible: Bool!
    var isMobileNumberVisible: Bool!
    var isMobileNumberRequired: Bool!
    var isPrefixRequired: Bool!
    var isPrefixVisible: Bool!
    var isSuffixRequired: Bool!
    var isSuffixVisible: Bool!
    var isTaxRequired: Bool!
    var isTaxVisible: Bool!
    var isPrefixHasOption: Bool!
    var isSuffixHasOption: Bool!
    var prefixValue = [String]()
    var suffixValue = [String]()
    var dateFormat: String?
    
    init(data: JSON) {
        self.dateFormat = data["dateFormat"].stringValue
        self.isDobRequired = data["isDOBRequired"].boolValue
        self.isDobVisible = data["isDOBVisible"].boolValue
        self.isGenderRequired = data["isGenderRequired"].boolValue
        self.isGenderVisible = data["isGenderVisible"].boolValue
        self.isMiddleNameVisible = data["isMiddlenameVisible"].boolValue
        self.isMobileNumberRequired = data["isMobileRequired"].boolValue
        self.isMobileNumberVisible = data["isMobileVisible"].boolValue
        self.isPrefixRequired = data["isPrefixRequired"].boolValue
        self.isPrefixVisible = data["isPrefixVisible"].boolValue
        self.isSuffixRequired = data["isSuffixRequired"].boolValue
        self.isSuffixVisible = data["isSuffixVisible"].boolValue
        self.isTaxRequired = data["isTaxRequired"].boolValue
        self.isTaxVisible = data["isTaxVisible"].boolValue
        self.isPrefixHasOption = data["prefixHasOptions"].boolValue
        self.isSuffixHasOption = data["suffixHasOptions"].boolValue
        for i in 0..<data["prefixOptions"].count {
            self.prefixValue.append(data["prefixOptions"][i].stringValue)
        }
        for i in 0..<data["suffixOptions"].count {
            self.suffixValue.append(data["suffixOptions"][i].stringValue)
        }
    }
}
