
import UIKit

class ProfileVC: UITableViewController {
    //MARK:- Outlets
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var imageViewLabel: UILabel!
    
    //MARK:- Properties
    var presenter: ProfilePresenter!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.circularImageView()
        navigationItem.title = "Profile"
        presenter.viewDidLoad()
    }
    
    // MARK:- Public Methods
    class func create() -> ProfileVC {
        let profileVC: ProfileVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.profileVC)
        profileVC.presenter = ProfilePresenter(view: profileVC)
        return profileVC
    }
    
    // show user Info
    func showUserInfo(with userData: UserData) {
        self.imageViewLabel.text = presenter.nameInitials(with: userData.name)
        let ageInt = userData.age
        self.idLabel.text = userData.id
        self.nameLabel.text = userData.name
        self.emailLabel.text = userData.email
        self.ageLabel.text = String(ageInt)
    }
    
    func showIndicator() {
        view.showActivityIndicator()
    }
    
    func hideIndicator() {
        view.hideActivityIndicator()
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    func profileImgView() -> UIImageView {
        return profileImageView
    }
    
    func imageViewLabel(_ isHidden: Bool) {
        imageViewLabel.isHidden = isHidden
    }
    
    func setProfileImage(imageData: Data) {
        self.profileImageView.image = UIImage(data: imageData)
    }
    
    func goToSignInVC() {
        let signInVC = SignInVC.create()
        let signInNav = UINavigationController(rootViewController: signInVC)
        AppDelegate.shared().window?.rootViewController = signInNav
    }
    
    func showAlert(title: String, message: String, actionTitles: [String], actionStyles: [UIAlertAction.Style], actions: [((UIAlertAction) -> Void)?]?) {
        openAlert(title: title, message: message, alertStyle: .alert, actionTitles: actionTitles, actionStyles: actionStyles, actions: actions)
    }
    
    // alert with 3 textfields to edit profile info
    func editProfileAlert() {
        let alert = UIAlertController(title: "Edit", message: "Edit your profile information", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        let saveAction = (UIAlertAction(title: "Save", style: .default, handler: { [weak self] (_) in
            guard let self = self else { return }
            let name = alert.textFields![0].text
            let email = alert.textFields![1].text
            let ageString = alert.textFields![2].text
            let age = Int(ageString!)

            let user = User(name: name, email: email, age: age)
            self.presenter.updateUser(with: user)
    
        }))

        saveAction.isEnabled = false
        alert.addAction(saveAction)

        alert.addTextField { [weak self] (nameTextField) in
            nameTextField.text = self?.nameLabel.text
            nameTextField.placeholder = "Name..."

            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: nameTextField, queue: OperationQueue.main) { (notification) -> Void in

                guard let name = nameTextField.text else { return }
                saveAction.isEnabled = name.isValidEmail
            }
        }

        alert.addTextField { [weak self] (emailTextField) in
            emailTextField.text = self?.emailLabel.text
            emailTextField.placeholder = "Email..."
            emailTextField.keyboardType = .emailAddress

            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: emailTextField, queue: OperationQueue.main) { (notification) -> Void in

                guard let email = emailTextField.text else { return }
                saveAction.isEnabled = email.isValidEmail
            }
        }

        alert.addTextField { [weak self] (ageTextField) in
            ageTextField.text = self?.ageLabel.text
            ageTextField.placeholder = "Age..."
            ageTextField.keyboardType = .numberPad

            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: ageTextField, queue: OperationQueue.main) { (notification) -> Void in

            guard let age = ageTextField.text, let ageInt = Int(age) else { return }
                saveAction.isEnabled = !age.isEmpty && ageInt > 0
            }
        }

        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK:- IBActions
    @IBAction func addImageBtnPressed(_ sender: UIBarButtonItem) {
        self.openAlert(title: "Profile Picture", message: "How would you like to select a picture?", alertStyle: .actionSheet, actionTitles: ["Gallery", "Camera", "Cancel"], actionStyles: [.default, .default, .destructive], actions: [{ [weak self] gallery in
            self?.presentPhotoPicker()
            
            }, { [weak self] camera in
                self?.presentCamera()
                
            }, nil])
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(section: indexPath.section, row: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ProfileVC {
    
    // MARK:- Private Methods
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
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage, let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
            return
        }
        presenter.uploadPhoto(imageData: imageData)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
