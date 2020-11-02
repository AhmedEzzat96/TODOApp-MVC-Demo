//
//  TaskCell.swift
//  TODOApp-MVC-Demo
//
//  Created by Ahmed Ezzat on 10/30/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK:- Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowAndBorderForCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK:- Private Methods
    func configurecell(task: TaskData) {
        descriptionLabel.text = task.description
    }
    
}
