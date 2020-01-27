import UIKit

struct SecureField: View {
    
    let text: String
    let placeholder: String?
    let placeholderColor: UIColor?
    
    weak var delegate: UITextFieldDelegate?
    
    init(_ text: String, placeholder: String? = nil, placeholderColor: UIColor? = nil, delegate: UITextFieldDelegate? = nil) {
        self.text = text
        
        if let p = placeholder {
            self.placeholder = NSLocalizedString(p, comment: "")
        } else {
            self.placeholder = nil
        }
        self.placeholderColor = placeholderColor
        
        self.delegate = delegate
    }
    
}

extension SecureField {

    var flexibility: (horizontal: ViewFlexibility, vertical: ViewFlexibility) {
        return (.high, .low)
    }
    
    func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
        let uiview: CustomTextField
        let path = uiviewPath(path)
        
        if let v = hosting.reuseUIView(path) {
            uiview = v as! CustomTextField
        } else {
            uiview = CustomTextField()
            hosting.cacheUIView(uiview, path: path)
        }
        
        uiview.borderStyle = .none
        uiview.text = text
        uiview.placeholder = placeholder
        uiview.placeholderColor = placeholderColor
        uiview.isSecureTextEntry = true
        
        uiview.delegate = delegate
        
        return uiview
    }
    
    func measureUIView(_ path: String, proposedSize: CGSize, hosting: HostingView) -> UIView? {
        guard let uiview = hosting.queryUIView(uiviewPath(path)) else { return nil }
        
        uiview.transform = .identity
        uiview.frame.origin = .zero
        
        uiview.frame.size = uiview.sizeThatFits(proposedSize)
        uiview.frame.size.width = proposedSize.width
        
        return uiview
    }

}
