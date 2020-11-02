import UIKit

class SignUpVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var ageLabel: UILabel!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK:- IBActions

    // Stepper for age
    @IBAction func ageStepper(_ sender: UIStepper) {
        ageLabel.text = "\(Int(sender.value))"
    }
    
    // check if the userData valid
    // if the userData is invalid show alert
    // otherwise, call the api service to register
    
    @IBAction func registerBtnPressed(_ sender: UIButton) {
        guard let name = nameTextField.text, isValid(with: .name, name),
            let email = emailTextField.text, isValid(with: .email, email),
            let password = passwordTextField.text, isValid(with: .password, password),
            let ageString = ageLabel.text, isValid(with: .age, ageString),
            let age = Int(ageString) else { return }
        
        let user = User(name: name,
                        email: email,
                        password: password,
                        age: age)
        
        register(with: user)
        
    }
    
    // MARK:- Public Methods
    class func create() -> SignUpVC {
        let signUpVC: SignUpVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signUpVC)
        return signUpVC
    }
    
}

extension SignUpVC {
    // MARK:- Private Methods
    private func goToMainVC() {
        let todoListVC = TodoListVC.create()
        navigationController?.pushViewController(todoListVC, animated: true)
    }
    
    // MARK:- API
    private func register(with user: User) {
        self.showActivityIndicator()
        
        APIManager.signup(with: user) { [weak self] (error, signupData) in
            
            DispatchQueue.main.async {
                self?.hideActivityIndicator()
            }
            
            if let error = error {
                print(error.localizedDescription)
                self?.openAlert(title: "Error", message: "This email is already register", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.cancel], actions: nil)
            } else if let signupData = signupData {
                print(signupData.token)
                UserDefaultsManager.shared().token = signupData.token
                self?.goToMainVC()
            }
        }
    }
}
