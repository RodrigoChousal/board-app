//
//  AccessVC.swift
//  BoardApp
//
//  Created by Rodrigo Chousal on 8/28/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import UIKit
import FirebaseAuth

class AccessVC: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func signInPressed(_ sender: Any) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        Auth.auth().signIn(withEmail: email, password: password) { (dataResult, error) in
            if let error = error { // Login failed
                
                // Print error and display alert
                print(error)
                
            } else { // Login successful
                
                // Store important user data
                if let fireUser = Auth.auth().currentUser {
                    Global.databaseRef.child("users").child(fireUser.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        let firstName = value?["firstName"] as? String ?? ""
                        let lastName = value?["lastName"] as? String ?? ""
                        let email = value?["email"] as? String ?? ""
                        Global.localUser = LocalUser(username: email,
                                                     firstName: firstName,
                                                     lastName: lastName)
                        
                        // Store user credentials in keychain
                        let credentials = Credentials(email: email, password: password)
                        KeychainManager.storeCredentials(credentials: credentials)
                        
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                }
                
                // Show guests inside
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "AccessSegue", sender: self)
                }
                
            }
        }
    }
}
