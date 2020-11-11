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
        let todoListNav = UINavigationController(rootViewController: todoListVC)
        AppDelegate.shared().window?.rootViewController = todoListNav
    }
    
    // MARK:- API
    private func register(with user: User) {
        self.view.showActivityIndicator()
        
        APIManager.register(with: user) { [weak self] (response) in
            
            switch response {
                
            case .success(let signupData):
                UserDefaultsManager.shared().token = signupData.token
                UserDefaultsManager.shared().id = signupData.user.id
                self?.goToMainVC()
            case .failure(let error):
                print(error.localizedDescription)
                self?.openAlert(title: "Error", message: "This email is already register", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.cancel], actions: nil)
            }
            
            DispatchQueue.main.async {
                self?.view.hideActivityIndicator()
            }
        }
    }
}
