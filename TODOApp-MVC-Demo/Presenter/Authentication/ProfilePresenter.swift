//
//  ProfilePresenter.swift
//  TODOApp-MVC-Demo
//
//  Created by Ahmed Ezzat on 24/11/2020.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation

class ProfilePresenter {
    
    //MARK:- Properties
    private weak var view: ProfileVC?
    
    // MARK:- Life Cycle Methods
    init(view: ProfileVC) {
        self.view = view
    }
    
    // MARK:- Public Methods
    func viewDidLoad() {
        getUser()
        getProfilePhoto()
    }
    
    // upload photo to api
    func uploadPhoto(imageData: Data) {
        self.view?.showIndicator()
        APIManager.uploadPhoto(with: imageData) { [weak self] (success) in
            if success {
                print("photo uploaded")
            } else {
                print("failed to upload photo")
            }
            
            DispatchQueue.main.async {
                self?.view?.hideIndicator()
                self?.getProfilePhoto()
            }
        }
    }
    
    // update user email or name or age in api
    func updateUser(with user: User?) {
        self.view?.showIndicator()
        APIManager.updateUser(with: user) { [weak self] (success) in
            if success {
                self?.getUser()
            } else {
                self?.view?.showAlert(title: "Error", message: "This email is already register", actionTitles: ["OK"], actionStyles: [.cancel], actions: nil)
            }
            self?.view?.hideIndicator()
        }
    }
    
    func nameInitials(with name: String) -> String {
        let nameInitials = name.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!).") + "\($1.first!)" }
        return nameInitials
    }
    
    
    func didSelectRow(section: Int, row: Int) {
        switch (section, row) {
        case (0, 0):
            self.view?.editProfileAlert()
        case (1, 4):
            logOutAlert()
        case (_, _):
            break
        }
    }
}

//MARK:- Private Methods
extension ProfilePresenter {
    // logout alert
    private func logOutAlert() {
        self.view?.showAlert(title: "Sign out?", message: "You can always access your content by signing back in ", actionTitles: ["Cancel", "Sign Out"], actionStyles: [.cancel, .destructive], actions: [nil, { [weak self] _ in
            self?.signOut()
            }])
    }
    
    // get user photo from api
    private func getProfilePhoto() {
        self.view?.profileImgView().showActivityIndicator()
        guard let id = UserDefaultsManager.shared().id else { return }
        APIManager.getProfilePhoto(with: id) { [weak self] (response) in
            switch response {
            case .success(let imageData):
                DispatchQueue.main.async {
                    self?.view?.imageViewLabel(true)
                    self?.view?.setProfileImage(imageData: imageData)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                if self?.view?.profileImgView().image == nil {
                    self?.view?.imageViewLabel(false)
                }
                self?.view?.profileImgView().hideActivityIndicator()
            }
        }
    }
    
    // logout user from api
    private func signOut() {
        self.view?.showIndicator()
        APIManager.logOut { [weak self] (success) in
            if success {
                UserDefaultsManager.shared().token = nil
                UserDefaultsManager.shared().id = nil
                self?.view?.goToSignInVC()
            }
            DispatchQueue.main.async {
                self?.view?.hideIndicator()
            }
        }
    }
    
    // get user data from api
    private func getUser() {
        self.view?.showIndicator()
        APIManager.getUserData { [weak self] (response) in
            switch response {
            case .success(let userData):
                self?.view?.showUserInfo(with: userData)
                
                DispatchQueue.main.async {
                    self?.view?.reloadTableView()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                self?.view?.hideIndicator()
            }
        }
    }
    
}
