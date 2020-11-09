import UIKit

class TodoListVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noTasksLabel: UILabel!
    
    // MARK:- Properties
    var tasks = [TaskData]()
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfig()
        getAllTasks()
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
        return todoListVC
    }
    
}

extension TodoListVC {
    // MARK:- API
    private func getAllTasks() {
        self.view.showActivityIndicator()
        APIManager.getAllTasks { [weak self] (response) in
            guard let strongSelf = self else {return}
            switch response {
                
            case .success(let taskData):
                strongSelf.tasks = taskData.data
                
                if strongSelf.tasks.count <= 0 {
                    DispatchQueue.main.async {
                        strongSelf.view.hideActivityIndicator()
                        strongSelf.noTasksLabel.isHidden = false
                        strongSelf.tableView.isHidden = true
                    }
                } else {
                    DispatchQueue.main.async {
                        strongSelf.view.hideActivityIndicator()
                        strongSelf.noTasksLabel.isHidden = true
                        strongSelf.tableView.isHidden = false
                        strongSelf.tableView.reloadData()
                        strongSelf.tableView.isEditing = false
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // delete task by id from api
    private func deleteTask(with id: String) {
        self.view.showActivityIndicator()
        APIManager.deleteTask(with: id) { [weak self] (success) in
            if success {
                self?.getAllTasks()
                print("Task Deleted")
            } else {
                print("Error")
            }
            self?.view.hideActivityIndicator()
        }
    }
    
    // MARK:- Private Methods
    
    private func tableViewConfig() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Cells.taskCell, bundle: nil), forCellReuseIdentifier: Cells.taskCell)
    }
    
}

// MARK: - Table view data source
extension TodoListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.taskCell, for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }
        cell.configurecell(task: tasks[indexPath.row])
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
        getAllTasks()
    }
}

// delegation to show alert if you want to delete task
extension TodoListVC: showAlertDelegate {
    func showAlert(customTableViewCell: UITableViewCell, didTapButton button: UIButton) {
        guard let indexPath = self.tableView.indexPath(for: customTableViewCell) else {return}
        openAlert(title: "Sorry", message: "Are You Sure Want to Delete this TODO?", alertStyle: .alert, actionTitles: ["No", "Yes"], actionStyles: [.cancel, .destructive], actions: [nil, { [weak self] yesAction in
            guard let id = self?.tasks[indexPath.row].id else { return }
            self?.deleteTask(with: id)
            }])
    }
}

