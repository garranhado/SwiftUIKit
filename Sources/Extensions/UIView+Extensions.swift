import UIKit

extension UIView {
    
    static func loadNibNamed(_ name: String) -> UIView? {
        guard let nib = Bundle.main.loadNibNamed(name, owner: self, options: nil) else {
            return nil
        }

        return nib.first as? UIView
    }
    
    func embed(_ view: UIView) {
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(view)
    }
    
    func embed(_ view: UIView, above: UIView) {
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        insertSubview(view, aboveSubview: above)
    }
    
    func embed(_ view: UIView, below: UIView) {
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        insertSubview(view, belowSubview: below)
    }
    
    static func animate(withDuration duration: TimeInterval, viewsToShow: [UIView], viewsToHide: [UIView], animations: (() -> Void)? = nil, completion: ((Bool) -> Void)? = nil) {
        for v in viewsToShow {
            v.alpha = 0.0
            v.isHidden = false
        }
        
        UIView.animate(withDuration: duration, animations: {
            for v in viewsToShow {
                v.alpha = 1.0
            }
            
            for v in viewsToHide {
                v.alpha = 0.0
            }
            
            animations?()
        }) { finished in
            if finished {
                for v in viewsToHide {
                    v.isHidden = true
                    v.alpha = 1.0
                }
            } else {
                for v in viewsToShow {
                    v.isHidden = true
                    v.alpha = 1.0
                }
            }
            
            completion?(finished)
        }
    }
    
}
