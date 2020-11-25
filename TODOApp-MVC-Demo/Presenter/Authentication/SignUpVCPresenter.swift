
import Foundation

class SignUpVCPresenter {
    
    //MARK:- Properties
    private weak var view: SignUpVC?
    
    // MARK:- Life Cycle Methods
    init(view: SignUpVC) {
        self.view = view
    }
    
    //MARK:- Public Methods
      func goToMainScreen(with user: User?) {
          if validateUser(with: user) {
              register(with: user!)
          }
      }
}

extension SignUpVCPresenter {
    //MARK:- Private Methods
    private func register(with user: User) {
        self.view?.showIndicator()
        
        APIManager.register(with: user) { [weak self] (response) in
            guard let self = self else { return }
            switch response {
                
            case .success(let signupData):
                UserDefaultsManager.shared().token = signupData.token
                UserDefaultsManager.shared().id = signupData.user.id
                self.view?.goToMainVC()
            case .failure(let error):
                print(error.localizedDescription)
                self.view?.openAlert(title: "Error!", message: "This email is already register")
            }
            
            DispatchQueue.main.async {
                self.view?.hideIndicator()
            }
        }
    }
    
    private func validateUser(with user: User?) -> Bool {
        
        if !ValidatorManager.shared().isValid(with: user?.name, validationType: .name) {
            view?.openAlert(title: ValidationType.name.error.title, message: ValidationType.name.error.message)
            return false
        }
        
        if !ValidatorManager.shared().isValid(with: user?.email, validationType: .email) {
            view?.openAlert(title: ValidationType.email.error.title, message: ValidationType.email.error.message)
            return false
        }
        
        if !ValidatorManager.shared().isValid(with: user?.password, validationType: .password) {
            view?.openAlert(title: ValidationType.password.error.title, message: ValidationType.password.error.message)
            return false
        }
        
        if !ValidatorManager.shared().isValid(with: "\(user?.age ?? 0)", validationType: .age) {
            view?.openAlert(title: ValidationType.age.error.title, message: ValidationType.age.error.message)
            return false
        }
        return true
    }
}
