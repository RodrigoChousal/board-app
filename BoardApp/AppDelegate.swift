//
//  AppDelegate.swift
//  BoardApp
//
//  Created by Rodrigo Chousal on 8/27/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    // FIXME: Broken. Need to send localUser to MeetingListVC even if 'visitor' or else app will crash.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
		// To hide this warning and ensure your app does not break, you need to add the following code to your app before calling any other Cloud Firestore methods:
		let db = Firestore.firestore()
		let settings = db.settings
		settings.areTimestampsInSnapshotsEnabled = true
		db.settings = settings
		
        let credentials = KeychainManager.fetchCredentials()
		print(credentials.email)
		print(credentials.password)
        Auth.auth().signIn(withEmail: credentials.email, password: credentials.password) { (dataResult, error) in
			
            if let error = error { // No credentials
				
                print("No credentials found in Keychain, first time signing in to Firebase")
                print(error)
                // Show user to AccessVC without automatic access
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let accessVC = mainStoryboard.instantiateViewController(withIdentifier: "AccessVC") as! AccessVC
                self.window?.rootViewController = accessVC
                self.window?.makeKeyAndVisible()
				
            } else { // Login successful
				
                print("User has been successfully signed in to Firebase")
                // Store important user data locally
                if let fireUser = Auth.auth().currentUser {
					Global.usersCollectionRef.document(fireUser.uid).getDocument(completion: { (document, error) in
						if let document = document, document.exists {
							if let userDictionary = document.data()! as NSDictionary? {
								Global.localUser = DatabaseManager.validUser(fromDictionary: userDictionary)
								// Show user to AccessVC with automatic access
								self.window = UIWindow(frame: UIScreen.main.bounds)
								let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
								let meetingListVC = mainStoryboard.instantiateViewController(withIdentifier: "MeetingListVC") as! MeetingListVC
								self.window?.rootViewController = meetingListVC
								self.window?.makeKeyAndVisible()
							} else {
								print("ERROR: Invalid user dictionary fetched from Firestore")
							}
						} else {
							print("Document does not exist")
						}
					})
                } else {
                    print("No current user found in Auth request")
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

