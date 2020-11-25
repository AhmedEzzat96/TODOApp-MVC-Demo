import UIKit

class TodoListVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet var todoListView: TodoListView!
    
    
    // MARK:- Properties
    var presenter: TodoListPresenter!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        todoListView.setupView()
        tableViewConfig()
        presenter.viewDidLoad()
    }
    
    // MARK:- IBActions
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        let addTodoVC = AddTodoVC.create()
        addTodoVC.delegate = self
        present(addTodoVC, animated: true)
    }
    
    @IBAction func profileBtnPressed(_ sender: UIBarButtonItem) {
        let profileVC = ProfileVC.create()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    
    // MARK:- Public Methods
    class func create() -> TodoListVC {
        let todoListVC: TodoListVC = UIViewController.create(storyboardName: Storyboards.main, identifier: ViewControllers.todoListVC)
        todoListVC.presenter = TodoListPresenter(view: todoListVC)
        return todoListVC
    }
    
    func showIndicator() {
        view.showActivityIndicator()
    }
    
    func hideIndicator() {
        view.hideActivityIndicator()
    }
    
    func noTasksFound() {
        self.todoListView.noTasksLabel.isHidden = false
        self.todoListView.tableView.isHidden = true
    }
    
    func fetchingData() {
        self.todoListView.noTasksLabel.isHidden = true
        self.todoListView.tableView.isHidden = false
        self.todoListView.tableView.reloadData()
        self.todoListView.tableView.isEditing = false
    }
    
    func openAlertWithAction(title: String, message: String, actionTitles: [String], actionStyles: [UIAlertAction.Style], actions: [((UIAlertAction) -> Void)?]?) {
        openAlert(title: title, message: message, alertStyle: .alert, actionTitles: actionTitles, actionStyles: actionStyles, actions: actions)
    }
    
}

extension TodoListVC {
    
    // MARK:- Private Methods
    
    private func tableViewConfig() {
        todoListView.tableView.delegate = self
        todoListView.tableView.dataSource = self
        todoListView.tableView.register(UINib(nibName: Cells.taskCell, bundle: nil), forCellReuseIdentifier: Cells.taskCell)
    }
    
}

// MARK: - Table view data source
extension TodoListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getTasksCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.taskCell, for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }
        presenter.configure(cell: cell, for: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK:- Delegate Method
// delegation to refresh data
extension TodoListVC: refreshDataDelegate {
    func refreshData() {
        presenter.getAllTasks()
    }
}

// delegation to show alert if you want to delete task
extension TodoListVC: showAlertDelegate {
    func showAlert(customTableViewCell: UITableViewCell, didTapButton button: UIButton) {
        guard let indexPath = self.todoListView.tableView.indexPath(for: customTableViewCell) else {return}
        presenter.deleteTaskAlert(with: indexPath.row)
    }
}

