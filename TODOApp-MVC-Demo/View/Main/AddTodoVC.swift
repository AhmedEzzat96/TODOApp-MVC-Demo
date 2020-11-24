
import UIKit

protocol refreshDataDelegate: class {
    func refreshData()
}

class AddTodoVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var addTodoView: UIView!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    // MARK:- Properties
    weak var delegate: refreshDataDelegate?
    var presenter: AddTodoPresenter!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTodoView()
    }
    
    // MARK:- IBActions
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        let task = Task(description: descriptionTextField.text)
        presenter.taskDone(with: task)
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK:- Public Methods
    class func create() -> AddTodoVC {
        let addTodoVC: AddTodoVC = UIViewController.create(storyboardName: Storyboards.main, identifier: ViewControllers.addTodoVC)
        addTodoVC.presenter = AddTodoPresenter(view: addTodoVC)
        return addTodoVC
    }
    
    func showIndicator() {
        view.showActivityIndicator()
    }
    
    func hideIndicator() {
        view.hideActivityIndicator()
    }
    
    func dismissVC() {
        self.dismiss(animated: true) { [weak self] in
            self?.delegate?.refreshData()
        }
    }
    
    func openAlert(title: String, message: String) {
        self.openAlert(title: title, message: message, alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: nil)
    }
    
}

extension AddTodoVC {
    
    // MARK:- Private Methods
    private func setupTodoView() {
        addTodoView.layer.cornerRadius = 20
        addTodoView.layer.masksToBounds = true
    }
}
