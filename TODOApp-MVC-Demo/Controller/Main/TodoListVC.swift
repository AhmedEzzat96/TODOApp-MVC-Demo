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
        navigationItem.setHidesBackButton(true, animated: true)
        tableViewConfig()
        noTasksLabel.isHidden = true
        getAllTasks()
    }
    
    // MARK:- IBActions
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        let addTodoVC = AddTodoVC.create()
        addTodoVC.delegate = self
        present(addTodoVC, animated: true)
    }
    
    @IBAction func deleteBtnPressed(_ sender: UIBarButtonItem) {
        // Accessing selected rows if any
        guard let selectedRows = tableView.indexPathsForSelectedRows else {
            // Otherwise presenting alert to inform user that there is no selected tasks
            openAlert(title: "No tasks selected!", message: "Please select task or more to delete", alertStyle: .alert, actionTitles: ["Ok"], actionStyles: [.cancel], actions: [{ cancel in
                self.dismiss(animated: true, completion: nil)
                }
            ])
            return
        }
        
        openAlert(title: "Delete Tasks", message: "Are you sure you want to delete selected tasks?", alertStyle: .alert, actionTitles: ["Yes", "No"], actionStyles: [.destructive, .cancel], actions: [
            { [weak self] yesAction in
                for indexPath in selectedRows {
                    guard let todoID = self?.tasks[indexPath.row].id else {return}
                    APIManager.deleteTask(with: todoID) { (success) in
                        if success {
                            self?.getAllTasks()
                            print("Task Deleted")
                        } else {
                            print("Error")
                        }
                    }
                }
            }, nil])
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
        showActivityIndicator()
        APIManager.getAllTasks { [weak self] (error, _, taskData) in
            guard let strongSelf = self else {return}
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                
                guard let taskData = taskData else { return }
                strongSelf.tasks = taskData
                
                if strongSelf.tasks.count <= 0 {
                    DispatchQueue.main.async {
                        strongSelf.hideActivityIndicator()
                        strongSelf.noTasksLabel.isHidden = false
                        strongSelf.tableView.isHidden = true
                    }
                } else {
                    DispatchQueue.main.async {
                        strongSelf.hideActivityIndicator()
                        strongSelf.noTasksLabel.isHidden = true
                        strongSelf.tableView.isHidden = false
                        strongSelf.tableView.reloadData()
                        strongSelf.tableView.isEditing = false
                    }
                }
                print(strongSelf.tasks as Any)
            }
        }
    }
    
    // MARK:- Private Methods
    
    private func tableViewConfig() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.register(UINib(nibName: Cells.taskCell, bundle: nil), forCellReuseIdentifier: Cells.taskCell)
        // Creating long press gesture and adding it to tableview to handle multiple cells selection
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 1
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    // MARK:- Objc Methods
    @objc func handleLongPress() {
        // Allowing multiple cell selection to remove them
        tableView.allowsMultipleSelectionDuringEditing = true
        // Activate tableview editing style
        tableView.isEditing = true
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        // Deselect row if editing mode is not activated
        if !tableView.isEditing {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // Checking of no cells selected
        if tableView.indexPathForSelectedRow == nil {
            // Closing tableview editing style
            tableView.isEditing = false
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

// MARK:- Delegate Method
// delegation to refresh data
extension TodoListVC: refreshDataDelegate {
    func refreshData() {
        getAllTasks()
    }
}

