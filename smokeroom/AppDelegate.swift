//
//  AppDelegate.swift
//  smokeroom
//
//  Created by Austin Kim on 5/30/18.
//  Copyright © 2018 Austin Kim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import InstantSearch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = HomeViewController()
        window!.makeKeyAndVisible()
        // Algolia
        InstantSearch.shared.configure(appID: "NZJAE708OM", apiKey: "61672ad893ddeeb69532d2cd146c7913", index: "users")
        InstantSearch.shared.params.attributesToRetrieve = ["name", "username", "email"]
        //set current user to universal variable
        if Auth.auth().currentUser != nil {
            db.collection("users").document((Auth.auth().currentUser?.uid)!).getDocument { (document, error) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
                else{
                    if let data = document?.data() {
                        Helper.currentUser = User(name: data["name"] as! String, username: data["username"] as! String, ghostname: data["ghostname"] as! String, email: data["email"] as! String, profile_url: data["profile_url"] as! String)
                    }
                }
            }
        }
        return true
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

