import UIKit

class SigninView: UIView {
    //MARK:- Outlets
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var createAccountBtn: UIButton!
    
    //MARK:- Public Methods
    func setupView() {
        setupBackGround()
        setupLabel()
        setupTextField(emailTextField, placeHolder: "Email...", keyboardType: .emailAddress)
        setupTextField(passwordTextField, placeHolder: "Password...", isSceure: true)
        setupButton(loginBtn, title: "Log in", backgroundColor: .link, textColor: .white, fontSize: 26)
        setupButton(createAccountBtn, title: "create account", textColor: .link)
    }
    
}

//MARK:- Private Methods
extension SigninView {
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
    
    private func setupLabel() {
        loginLabel.text = "Sign in"
        loginLabel.font = UIFont(name: "MarkerFelt-Wide", size: 30)
        loginLabel.textAlignment = .center
    }
}
