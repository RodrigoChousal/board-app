//
//  SignUpVC.swift
//  BoardApp
//
//  Created by Rodrigo Chousal on 9/1/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpVC: UIViewController {

	@IBOutlet weak var firstNameField: UITextField!
	@IBOutlet weak var lastNameField: UITextField!
	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var firstPasswordField: UITextField!
	@IBOutlet weak var secondPasswordField: UITextField!
	
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
	
	@IBAction func signUpPressed(_ sender: Any) {
		
		print("Sign up pressed...")
		
		let formIncomplete = checkFormCompletion()
		
		if formIncomplete > 0 { // A field or payment is missing
			
			var missingField = ""
			
			switch formIncomplete {
			case 1:
				missingField = "su primer nombre"
			case 2:
				missingField = "su apellido"
			case 3:
				missingField = "su correo electrónico"
			case 4:
				missingField = "su contraseña"
			case 5:
				missingField = "un método de pago"
			default:
				missingField = "sus datos"
			}
			
			print("There is a missing field...")
			
//			SCLAlertView().showWarning("Ups!", subTitle: "Favor de ingresar \(missingField)")
			
		} else if (self.firstPasswordField.text != self.secondPasswordField.text) {
			
			print("Make sure both passwords are different...")
			
		} else {
			
			// TODO: Compare 1st and 2nd passwords
			// TODO: Show password strength!
			// TODO: Check for password errors... length, etc.
			view.showLoadingIndicator(withMessage: "Creando usuario...")
			
			let firstName = self.firstNameField.text!
			let lastName = self.lastNameField.text!
			let email = self.emailField.text!
			let password = self.firstPasswordField.text!
			let secondPassword = self.secondPasswordField.text!
			
			Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
				
				print("Successfully created user with email")
				
				// Store user credentials in keychain
				let credentials = Credentials(email: email, password: password)
				KeychainManager.storeCredentials(credentials: credentials)
				
				if let fireUser = Auth.auth().currentUser {
					
					// Store details locally:
					Global.localUser = User(email: email, firstName: firstName, lastName: lastName, meetingsIdList: [String]())
					print("Created local user with empty meetingsIdList")
					
					// Store details in d cloud:
					if let localUser = Global.localUser {
						Global.databaseRef.child("users").child(fireUser.uid)
							.setValue(["email" : localUser.email,
									   "firstName" : localUser.firstName,
									   "lastName" : localUser.lastName,
									   "meetingsIdList" : localUser.meetingsIdList])
						let changeRequest = fireUser.createProfileChangeRequest()
						changeRequest.displayName = firstName + " " + lastName
					}
					
					// We're done
					print("Finished sign up. Accessing main VC.")
					DispatchQueue.main.async {
						self.view.stopLoadingIndicator()
						self.performSegue(withIdentifier: "AccessSegue", sender: self)
					}
					
				} else {
//					self.view.stopLoadingIndicator()
					if let error = error {
//						SCLAlertView().showWarning("Ups!", subTitle: error.localizedDescription)
						print("Error with current USER!")
						print(error.localizedDescription)
					}
				}
			}
		}
	}
	
	// MARK: - Helper Methods
	
	func checkFormCompletion() -> Int {
		
		let requiredFields = [firstNameField, lastNameField, emailField, firstPasswordField, secondPasswordField]
		
		let missingPayment = false
		// TODO: Check if missing payment
		print(missingPayment)
		
		var count = 1
		
		// Check if missing any required field
		for field in requiredFields {
			
			// TODO: Check for password and email validity
			
			if let text = field?.text, text.isEmpty {
				return count
			}
			count += 1
		}
		return 0
	}
}
