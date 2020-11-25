//
//  AddTodoView.swift
//  TODOApp-MVC-Demo
//
//  Created by Ahmed Ezzat on 25/11/2020.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class AddTodoView: UIView {
    //MARK:- Outlets
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    //MARK:- Public Methods
    func setupView() {
        setupBackGround()
        setupPopUpView()
        setupCancelBtn()
        setupButton(saveBtn, title: "Save", backgroundColor: .link, textColor: .white)
        setupTextField()
    }
}

//MARK:- Private Methods
extension AddTodoView {
    private func setupBackGround() {
        self.backgroundColor = .clear
    }
    
    private func setupPopUpView() {
        popupView.backgroundColor = .systemBackground
        popupView.layer.cornerRadius = 20
        popupView.layer.masksToBounds = true
    }
    
    private func setupButton(_ button: UIButton, title: String, backgroundColor: UIColor = .clear, textColor: UIColor, fontSize: CGFloat = 20){
        button.backgroundColor = backgroundColor
        button.titleLabel?.font = UIFont(name: "MarkerFelt-Wide", size: fontSize)
        button.layer.cornerRadius = 15
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitle(title, for: .normal)
    }
    
    private func setupCancelBtn() {
        cancelBtn.setTitle("", for: .normal)
        cancelBtn.setImage(UIImage(systemName: "x.circle"), for: .normal)
        cancelBtn.tintColor = .link
    }
    
    private func setupTextField() {
        descriptionTextField.backgroundColor = .white
        descriptionTextField.placeholder = "Description..."
        descriptionTextField.font = UIFont(name: "MarkerFelt-Wide", size: 20)
    }
}
