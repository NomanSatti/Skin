//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: AppDelegate+DataMigration.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */


import Foundation
import RealmSwift
import Realm

extension AppDelegate {
    func checkSchema() {
        let config =  Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                switch oldSchemaVersion {
                case 0:
                    break
                default:
                    print()
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                    self.changeData(migration: migration)
                }
        })
        Realm.Configuration.defaultConfiguration = config
    }
    
    func changeData(migration: Migration) {
        migration.enumerateObjects(ofType: Productcollection.className()) {
            oldObject, newObject in
            migration.renameProperty(onType: Productcollection.className(), from: "image", to: "thumbNail")
        }
    }
    
}

// changes in Db


// Schema from 0 to 1 version on 5/4/19
// migration.renameProperty(onType: Productcollection.className(), from: "image", to: "thumbNail")
