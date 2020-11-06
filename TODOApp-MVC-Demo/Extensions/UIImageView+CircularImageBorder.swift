//
//  UIImageView+CircularImageBorder.swift
//  TODOApp-MVC-Demo
//
//  Created by Ahmed Ezzat on 11/4/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func circularImageView() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}
