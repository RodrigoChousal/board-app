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
        
        let credentials = KeychainManager.fetchCredentials()
        Auth.auth().signIn(withEmail: credentials.email, password: credentials.password) { (dataResult, error) in
            if let error = error { // No credentials
                
                print("")
                print("No credentials found in Keychain, first time signing in to Firebase")
                print(error)
                print("")
                
                // Show user to AccessVC without automatic access
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let accessVC = mainStoryboard.instantiateViewController(withIdentifier: "AccessVC") as! AccessVC
                self.window?.rootViewController = accessVC
                self.window?.makeKeyAndVisible()
                
            } else { // Login successful
                print("User has been successfully signed in to Firebase")
                // Store important user data
                if let fireUser = Auth.auth().currentUser {
                    Global.databaseRef.child("users").child(fireUser.uid).observe(DataEventType.value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        let firstName = value?["firstName"] as? String ?? ""
                        let lastName = value?["lastName"] as? String ?? ""
                        let email = value?["email"] as? String ?? ""
                        let rawMeetings = value?["meetings"] as? NSArray ?? [String()]
                        Global.localUser = LocalUser(username: email,
                                                     firstName: firstName,
                                                     lastName: lastName,
                                                     meetings: DatabaseManager.stringsToMeetings(rawMeetings: rawMeetings))
                    }) { (error) in
                        print("ERROR:" + error.localizedDescription)
                    }
                }
                
                // Show user to AccessVC with automatic access
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let meetingListVC = mainStoryboard.instantiateViewController(withIdentifier: "MeetingListVC") as! MeetingListVC
                if let user = Global.localUser {
                    meetingListVC.user = user
                }
                self.window?.rootViewController = meetingListVC
                self.window?.makeKeyAndVisible()
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
    
    // MARK: - Temporary
    
    func generateTestMeeting() -> Meeting {
        
        let person1 = Person(firstName: "Jesús", lastName: "Parás")
        let person2 = Person(firstName: "Roberto", lastName: "Marcos")
        let person3 = Person(firstName: "Manuel", lastName: "Doblado")
        let person4 = Person(firstName: "Alfredo", lastName: "Peña")
        let participants = [Person.Role.administrador : person1, Person.Role.consejero : person2, Person.Role.secretario : person3, Person.Role.presidente : person4]
        
        let duration1 = TimeInterval(exactly: 30)
        let topic1 = Topic(color: UIColor.red, title: "Tema 1", responsible: person4, objective: "Objetivo del tema", pointsToDiscuss: [DiscussionPoint(point: "Punto 1"),
                                                                                                                                        DiscussionPoint(point: "Punto 2"),
                                                                                                                                        DiscussionPoint(point: "Punto 3"),
                                                                                                                                        DiscussionPoint(point: "Punto 4")], duration: duration1!)
        
        let duration2 = TimeInterval(exactly: 25)
        let topic2 = Topic(color: UIColor.gray, title: "Tema 2", responsible: person3, objective: "Objetivo del tema 2", pointsToDiscuss: [DiscussionPoint(point: "Punto 5"),
                                                                                                                                           DiscussionPoint(point: "Punto 6"),
                                                                                                                                           DiscussionPoint(point: "Punto 7"),
                                                                                                                                           DiscussionPoint(point: "Punto 8")], duration: duration2!)
        let duration3 = TimeInterval(exactly: 290)
        let topic3 = Topic(color: UIColor.brown, title: "Tema 3", responsible: person1, objective: "Objetivo del tema 3", pointsToDiscuss: [DiscussionPoint(point: "Punto 9"),
                                                                                                                                            DiscussionPoint(point: "Punto 10"),
                                                                                                                                            DiscussionPoint(point: "Punto 11"),
                                                                                                                                            DiscussionPoint(point: "Punto 12")], duration: duration3!)
        let topics = [topic1, topic2, topic3]
        
        let location = Location(name: Location.ValidName.sala1)
        
        return Meeting(title: "Test Meeting", timeDate: Date(), participants: participants, topics: topics, location: location)
    }

}

