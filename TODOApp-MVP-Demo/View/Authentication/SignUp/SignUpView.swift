
import UIKit

class SignUpView: UIView {
    
    //MARK:- Outlets
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageStepper: UIStepper!
    @IBOutlet weak var registerBtn: UIButton!
    
    //MARK:- Public Methods
    func setupView() {
        setupBackGround()
        setupLabel(signUpLabel, text: "Sign up", fontSize: 30)
        setupLabel(ageLabel, text: "Age", fontSize: 20)
        setupTextField(nameTextField, placeHolder: "Name...")
        setupTextField(emailTextField, placeHolder: "Email...", keyboardType: .emailAddress)
        setupTextField(passwordTextField, placeHolder: "Password...", isSceure: true)
        setupButton(registerBtn, title: "Register", backgroundColor: .link, textColor: .white, fontSize: 26)
    }
}

//MARK:- Private Methods
extension SignUpView {
    private func setupBackGround() {
        self.backgroundColor = .systemBackground
    }
    
    private func setupTextField(_ textField: UITextField, placeHolder: String, isSceure: Bool = false, keyboardType: UIKeyboardType = .default){
        textField.backgroundColor = .white
        textField.placeholder = placeHolder
        textField.font = UIFont(name: "MarkerFelt-Wide", size: 20)
        textField.isSecureTextEntry = isSceure
        textField.keyboardType = keyboardType
    }
    
    private func setupButton(_ button: UIButton, title: String, backgroundColor: UIColor = .clear, textColor: UIColor, fontSize: CGFloat = 20){
        button.backgroundColor = backgroundColor
        button.titleLabel?.font = UIFont(name: "MarkerFelt-Wide", size: fontSize)
        button.layer.cornerRadius = 15
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitle(title, for: .normal)
    }
    
    private func setupLabel(_ label: UILabel, text: String, fontSize: CGFloat) {
        label.text = text
        label.font = UIFont(name: "MarkerFelt-Wide", size: fontSize)
        label.textAlignment = .center
    }
}
