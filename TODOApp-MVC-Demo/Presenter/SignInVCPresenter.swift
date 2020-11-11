
import Foundation

protocol SignInView: class {
    func showIndicator()
    func hideIndicator()
    func openAlert()
    func showError(error: String)
    func goToMainVC()
}

class SignInVCPresenter {
    private weak var view: SignInView?
    
    init(view: SignInView) {
        self.view = view
    }
    
    
    func signIn(with user: User) {
        view?.showIndicator()
        APIManager.login(with: user) { [weak self] (response) in
            guard let self = self else { return }
            switch response {
            case .success(let loginData):
                UserDefaultsManager.shared().token = loginData.token
                UserDefaultsManager.shared().id = loginData.user.id
                self.view?.goToMainVC()
            case .failure(let error):
                self.view?.showError(error: error.localizedDescription)
                self.view?.openAlert()
            }
            
            DispatchQueue.main.async {
                self.view?.hideIndicator()
            }
        }
    }
}
