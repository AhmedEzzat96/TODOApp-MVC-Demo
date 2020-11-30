import UIKit

protocol SignUpVCProtocol: class {
    func showIndicator()
    func hideIndicator()
    func openAlert(title: String, message: String)
    func goToMainVC()
}

class SignUpVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet var signUpView: SignUpView!
    
    // MARK:- Properties
    var presenter: SignUpVCPresenter!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView.setupView()
    }
    
    // MARK:- IBActions
    @IBAction func ageStepper(_ sender: UIStepper) {
        signUpView.ageLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func registerBtnPressed(_ sender: UIButton) {
        guard let ageString = signUpView.ageLabel.text else { return }
        let user = User(name: signUpView.nameTextField.text,
                        email: signUpView.emailTextField.text,
                        password: signUpView.passwordTextField.text,
                        age: Int(ageString))
        
        presenter.goToMainScreen(with: user)
        
    }
    
    // MARK:- Public Methods
    class func create() -> SignUpVC {
        let signUpVC: SignUpVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signUpVC)
        signUpVC.presenter = SignUpVCPresenter(view: signUpVC)
        return signUpVC
    }
}

//MARK:- Protocol Methods
extension SignUpVC: SignUpVCProtocol {
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
