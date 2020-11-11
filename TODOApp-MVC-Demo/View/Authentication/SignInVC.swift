import UIKit

class SignInVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK:- Properties
    var presenter: SignInVCPresenter!
    
    // MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SignInVCPresenter(view: self)
    }
    
    // MARK:- IBActions
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            isValid(with: .email, email),
            isValid(with: .password, password) else {
                return
        }
        let user = User(email: email, password: password)
        presenter.signIn(with: user)
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

// MARK:- SignInVC Presenter Delegation
extension SignInVC: SignInView {
    
    func showIndicator() {
        view.showActivityIndicator()
    }
    
    func hideIndicator() {
        view.hideActivityIndicator()
    }
    
    func showError(error: String) {
        print(error)
    }
    
    func openAlert() {
        openAlert(title: "Attention!", message: "Your email or password is incorrect, please try again", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.cancel], actions: nil)
       }
    
    func goToMainVC() {
       let todoListVC = TodoListVC.create()
        let todoListNav = UINavigationController(rootViewController: todoListVC)
        AppDelegate.shared().window?.rootViewController = todoListNav
    }
    
}
