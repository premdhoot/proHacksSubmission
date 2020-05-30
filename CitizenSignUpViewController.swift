//
//  CitizenSignUpViewController.swift
//  COVID
//
//  Created by Prem Dhoot on 5/30/20.
//  Copyright © 2020 Prem Dhoot. All rights reserved.
//

import UIKit
import FirebaseAuth

class CitizenSignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var signUpMode = true
    
    override func viewDidLoad() {
           super.viewDidLoad()
                
        passwordTextField.delegate = self
        usernameTextField.delegate = self
    
            
       }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        if usernameTextField.text == "" || passwordTextField.text == "" {
            displayAlert(title: "Missing Information", message: "Please fill in all text fields")
        } else {
           //SIGN UP
            if let username = usernameTextField.text {
                if let password = passwordTextField.text {
                    Auth.auth().createUser(withEmail: username, password: password) { (user, error) in
                        if error != nil {
                            self.displayAlert(title: "Error", message: error!.localizedDescription)
                        } else {
                            let request = Auth.auth().currentUser?.createProfileChangeRequest()
                            request?.displayName = "Citizen"
                            request?.commitChanges(completion: nil)
                            self.performSegue(withIdentifier: "citizenSegue", sender: nil)
                        }
                    }
                }
            }
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        return true
        
        
    }
    
   
    


}
