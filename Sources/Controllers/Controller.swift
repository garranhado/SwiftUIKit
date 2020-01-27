import UIKit

class Controller: UIViewController {
    
    typealias onChange = (_ controller: Controller) -> Void
    typealias onDismiss = (_ controller: Controller) -> Void

    private var changeHandler: onChange? = nil
    private var dismissHandler: onDismiss? = nil
        
    private let timers: NSMapTable<AnyObject, Timer> = NSMapTable.strongToWeakObjects()
    
    private(set) var viewFrame: CGRect = .zero
    
    #if os(iOS)
    private(set) var isKeyboardVisible: Bool = false
    private(set) var keyboardFrame: CGRect = .zero
    #endif
    
    private weak var pullDownToDismissReferenceView: UIView? = nil
    
    let imageCache: NSCache<AnyObject, UIImage> = NSCache()
    
    deinit {
        changeHandler = nil
        dismissHandler = nil
        timers.removeAllObjects()
        imageCache.removeAllObjects()
    }
    
    // MARK: - Subclass lifecycle -

    func onViewLoad() { }
    func onViewFrameChange() { }
    
    func onViewAppear() { }
    func onViewDisappear() { }

    func onKeyboardAppear() { }
    func onKeyboardDisappear() { }
    
    func onSegue(_ destination: UIViewController, sender: Any? = nil) { }
        
}

// MARK: - Loading -

extension Controller {
    
    func load(_ identifier: String) -> Controller? {
        return storyboard?.instantiateViewController(withIdentifier: identifier) as? Controller
    }
    
    func load(name: String, identifier: String? = nil) -> Controller? {
        let sb = UIStoryboard(name: name, bundle: nil)
        
        if let id = identifier {
            return sb.instantiateViewController(withIdentifier: id) as? Controller
        } else {
            return sb.instantiateInitialViewController() as? Controller
        }
    }
    
}

// MARK: - Notifications -

extension Controller {

    func observe(object: ObservableObject, selector: Selector) {
        object.subscribe(self, selector: selector)
    }
    
    func observe(notification: Notification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    #if os(iOS)
    func observeKeyboard() {
        observe(notification: UIResponder.keyboardWillShowNotification, selector: #selector(keyboardWillShow))
        observe(notification: UIResponder.keyboardWillHideNotification, selector: #selector(keyboardWillHide))
    }
    #endif
    
}

// MARK: - Timers -

extension Controller {

    func timer(_ key: String, seconds: TimeInterval, selector: Selector) {
        cancelTimer(key)
        
        let timer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: selector, userInfo: nil, repeats: false)
        
        timers.setObject(timer, forKey: key as AnyObject)
    }
    
    func cancelTimer(_ key: String) {
        if let timer = timers.object(forKey: key as AnyObject) {
            timer.invalidate()
        }
    }
    
}

// MARK: - Containment -

extension Controller {
    
    func replace(by controller: Controller) {
        guard let parent = self.parent else { return }
        guard let container = self.view.superview else { return }
        
        willMove(toParent: nil)
        self.view.removeFromSuperview()
        removeFromParent()
        
        parent.addChild(controller)

        controller.view.frame = container.bounds
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.view.translatesAutoresizingMaskIntoConstraints = true
        
        container.addSubview(controller.view)
        
        controller.didMove(toParent: parent)
    }

}
    
// MARK: - Presentation -

extension Controller {
    
    func push(controller: Controller) {
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func present(controller: Controller, onChange: onChange? = nil, onDismiss: onDismiss? = nil) {
        controller.changeHandler = onChange
        controller.dismissHandler = onDismiss
        present(controller, animated: true)
    }
    
    func dismiss() {
        dismiss(animated: true) {
            self.changeHandler = nil
            
            self.dismissHandler?(self)
            self.dismissHandler = nil
        }
    }
    
    func didChange() {
        self.changeHandler?(self)
    }
    
}

// MARK: - Keyboard management -

#if os(iOS)
extension Controller {
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardframe = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        isKeyboardVisible = true
        self.keyboardFrame = keyboardframe
        
        onKeyboardAppear()
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        isKeyboardVisible = false
        self.keyboardFrame = .zero
        
        onKeyboardDisappear()
    }
    
}
#endif

// MARK: - PullDown to dismiss -

extension Controller {

    func enablePullDownToDismiss(in view: UIView, referenceView: UIView) {
        referenceView.isHidden = true
        pullDownToDismissReferenceView = referenceView
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(pullDownToDismiss))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func pullDownToDismiss(_ sender: UIPanGestureRecognizer) {
        let refView = pullDownToDismissReferenceView ?? self.view!
        
        let h = refView.frame.height
        
        let translation = sender.translation(in: sender.view)
        let y = max(0.0, min(translation.y, h))
        
        // For dynamic animation duration based on progress
        let f = (h - y) / h
        
        switch sender.state {
        case .began, .changed:
            refView.transform = CGAffineTransform(translationX: 0.0, y: y)
        case .ended:
            let velocity = sender.velocity(in: sender.view)
            let vy = velocity.y
            
            if vy > 0.0 {
                hide(TimeInterval(0.1 + f * 0.2))
            } else {
                UIView.animate(withDuration: TimeInterval(0.1 + (1.0 - f) * 0.2), animations: {
                    refView.transform = .identity
                })
            }
        default:
            UIView.animate(withDuration: TimeInterval(0.1 + (1.0 - f) * 0.2), animations: {
                refView.transform = .identity
            })
        }
    }
    
    private func show(_ duration: TimeInterval = 0.3) {
        let refView = pullDownToDismissReferenceView ?? self.view!
        
        refView.transform = CGAffineTransform(translationX: 0.0, y: refView.frame.height)
        refView.isHidden = false

        UIView.animate(withDuration: duration) {
            refView.transform = .identity
        }
    }
    
    private func hide(_ duration: TimeInterval = 0.3) {
        let refView = pullDownToDismissReferenceView ?? self.view!
        
        UIView.animate(withDuration: duration, animations: {
            refView.transform = CGAffineTransform(translationX: 0.0, y: refView.frame.height)
        }) { _ in
            refView.isHidden = true
            refView.transform = .identity
            
            self.pullDownToDismissReferenceView = nil
            
            self.dismiss()
        }
    }
    
}

// MARK: - Workflow -

extension Controller {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewFrame = view.frame
        
        onViewLoad()
        onViewFrameChange()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if pullDownToDismissReferenceView != nil {
            show()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        onViewAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if pullDownToDismissReferenceView != nil {
            hide()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
                
        if let enumerator = timers.objectEnumerator() {
            for t in enumerator.allObjects {
                (t as? Timer)?.invalidate()
            }
        }
        
        onViewDisappear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if viewFrame.size != view.frame.size {
            viewFrame = view.frame
            onViewFrameChange()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        onSegue(segue.destination, sender: sender)
    }
    
}
