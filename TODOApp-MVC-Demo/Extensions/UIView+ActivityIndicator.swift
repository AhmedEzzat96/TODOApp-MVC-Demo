//
//  UIViewController+ActivityIndicator.swift
//  TODOApp-MVC-Demo
//
//  Created by Ahmed Ezzat on 10/30/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func showActivityIndicator() {
        let activityIndicator = setupActivityIndicator()
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
    }

    func hideActivityIndicator() {
        if let activityIndicator = viewWithTag(100) {
            activityIndicator.removeFromSuperview()
        }
    }
    
    func setupActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: self.bounds.width/2, y: self.bounds.height/2, width: 100, height: 100))
        activityIndicator.backgroundColor = .clear
        activityIndicator.layer.cornerRadius = 0
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = .blue
        activityIndicator.tag = 100
        return activityIndicator
    }
}
