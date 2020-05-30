//
//  ViewController.swift
//  COVID
//
//  Created by Prem Dhoot on 5/30/20.
//  Copyright © 2020 Prem Dhoot. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var topButton: UIButton!
    
    var signUpMode = false
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                           
    }

    
    @IBAction func topTapped(_ sender: Any) {
        if let username = usernameTextField.text {
            if let password = passwordTextField.text {
                Auth.auth().signIn(withEmail: username, password: password) { (user, error) in
                    if error != nil {
                        self.displayAlert(title: "Error", message: error!.localizedDescription)
                    } else {
                        if user?.user.displayName == "Volunteer" {
                            //Volunteer
                            self.performSegue(withIdentifier: "volunteerLogin", sender: nil)
                        } else {
                            //Rider
                            self.performSegue(withIdentifier: "citizenLogin", sender: nil)
                        }
                    }
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        passwordTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        
        return true
        
    }
    
    
    
   

}

