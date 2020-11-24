import UIKit

class SignUpVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var ageLabel: UILabel!
    
    // MARK:- Properties
    var presenter: SignUpVCPresenter!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK:- IBActions
    
    @IBAction func ageStepper(_ sender: UIStepper) {
        ageLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func registerBtnPressed(_ sender: UIButton) {
        guard let ageString = ageLabel.text else { return }
        let user = User(name: nameTextField.text,
                        email: emailTextField.text,
                        password: passwordTextField.text,
                        age: Int(ageString))
        
        presenter.goToMainScreen(with: user)
        
    }
    
    // MARK:- Public Methods
    class func create() -> SignUpVC {
        let signUpVC: SignUpVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signUpVC)
        signUpVC.presenter = SignUpVCPresenter(view: signUpVC)
        return signUpVC
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
}

extension SignUpVC {
    // MARK:- Private Methods
    internal func goToMainVC() {
        let todoListVC = TodoListVC.create()
        let todoListNav = UINavigationController(rootViewController: todoListVC)
        AppDelegate.shared().window?.rootViewController = todoListNav
    }
}
