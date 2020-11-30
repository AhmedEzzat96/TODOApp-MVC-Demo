//
//  ValidatorManager.swift
//  TODOApp-MVC-Demo
//
//  Created by Ahmed Ezzat on 20/11/2020.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation

enum ValidationType {
    case email
    case password
    case name
    case age
    
    var error: (title: String, message: String) {
        switch self {
        case .email:
            return ("Email is invalid!", "Email should be : example@mail.com")
        case .password:
            return ("Password is wrong!", "Password should be at least 8 charcters")
        case .name:
            return ("Name is invalid!", "Name should contain letters only ")
        case .age:
            return ("Age is invalid!", "Age should be more than 0")
        }
    }
}

class ValidatorManager {
    
    private static let sharedInstance = ValidatorManager()
    
    class func shared() -> ValidatorManager {
        return ValidatorManager.sharedInstance
    }
    
    func isValid(with string: String?, validationType: ValidationType?) -> Bool {
        guard let string = string else {return false}
        switch validationType {
        case .email:
            if !string.isValidEmail || string.isEmpty {
                return false
            }
            return true
        case .password:
            if !string.isValidPassword || string.isEmpty {
                return false
            }
            return true
        case .name:
            if !string.isValidName || string.isEmpty {
                return false
            }
            return true
        case .age:
            guard let age = Int(string) else { return false }
            if string.isEmpty ||  age <= 0 {
                return false
            }
            return true
        case .none:
            return true
        }
    }
    
    
}
