import UIKit

// MARK: - Resources

extension UIImageView {
    
    func setImage(_ image: UIImage, transition: Bool) {
        guard transition else {
            self.image = image
            
            return
        }
        
        UIView.transition(with: self, duration: 0.3, options: [.transitionCrossDissolve], animations: {
            self.image = image
        })
    }
    
    func setActivityIndicator(visible: Bool) {
        if visible {
            let activityView = UIActivityIndicatorView(style: .white)
            activityView.tag = 1
            activityView.center = center
            addSubview(activityView)
            activityView.startAnimating()
        } else {
            viewWithTag(1)?.removeFromSuperview()
        }
    }
    
}
