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
        shadowAndBorderForCell(yourTableViewCell: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK:- Private Methods
    func configurecell(task: TaskData) {
        descriptionLabel.text = task.description
    }
    
}

extension UITableViewCell{
    func shadowAndBorderForCell(yourTableViewCell : UITableViewCell){
        // SHADOW AND BORDER FOR CELL
        yourTableViewCell.contentView.layer.cornerRadius = 20
        yourTableViewCell.contentView.layer.borderWidth = 1
        yourTableViewCell.contentView.layer.borderColor = UIColor.darkGray.cgColor
        yourTableViewCell.contentView.layer.masksToBounds = true
        yourTableViewCell.layer.shadowColor = UIColor.gray.cgColor
        yourTableViewCell.layer.shadowOffset = CGSize(width: 0, height: 2)
        yourTableViewCell.layer.shadowRadius = 2.0
        yourTableViewCell.layer.shadowOpacity = 1.0
        yourTableViewCell.layer.masksToBounds = false
        yourTableViewCell.layer.shadowPath = UIBezierPath(roundedRect:yourTableViewCell.bounds, cornerRadius:yourTableViewCell.contentView.layer.cornerRadius).cgPath
    }
}
