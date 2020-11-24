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
    }
    
    // MARK:- IBActions
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        let user = User(email: emailTextField.text, password: passwordTextField.text)
        presenter.goToMainScreen(with: user)
    }
    
    @IBAction func createAccBtnPressed(_ sender: UIButton) {
        let signUpVC = SignUpVC.create()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    // MARK:- Public Methods
    class func create() -> SignInVC {
        let signInVC: SignInVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signInVC)
        signInVC.presenter = SignInVCPresenter(view: signInVC)
        return signInVC
    }
    
    func showIndicator() {
        view.showActivityIndicator()
    }
    
    func hideIndicator() {
        view.hideActivityIndicator()
    }
    
    func openAlert(title: String, message: String) {
     openAlert(title: title, message: message, alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.cancel], actions: nil)
    }
    
    func goToMainVC() {
        let todoListVC = TodoListVC.create()
        let todoListNav = UINavigationController(rootViewController: todoListVC)
        AppDelegate.shared().window?.rootViewController = todoListNav
    }
    
}
