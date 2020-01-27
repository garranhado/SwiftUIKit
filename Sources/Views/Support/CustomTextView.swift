import UIKit

class CustomTextView: UITextView {
    
    @IBInspectable
    var padding: CGSize = .zero
    
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
        
        textContainerInset = UIEdgeInsets(top: padding.height, left: padding.width, bottom: padding.height, right: padding.width)
        textContainer.lineFragmentPadding = 0.0
    }
}
