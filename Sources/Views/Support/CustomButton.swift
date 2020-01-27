import UIKit

class CustomButton: UIControl {
    
    @IBInspectable
    var pressedBackgroundColor: UIColor?
    
    @IBInspectable
    var pressedAlpha: CGFloat = 1.0
    
    @IBInspectable
    var disabledBackgroundColor: UIColor?
    
    @IBInspectable
    var disabledAlpha: CGFloat = 1.0
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
    }
    
    @IBInspectable
    var pressedBorderColor: UIColor?
    
    @IBInspectable
    var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue!.cgColor
        }
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
    }

    @IBInspectable
    var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }

    @IBInspectable
    var shadowOffset: CGPoint {
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }
        get {
            return CGPoint(x: layer.shadowOffset.width, y:layer.shadowOffset.height)
        }
    }

    @IBInspectable
    var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
    
    @IBInspectable
    var ignorePressedWhenSelected: Bool = false
    
    @IBInspectable
    var backgroundImageHitTest: Bool = false
    
    @IBOutlet weak var backgroundImage: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var subtitleLabel: UILabel?
    @IBOutlet weak var iconView: UIImageView?
    @IBOutlet weak var activityView: UIActivityIndicatorView?
    @IBOutlet weak var selectedView: UIView?
    
    var savedBackgroundColor: UIColor?
    var savedBorderColor: UIColor?
    var savedShadowOpacity: Float?
    
    override var isHighlighted: Bool {
        didSet {
            updateState()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateState()
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            updateState()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for v in subviews {
            v.isUserInteractionEnabled = false
        }
    }
    
    func updateState() {
        if savedBackgroundColor == nil {
            savedBackgroundColor = backgroundColor
        }
        
        if savedBorderColor == nil {
            savedBorderColor = borderColor
        }
        
        if savedShadowOpacity == nil {
            savedShadowOpacity = shadowOpacity
        }
        
        let selected = isHighlighted || (!ignorePressedWhenSelected && isSelected)
        
        if !isEnabled {
            if let c = disabledBackgroundColor {
                backgroundColor = c
            }
            
            borderColor = savedBorderColor
            alpha = disabledAlpha
            shadowOpacity = 0.0
        } else if selected {
            if let c = pressedBackgroundColor {
                backgroundColor = c
            }
            
            if let c = pressedBorderColor {
                borderColor = c
            }
            
            alpha = pressedAlpha
            
            if let o = savedShadowOpacity {
                shadowOpacity = o
            }
        } else {
            backgroundColor = savedBackgroundColor
            borderColor = savedBorderColor
            alpha = 1.0

            if let o = savedShadowOpacity {
                shadowOpacity = o
            }
        }
        
        backgroundImage?.isHighlighted = selected
        titleLabel?.isHighlighted = selected
        subtitleLabel?.isHighlighted = selected
        iconView?.isHighlighted = isEnabled && (isHighlighted || isSelected)
        selectedView?.isHidden = !(isEnabled && isSelected)
    }
    
}

extension CustomButton {
    
    func alphaFromPoint(point: CGPoint) -> CGFloat {
        var pixel: [UInt8] = [0, 0, 0, 0]
        let colorSpace     = CGColorSpaceCreateDeviceRGB();
        let alphaInfo      = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context        = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: alphaInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y);
        
        backgroundImage?.layer.render(in: context!)
        
        let floatAlpha = CGFloat(pixel[3])
        
        return floatAlpha
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard backgroundImageHitTest else {
            return super.point(inside: point, with: event)
        }
        
        return self.alphaFromPoint(point: point) > 0.5
    }
    
}
