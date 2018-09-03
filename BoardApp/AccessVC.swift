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
    
    // MARK: - Action Methods

    @IBAction func signInPressed(_ sender: Any) {
		
		view.showLoadingIndicator(withMessage: "Iniciando sesión...")
        
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        Auth.auth().signIn(withEmail: email, password: password) { (dataResult, error) in
            if let error = error { // Login failed
				
				self.view.stopLoadingIndicator()
                // Print error and display alert
                print("ERROR: ")
                print(error)
                
            } else { // Login successful
                
                // Store user credentials in keychain
                let credentials = Credentials(email: email, password: password)
                KeychainManager.storeCredentials(credentials: credentials)
                
                // Store important user data
                if let fireUser = Auth.auth().currentUser {
                    print("Successfully captured current user")
					Global.usersCollectionRef.document(fireUser.uid).getDocument(completion: { (document, error) in
						if let error = error {
							print("Error after sign in!")
							print(error.localizedDescription)
						} else {
							let value = document?.data() as NSDictionary?
							let firstName = value?["firstName"] as? String ?? ""
							let lastName = value?["lastName"] as? String ?? ""
							let email = value?["email"] as? String ?? ""
							let meetingsIdList = value?["meetingsIdList"] as? [String] ?? [String]()
							print(meetingsIdList.description)
							Global.localUser = User(email: email,
													firstName: firstName,
													lastName: lastName,
													meetingsIdList: meetingsIdList)
							// Show guests inside
							DispatchQueue.main.async {
								self.view.stopLoadingIndicator()
								self.performSegue(withIdentifier: "AccessSegue", sender: self)
							}

						}
					})
                }
            }
        }
    }
}
