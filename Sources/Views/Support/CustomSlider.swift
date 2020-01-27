import UIKit

class CustomSlider: UIControl {
    
    @IBOutlet weak var thumbView: UIView?
    @IBOutlet weak var fillWidthConstraint: NSLayoutConstraint?
    
    @IBInspectable
    var value: Float {
        set {
            clampValue(newValue)
            updateThumb()
        }
        get {
            return internalValue
        }
    }
    
    @IBInspectable
    var minimumValue: Float = 0.0 {
        didSet {
            clampValue(internalValue)
            updateThumb()
        }
    }
    
    @IBInspectable
    var maximumValue: Float = 1.0 {
        didSet {
            clampValue(internalValue)
            updateThumb()
        }
    }
    
    @IBInspectable
    var isContinuous: Bool = true
    
    @IBInspectable
    var isDiscrete: Bool = false {
        didSet {
            clampValue(internalValue)
            updateThumb()
        }
    }
    
    @IBInspectable
    var touchCanChangeValue: Bool = false
    
    private var internalValue: Float = 0.5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for v in subviews {
            v.isUserInteractionEnabled = false
        }
        
        updateThumb()
    }
    
    func clampValue(_ val: Float) {
        let v = isDiscrete ? val.rounded() : val
        internalValue = max(minimumValue, min(v, maximumValue))
    }
    
    func updateThumb() {
        guard let v = thumbView else { return }
        
        let r = CGFloat((value - minimumValue) / (maximumValue - minimumValue))
        let x: CGFloat = (bounds.width - v.bounds.width) * r
        
        v.transform = CGAffineTransform(translationX: x, y: 0.0)
        fillWidthConstraint?.constant = x
    }
    
    func updateThumb(at location: CGFloat) {
        guard let v = thumbView else { return }
        
        let l = location - (v.bounds.width / 2.0)
        let x: CGFloat = max(0.0, min(l, bounds.width - v.bounds.width))
        v.transform = CGAffineTransform(translationX: x, y: 0.0)
        fillWidthConstraint?.constant = x
        
        let r = Float(x / (bounds.width - v.bounds.width))
        let val = minimumValue + ((maximumValue - minimumValue) * r)
        
        clampValue(val)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let result = super.beginTracking(touch, with: event)
        
        if touchCanChangeValue {
            let location = touch.location(in: self).x
            updateThumb(at: location)
        } else {
            let location = touch.location(in: thumbView)
            return thumbView?.point(inside: location, with: event) ?? false
        }
        
        return result
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let result = super.continueTracking(touch, with: event)
        
        let location = touch.location(in: self).x
        updateThumb(at: location)
        
        if isContinuous {
            sendActions(for: .valueChanged)
        }
        
        return result
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        
        updateThumb()
        
        sendActions(for: .valueChanged)
    }
    
    override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        
        updateThumb()
    }
    
}
