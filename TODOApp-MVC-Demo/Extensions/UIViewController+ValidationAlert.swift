
import Foundation
import UIKit

extension UIViewController {
    
    func isValid(with validationType: ValidationType,_ string: String) -> Bool {
        switch validationType {
            
        case .email:
            if !string.isValidEmail || string.isEmpty {
                openAlert(title: validationType.error.title, message: validationType.error.message, alertStyle: .alert, actionTitles: ["Ok"], actionStyles: [.cancel], actions: [nil])
                return false
            }
        case .password:
            if !string.isValidPassword || string.isEmpty {
                openAlert(title: validationType.error.title, message: validationType.error.message, alertStyle: .alert, actionTitles: ["Ok"], actionStyles: [.cancel], actions: [nil])
                return false
            }
            
        case .name:
            if !string.isValidName || string.isEmpty {
                openAlert(title: validationType.error.title, message: validationType.error.message, alertStyle: .alert, actionTitles: ["Ok"], actionStyles: [.cancel], actions: [nil])
                return false
            }
            
        case .age:
            guard let age = Int(string) else {
                openAlert(title: validationType.error.title, message: validationType.error.message, alertStyle: .alert, actionTitles: ["Ok"], actionStyles: [.cancel], actions: [nil])
                return false }
            if age <= 0 {
                openAlert(title: validationType.error.title, message: validationType.error.message, alertStyle: .alert, actionTitles: ["Ok"], actionStyles: [.cancel], actions: [nil])
                return false
            }
        }
        return true
    }
}
