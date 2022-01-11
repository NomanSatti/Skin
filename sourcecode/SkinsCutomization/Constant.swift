//
//  Constant.swift
//  Skins
//
//  Created by Work on 2/26/20.
//  Copyright © 2020 Work. All rights reserved.
//


import Foundation
import UIKit


let DataStore = UserDefaults.standard
let TimeZoneString = "\((NSTimeZone.system.secondsFromGMT() / 3600) * (-60))"

let AppName = "Skins"
let CompanyName = "Skins"

var TOKEN = ""
var USER_ID = ""

class K {

    static let BaseURL = "https://techrecto.com/management/public/"
    
    static let DeviceToken = "DeviceToken"
    static let UserToken = "UserToken"
    static let UserId = "UserId"
    static let LanguageKey = "Language"
    
    static let FontNameRobotoBlack = "Roboto-Black"
    static let FontNameRobotoBold = "Roboto-Bold"
    static let FontNameRobotoItalic = "Roboto-Italic"
    static let FontNameRobotoLight = "Roboto-Light"
    static let FontNameRobotoMedium = "Roboto-Medium"
    static let FontNameRobotoRegular = "Roboto-Regular"
    static let FontNameRobotoThin = "Roboto-Thin"
    static let FontNameRobotoCondensedBold = "RobotoCondensed-Bold"
    static let FontNameRobotoCondensedRegular = "RobotoCondensed-Regular"

    static let NotificationQuickBloxPayloadInfoDictionary = "NotificationQuickBloxPayloadInfoDictionary"
    static let NotificationPayloadInfoDictionary = "NotificationPayloadInfoDictionary"
    
    static let DateTimeFormatStandard = "yyyy-MM-dd HH:mm:ss"
    static let DateTimeFormatStandardWithouSec = "yyyy-MM-dd HH:mm"
    static let hispDateTimeFormatStandard = "yyyyMMdd HH:mm:ss"
    static let DateTimeFormatStandard2 = "MM/dd/yyyy hh:mm a"
    static let DateTimeFormatStandard3 = "MM/dd/yyyy HH:mm"
    static let DateTimeFormatStandard4 = "MM/dd/yyyy hh:mm:ss"
    static let DateTimeFormatStandardLong = "yyyy-MM-dd'T'HH:mm:ss"
    static let DateFormatStandard = "MM/dd/yyyy"
    static let DateFormatStandard2 = "yyyy-MM-dd"
    static let DateFormatYearOnly = "YYYY"
    static let DateFormatMonthWithYear = "MMMM YYYY"
    static let DateFormatMonthWithDay = "MMM dd"
    static let DateFormatTodayWithTime = "'Today' hh:mm aa"
    static let DateFormatYesterdayWithTime = "'Yesterday' hh:mm aa"
    static let DateFormatMonthDayNameYear = "EEE, MMM d, hh:mm aa"
    static let DateFormatMonthDayYear = "MMM d, yyyy, hh:mm aa"
    static let DateFormatMonthOnly = "MMMM"
    static let DateFormatMonthShort = "MMM"
    static let DateFormatDayOnly = "dd"
    static let DateFormatShort = "d MMM yyyy"
    static let DateFormatShort2 = "MMM d, yyyy"
    static let TimeFormatShort = "HH:mm:ss"
    static let TimeFormatShort2 = "hh:mm aa"
    static let TimeFormatShort3 = "HH:mm"
    static let DateTimeEmptyString = "0000-00-00 00:00:00"
    
    static let GenderOptions = ["Male", "Female", "Others"]
    
    class Notifications{
        static let CCMNotification = NSNotification.Name.init("CCMNotification")
        static let TriageRefreshNotification = NSNotification.Name.init("TriageRefreshNotification")
    }
    static let SummeryRecordMessage = "Record doesn't exist."
    static let SummeryunremarkableMessage = "Patient has marked this history as unremarkable."
    static let TextFieldPlaceHolderOffset: CGFloat = 10.0
    static let FontSizeSavedKey = "FontSizeSavedKey"
    static let SnoozeDateValueKey = "SnoozeDateValueKey"
    static let SnoozeOnOffKey = "SnoozeOnOffKey"
    static let SnoozeEnableKey = "Snooze PIN Code for 30 minutes"
    static let SnoozeDisableKey = "Auto lock is snoozed."
    static let SnoozeMessageKey = "Disable auto lock for 30  minutes?"
    
    // Device screen specifications / interface idiom
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    static let IS_IPHONE = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
}

class R {
    
    class StoryboardRef {
        
        static let Main : UIStoryboard = UIStoryboard(name: R.Storyboards.Main, bundle: nil)
        static let Language : UIStoryboard = UIStoryboard(name: R.Storyboards.Language, bundle: nil)
        
    }
    
    class Storyboards {
        
        static let Main = "Main"
        static let Language = "LanguageStoryboard"
        
    }
    
    class Nibs {
        
        static let HomePatientCell = "PatientCollectionViewCell"
        static let CollectionViewCell = "CollectionViewCell"
        static let MyOrdersTableViewCell = "MyOrdersTableViewCell"
        static let TagsTableViewCell = "TagsTableViewCell"
        
    }
    
    class CellIdentifiers {
        
        static let HomePatientCell = "PatientCollectionViewCell"
        static let CollectionViewCell = "CollectionViewCell"
        static let MyOrdersTableViewCell = "MyOrdersTableViewCell"
        static let TagsTableViewCell = "TagsTableViewCell"
        static let LanguageVC = "LanguageViewController"
        
    }
    
    class ViewControllerIds {
        
        static let AppContainerVC = "AppContainerViewController"
        static let LoginVC = "LoginViewController"
        static let MainMenuVC = "MainMenuViewController"
        static let AllWallpapersVC = "AllWallpapersViewController"
        static let DisplayImageVC = "DisplayImageViewController"
        static let SignUpVC = "SignUpViewController"
        static let SearchVC = "SearchViewController"
        static let OrderInformationVC = "OrderInformationViewController"
        static let SearchResultVC = "SearchResultViewController"
        static let ForgotPasswordVC = "ForgotPasswordViewController"
        static let UpdatePasswordVC = "UpdatePasswordViewController"
        static let MyProfileVC = "MyProfileViewController"
        static let MyOrdersVC = "MyOrdersViewController"
        static let CustomOrderVC = "CustomOrderViewController"
        static let OrderDetailVC = "OrderDetailViewController"
        static let cartVC = "CartViewController"
        static let deviceVC = "SelectDeviceViewController"
        static let prodesignSubVC = "ProdesignSubCategoryViewController"
        static let prodesignListingVC = "ProdesignListingViewController"
        static let customWallpaperVC = "CustomerWallpaperViewContraolelr"
        static let customSelectDevice = "CustomSelectDeviceViewController"
        static let customDispaly = "CustomDisplayViewController"
        static let storeVc = "StoreLocatorViewController"
        static let maintenanceVc = "MaintenanceViewController"
    }
    
    class Fonts {
        
        static let NormalTextFont = UIFont.robotoRegular(K.IS_IPAD ? 17 : 15.0)
        static let AppPrimaryFont = UIFont.robotoRegular(K.IS_IPAD ? 18 : 16.0)
        static let AppMediumFont = UIFont.robotoRegular(K.IS_IPAD ? 20 : 18.0)
        static let AppBoldFont = UIFont.robotoBold(K.IS_IPAD ? 17 : 15.0)
    }
    
    class Images {
        
        static let NavigationLogo = "nav_bar_logo"
        
    }
}
