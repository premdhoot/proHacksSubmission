//
//  User.swift
//  COVID
//
//  Created by Prem Dhoot on 4/5/20.
//  Copyright © 2020 Prem Dhoot. All rights reserved.
//

import Foundation

class User: Codable {
    
    
    static func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        if writeToUserDefaults {
            
            if let data = try? JSONEncoder().encode(user) {
                
                UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
                
            }
            
        }
        
        _ current = user
        
    }
    
}
