import UIKit

class CustomTextField: UITextField {
    
    @IBInspectable
    var padding: CGSize = .zero
    
    @IBInspectable
    var placeholderColor: UIColor?
 
    @IBInspectable
    var localize: Bool = false
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        updatePlaceholder()
    }
    
    func updatePlaceholder() {
        if let p = placeholder {
            let t = localize ? NSLocalizedString(p, comment: "") : p
            
            var att: [NSAttributedString.Key : Any] = [:]
            
            if let f = font {
                att[.font] = f
            }
            
            if let pc = placeholderColor {
                att[.foregroundColor] = pc
            }
            
            attributedPlaceholder = NSAttributedString(string: t, attributes: att)
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let inset = UIEdgeInsets(top: padding.height, left: padding.width, bottom: padding.height, right: padding.width)
        return super.textRect(forBounds: bounds.inset(by: inset))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let inset = UIEdgeInsets(top: padding.height, left: padding.width, bottom: padding.height, right: padding.width)
        return super.editingRect(forBounds: bounds.inset(by: inset))
    }
    
}
