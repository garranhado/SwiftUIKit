import UIKit

class EllipseView: UIView {
        
    @IBInspectable
    var fillColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var strokeColor: UIColor = .clear {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var lineWidth: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var rasterize: Bool {
        set {
            layer.shouldRasterize = newValue
            layer.rasterizationScale = UIScreen.main.scale
        }
        get {
            return layer.shouldRasterize
        }
    }

    override func draw(_ rect: CGRect) {
        let i = lineWidth / 2.0
        let r = rect.insetBy(dx: i, dy: i)
        
        let path = UIBezierPath(ovalIn: r)
        
        if fillColor != .clear {
            fillColor.setFill()
            path.fill()
        }
        
        if lineWidth > 0.0 {
            strokeColor.setStroke()
            path.lineWidth = lineWidth
            path.stroke()
        }
    }
    
}

