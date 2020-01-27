import UIKit

extension UIScrollView {
    
    func centerContentHorizontally(defaultLeft: CGFloat) {
        contentInset.left = bounds.size.width > contentSize.width ? floor((bounds.size.width - contentSize.width) / 2.0) : defaultLeft
    }
    
    func centerContentVertically(defaultTop: CGFloat) {
        contentInset.top = bounds.size.height > contentSize.height ? floor((bounds.size.height - contentSize.height) / 2.0) : defaultTop
    }
    
}
