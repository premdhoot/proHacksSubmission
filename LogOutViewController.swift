//
//  LogOutViewController.swift
//  COVID
//
//  Created by Prem Dhoot on 5/30/20.
//  Copyright © 2020 Prem Dhoot. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LogOutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func logOutButtonPressed(_ sender: Any) {
        
        try? Auth.auth().signOut()
        performSegue(withIdentifier: "backToLogin", sender: self)
        
    }
    
}
