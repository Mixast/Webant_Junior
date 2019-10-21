//
//  AppDelegate.swift
//  thr
//
//  Created by Лекс Лютер on 19/10/2019.
//  Copyright © 2019 Лекс Лютер. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window : UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        
//                let realm =  try! Realm()
//                print("Connected Realm")
//                let object = realm.objects(RealmBase.self)
//                print(object)
//                try! realm.write {
//                    realm.delete(object)
//                    print("delete base")
//                }
        
        guard let realm =  try? Realm() else {
            return true
        }
        let object = realm.objects(RealmBase.self)
        if object.count != 0 {

            for i in 1...object.count {
                let base: RealmBase = realmLoad(index: i-1)
                print(base.id)
                if base.id == 1 {
                    transportRealmIndex = i-1
                    realmLoadColectionCards()
                    realmLoadFavoriteCards()

                    return true
                }
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)

    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

