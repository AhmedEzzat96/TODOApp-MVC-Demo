
import Foundation

class AddTodoPresenter {
    
    //MARK:- Properties
    private weak var view: AddTodoVC?
    
    // MARK:- Life Cycle Methods
    init(view: AddTodoVC) {
        self.view = view
    }
    
    // MARK:- Private Methods
    private func addTask(with task: Task) {
        self.view?.showIndicator()
        APIManager.addTask(with: task) { [weak self] (success) in
            guard let self = self else {return}
            if success {
                print("Task Added")
                self.view?.dismissVC()
            } else {
                print("Failed to add task")
                DispatchQueue.main.async {
                    self.view?.openAlert(title: "Error!", message: "Failed to add task, please try again!")
                }
            }
            self.view?.hideIndicator()
        }
    }
    
    private func validateTask(with task: Task?) -> Bool {
        guard let description = task?.description, !description.isEmpty else {
            self.view?.openAlert(title: "Warning!", message: "Please Fill the description TextField")
            return false
        }
        return true
    }
    
    // MARK:- Public Methods
    func taskDone(with task: Task) {
        if validateTask(with: task) {
            addTask(with: task)
        }
    }
}
