//
//  TaskCell.swift
//  TODOApp-MVC-Demo
//
//  Created by Ahmed Ezzat on 10/30/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

protocol showAlertDelegate: AnyObject {
    func showAlert(customTableViewCell: UITableViewCell, didTapButton button: UIButton)
}

class TaskCell: UITableViewCell {
    // MARK:- IBOutlets
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK:- Properties
    weak var delegate: showAlertDelegate?
    
    // MARK:- Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowAndBorderForCell()
    }
    
    // MARK:- IBActions
    @IBAction func deleteBtnPressed(_ sender: UIButton) {
        self.delegate?.showAlert(customTableViewCell: self, didTapButton: sender)
    }
    
}

extension TaskCell {
    // MARK:- Private Methods
    func configurecell(task: TaskData) {
        descriptionLabel.text = task.description
    }
}
