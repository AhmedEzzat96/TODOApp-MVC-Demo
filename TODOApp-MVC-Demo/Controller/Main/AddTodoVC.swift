//
//  AddTodoVC.swift
//  TODOApp-MVC-Demo
//
//  Created by Ahmed Ezzat on 10/30/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

protocol refreshDataDelegate: AnyObject {
    func refreshData()
}

class AddTodoVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var addTodoView: UIView!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    // MARK:- Properties
    weak var delegate: refreshDataDelegate?
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTodoView()
    }
    
    // MARK:- IBActions
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        guard let description = descriptionTextField.text, !description.isEmpty else {
            openAlert(title: "Warning!", message: "Please Fill the description TextField", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.cancel], actions: nil)
            return
        }
        addTask(with: description)
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK:- Public Methods
    class func create() -> AddTodoVC {
        let addTodoVC: AddTodoVC = UIViewController.create(storyboardName: Storyboards.main, identifier: ViewControllers.addTodoVC)
        return addTodoVC
    }
    
}

extension AddTodoVC {
    
    // MARK:- API
    private func addTask(with description: String) {
        self.view.showActivityIndicator()
        APIManager.addTask(with: description) { [weak self] (success) in
            if success {
                print("Task Added")
                self?.dismiss(animated: true, completion: {
                    self?.delegate?.refreshData()
                })
            } else {
                print("Failed to add task")
                DispatchQueue.main.async {
                    self?.openAlert(title: "Error!", message: "Failed to add task, please try again!", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.cancel], actions: nil)
                }
            }
            self?.view.hideActivityIndicator()
        }
    }
    
    // MARK:- Private Methods
    private func setupTodoView() {
        addTodoView.layer.cornerRadius = 20
        addTodoView.layer.masksToBounds = true
    }
}
