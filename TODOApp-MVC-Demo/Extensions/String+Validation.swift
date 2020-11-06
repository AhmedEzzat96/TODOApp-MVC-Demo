
import Foundation
import UIKit

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

extension String {
    
    var isValidEmail: Bool {
        get {
            let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
            let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
            return emailTest.evaluate(with: self)
        }
    }
    
   var isValidPassword: Bool {
        get {
            let passwordRegex = "[A-Za-z0-9.-]{8,}"
            return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
        }
    }
    
    var isValidName: Bool {
        get {
            let nameRegex = "^[a-zA-Z- ]*$"
            return NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: self)
        }
    }
    
}
