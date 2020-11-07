
import UIKit

class ProfileVC: UITableViewController {
    //MARK:- Outlets
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var imageViewLabel: UILabel!
    
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.circularImageView()
        navigationItem.title = "Profile"
        getUser()
        getProfilePhoto()
    }
    
    // MARK:- Public Methods
    class func create() -> ProfileVC {
        let profileVC: ProfileVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.profileVC)
        return profileVC
    }
    
    // MARK:- IBActions
    @IBAction func addImageBtnPressed(_ sender: UIBarButtonItem) {
        openAlert(title: "Profile Picture", message: "How would you like to select a picture?", alertStyle: .actionSheet, actionTitles: ["Gallery", "Camera", "Cancel"], actionStyles: [.default, .default, .destructive], actions: [{ [weak self] gallery in
            self?.presentPhotoPicker()
            
            }, { [weak self] camera in
                self?.presentCamera()
                
            }, nil])
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 5 {
            logoutAlert()
        } else if indexPath.row == 0 {
            editProfileAlert()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ProfileVC {
    
    // MARK:- API
    // get user data from api
    private func getUser() {
        self.view.showActivityIndicator()
        APIManager.getUserData { [weak self] (error, userData) in
            if let error = error {
                print(error.localizedDescription)
            } else if let userData = userData {
                let nameInitials = userData.name.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
                self?.imageViewLabel.text = nameInitials
                let ageInt = userData.age
                self?.idLabel.text = userData.id
                self?.nameLabel.text = userData.name
                self?.emailLabel.text = userData.email
                self?.ageLabel.text = String(ageInt)
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            }
            
            DispatchQueue.main.async {
                self?.view.hideActivityIndicator()
            }
        }
    }
    
    // upload photo to api
    private func uploadPhoto(image: UIImage) {
        self.view.showActivityIndicator()
        APIManager.uploadPhoto(with: image) { [weak self] (success) in
            if success {
                print("photo uploaded")
            } else {
                print("failed to upload photo")
            }
            
            DispatchQueue.main.async {
                self?.view.hideActivityIndicator()
                self?.getProfilePhoto()
            }
        }
    }
    // logout user from api
    private func signOut() {
        APIManager.logOut { [weak self] (success) in
            if success {
                UserDefaultsManager.shared().token = nil
                UserDefaultsManager.shared().id = nil
                
                self?.goToSignInVC()
            }
            
            DispatchQueue.main.async {
                self?.view.hideActivityIndicator()
            }
        }
    }
    
    // get user photo from api
    private func getProfilePhoto() {
        self.profileImageView.startAnimating()
        self.profileImageView.showActivityIndicator()
        guard let id = UserDefaultsManager.shared().id else { return }
        APIManager.getProfilePhoto(with: id) { [weak self] (error, data, imageResponse) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                
                DispatchQueue.main.async {
                    self?.imageViewLabel.isHidden = true
                    self?.profileImageView.image = UIImage(data: data)
                }
            } else if let imageResponse = imageResponse {
                self?.imageViewLabel.isHidden = false
            }
            
            DispatchQueue.main.async {
                self?.profileImageView.hideActivityIndicator()
            }
        }
        
    }
    
    // update user email or name or age in api
    private func updateUser(with name: String?, email: String?, age: Int?) {
        self.view.showActivityIndicator()
        APIManager.updateUser(with: name, email: email, age: age) { [weak self] (success, _) in
            if success {
                self?.getUser()
            } else {
                self?.openAlert(title: "Error", message: "This email is already register", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.cancel], actions: nil)
            }
            self?.view.hideActivityIndicator()
        }
    }
    
    // MARK:- Private Methods
    
    // alert with 3 textfields to edit profile info
    private func editProfileAlert() {
        
        let alert = UIAlertController(title: "Edit", message: "Edit your profile information", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        let saveAction = (UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
            let name = alert?.textFields![0].text
            let email = alert?.textFields![1].text
            let ageString = alert?.textFields![2].text
            let age = Int(ageString!)
            self.updateUser(with: name, email: email, age: age)
        }))
        
        saveAction.isEnabled = false
        
        alert.addTextField { (nameTextField) in
            nameTextField.placeholder = "Name..."
        }
        
        alert.addTextField { (emailTextField) in
            emailTextField.placeholder = "Email..."
            emailTextField.keyboardType = .emailAddress
        }
        
        alert.addTextField { (ageTextField) in
            ageTextField.placeholder = "Age..."
            ageTextField.keyboardType = .numberPad
        }
        
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object:alert.textFields?[0], queue: OperationQueue.main) { (notification) -> Void in
            guard let name = alert.textFields?[0].text else { return }
            saveAction.isEnabled = name.isValidName
        }
        
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object:alert.textFields?[1], queue: OperationQueue.main) { (notification) -> Void in
            
            guard let email = alert.textFields?[1].text else { return }
            saveAction.isEnabled = email.isValidEmail
        }
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object:alert.textFields?[2], queue: OperationQueue.main) { (notification) -> Void in
            
            guard let age = alert.textFields?[2].text else { return }
            saveAction.isEnabled = self.isValid(with: .age, age)
        }
        
        alert.addAction(saveAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // logout alert
    private func logoutAlert() {
        openAlert(title: "Sign out?", message: "You can always access your content by signing back in ", alertStyle: .alert, actionTitles: ["Cancel", "Sign out"], actionStyles: [.cancel, .destructive], actions: [nil, { [weak self] signOut in
            self?.view.showActivityIndicator()
            self?.signOut()
            }])
    }
    
    private func goToSignInVC() {
        let signInVC = SignInVC.create()
        let signInNav = UINavigationController(rootViewController: signInVC)
        AppDelegate.shared().window?.rootViewController = signInNav
    }
    
    private func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    private func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
}

// MARK:- Image Picker Data source
extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        uploadPhoto(image: selectedImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
