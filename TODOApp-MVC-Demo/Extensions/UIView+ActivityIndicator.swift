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
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.backgroundColor = .clear
        activityIndicator.layer.cornerRadius = 0
//        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = .blue
        activityIndicator.tag = 100
        activityIndicator.translatesAutoresizingMaskIntoConstraints = true
        activityIndicator.center = CGPoint(x: self.frame.size.width  / 2, y: self.frame.size.height / 2)
        return activityIndicator
    }
}
