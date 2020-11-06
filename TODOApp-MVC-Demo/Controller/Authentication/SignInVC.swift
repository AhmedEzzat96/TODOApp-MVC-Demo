import UIKit

class SignInVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK:- IBActions
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            isValid(with: .email, email),
            isValid(with: .password, password) else {
                return
        }

        signIn(with: email, password: password)
    }
    
    @IBAction func createAccBtnPressed(_ sender: UIButton) {
        let signUpVC = SignUpVC.create()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    // MARK:- Public Methods
    class func create() -> SignInVC {
        let signInVC: SignInVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signInVC)
        return signInVC
    }
}

extension SignInVC {
    // MARK:- Private Methods
    private func goToMainVC() {
        let todoListVC = TodoListVC.create()
        let todoListNav = UINavigationController(rootViewController: todoListVC)
        AppDelegate.shared().window?.rootViewController = todoListNav
    }
    
    // MARK:- API
    private func signIn(with email: String, password: String) {
        self.view.showActivityIndicator()
        APIManager.login(with: email, password: password) { [weak self] (error, loginData) in
            
            if let error = error {
                print(error.localizedDescription)
                self?.openAlert(title: "Attention!", message: "Your email or password is incorrect, please try again", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.cancel], actions: nil)
            } else if let loginData = loginData {
                print(loginData.token)
                UserDefaultsManager.shared().token = loginData.token
                UserDefaultsManager.shared().id = loginData.user.id
                self?.goToMainVC()
            }
            
            DispatchQueue.main.async {
                self?.view.hideActivityIndicator()
            }
        }
    }
}
