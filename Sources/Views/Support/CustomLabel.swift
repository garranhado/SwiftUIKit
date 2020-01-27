import UIKit

class CustomLabel: UILabel {
    
    @IBInspectable
    var localize: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if localize {
            localizeText()
        }
    }
    
    func localizeText() {
        if let t = text {
            text = NSLocalizedString(t, comment: "")
        }
    }
    
    func localizeText(_ arguments: Any...) {
        if let t = text {
            text = String(format: NSLocalizedString(t, comment: ""), arguments)
        }
    }
    
}
