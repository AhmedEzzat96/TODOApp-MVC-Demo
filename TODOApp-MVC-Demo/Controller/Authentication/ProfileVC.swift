//
//  ProfileVC.swift
//  TODOApp-MVC-Demo
//
//  Created by Ahmed Ezzat on 10/31/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class ProfileVC: UITableViewController {
    //MARK:- Outlets
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Profile"
        getUser()
    }
    
    // MARK:- Public Methods
    class func create() -> ProfileVC {
        let profileVC: ProfileVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.profileVC)
        return profileVC
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            openAlert(title: "Sign out?", message: "You can always access your content by signing back in ", alertStyle: .alert, actionTitles: ["Cancel", "Sign out"], actionStyles: [.cancel, .destructive], actions: [nil, { [weak self] signOut in
                self?.showActivityIndicator()
                self?.signOut()
                }])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

}

extension ProfileVC {
    // MARK:- API
    private func getUser() {
        APIManager.getUserData { [weak self] (error, userData) in
            if let error = error {
                print(error.localizedDescription)
            } else if let userData = userData {
                let ageInt = userData.age
                self?.idLabel.text = userData.id
                self?.nameLabel.text = userData.name
                self?.emailLabel.text = userData.email
                self?.ageLabel.text = String(ageInt)
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            }
        }
    }
    
    // MARK:- Private Methods
    private func signOut() {
        APIManager.logOut { [weak self] (success) in
            if success {
                UserDefaultsManager.shared().token = nil
                
                DispatchQueue.main.async {
                    self?.hideActivityIndicator()
                }
                self?.goToSignInVC()
            }
        }
    }
    
    private func goToSignInVC() {
        let signInVC = SignInVC.create()
        let signInNav = UINavigationController(rootViewController: signInVC)
        AppDelegate.shared().window?.rootViewController = signInNav
    }
}
