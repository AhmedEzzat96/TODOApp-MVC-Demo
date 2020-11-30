
import UIKit

class TodoListView: UIView {
    //MARK:- Outlets
    @IBOutlet weak var noTasksLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Public Methods
    func setupView() {
        setupBackGround()
        setupLabel()
        setupTableView()
    }
}

//MARK:- Private Methods
extension TodoListView {
    private func setupBackGround() {
        self.backgroundColor = .systemBackground
    }
    
    private func setupLabel() {
        noTasksLabel.isHidden = true
        noTasksLabel.text = "No Tasks Found!"
        noTasksLabel.font = UIFont(name: "MarkerFelt-Wide", size: 21)
        noTasksLabel.textAlignment = .center
    }
    
    private func setupTableView() {
        tableView.isHidden = true
        tableView.separatorColor = .darkGray
        tableView.separatorStyle = .none
    }
}
