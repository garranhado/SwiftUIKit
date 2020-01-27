import UIKit

class HostingView: UIView {
    
    var ignoreSafeAreaInsets: Bool = false
    
    let uiviewCache: NSMapTable<AnyObject, UIView> = NSMapTable.strongToWeakObjects()
    let imageCache: NSCache = NSCache<AnyObject, UIImage>()
    
    private var rootView: View? = nil

    func render(_ view: View?, reload: Bool = false) {
        autoresizesSubviews = false
        subviews.forEach { $0.removeFromSuperview() }

        if reload {
            rootView = nil
            
            uiviewCache.removeAllObjects()
            imageCache.removeAllObjects()
        }
        
        guard let v = view else { return }
        
        rootView = v
        
        if let uiview = v.makeUIView("", hosting: self) {
            addSubview(uiview)
        }
        
        layout()
    }
    
    func animatedRender(_ view: View, animation: ViewAnimation = .easeOut(), completion: (() -> Void)? = nil) {
        switch animation {
        case .linear(let duration):
            UIView.animate(withDuration: duration,
                           delay: 0.0,
                           options: .curveLinear,
                           animations: { self.render(view) }) { _ in
                            completion?()
            }
        case .easeIn(let duration):
            UIView.animate(withDuration: duration,
                           delay: 0.0,
                           options: .curveEaseIn,
                           animations: { self.render(view) }) { _ in
                            completion?()
            }
        case .easeInOut(let duration):
            UIView.animate(withDuration: duration,
                           delay: 0.0,
                           options: .curveEaseInOut,
                           animations: { self.render(view) }) { _ in
                            completion?()
            }
        case .easeOut(let duration):
            UIView.animate(withDuration: duration,
                           delay: 0.0,
                           options: .curveEaseOut,
                           animations: { self.render(view) }) { _ in
                            completion?()
            }
        case .spring(let duration, let damping, let initialVelocity):
            UIView.animate(withDuration: duration,
                           delay: 0.0,
                           usingSpringWithDamping: damping,
                           initialSpringVelocity: initialVelocity,
                           options: [],
                           animations: { self.render(view) }) { _ in
                            completion?()
            }
        default:
            render(view)
        }
    }
    
    func layout() {
        guard let view = rootView else { return }
        
        let size = ignoreSafeAreaInsets ? frame.size : CGSize(width: max(0.0, frame.size.width - (safeAreaInsets.left + safeAreaInsets.right)),
                                                              height: max(0.0, frame.size.height - (safeAreaInsets.top + safeAreaInsets.bottom)))
        
        if let uiview = view.measureUIView("", proposedSize: size, hosting: self) {
            uiview.frame.origin.x += (ignoreSafeAreaInsets ? 0.0 : safeAreaInsets.left) + (size.width - uiview.frame.width) / 2.0
            uiview.frame.origin.y += (ignoreSafeAreaInsets ? 0.0 : safeAreaInsets.top) + (size.height - uiview.frame.height) / 2.0
        }
        
        _ = view.transformUIView("", hosting: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }
    
    override var intrinsicContentSize: CGSize {
        return subviews.first?.frame.size ?? super.intrinsicContentSize
    }
    
}

extension HostingView {
    
    func queryUIView(_ path: String) -> UIView? {
        return uiviewCache.object(forKey: path as AnyObject)
    }
    
    func reuseUIView(_ path: String) -> UIView? {
        guard let uiview = queryUIView(path) else { return nil }
        
        uiview.alpha = 1.0
        uiview.backgroundColor = .clear
        uiview.tintColor = nil
        
        uiview.layer.zPosition = 0.0
        
        uiview.layer.cornerRadius = 0.0
        
        uiview.layer.borderWidth = 0.0
        uiview.layer.shadowOpacity = 0.0
        
        uiview.tag = 0
        uiview.isHidden = false
        uiview.clipsToBounds = false
        
        if let control = uiview as? UIControl {
            control.isEnabled = true
            control.removeTarget(nil, action: nil, for: .allEvents)
        } else {
            uiview.isUserInteractionEnabled = true
        }
        
        uiview.layer.shouldRasterize = false
                
        while let gr = uiview.gestureRecognizers?.first {
            uiview.removeGestureRecognizer(gr)
        }
        
        return uiview
    }
    
    func cacheUIView(_ uiview: UIView, path: String) {
        uiviewCache.setObject(uiview, forKey: path as AnyObject)
    }

}

enum ViewAnimation {
    
    case none
    case linear(duration: Double = 0.3)
    case easeIn(duration: Double = 0.3)
    case easeInOut(duration: Double = 0.3)
    case easeOut(duration: Double = 0.3)
    case spring(duration: Double = 0.3, damping: CGFloat = 0.825, initialVelocity: CGFloat = 0.55)

}
