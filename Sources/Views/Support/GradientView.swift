import UIKit

class GradientView: UIView {

    @IBInspectable
    var startColor: UIColor = .white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var endColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    var mode: Int = 0 {
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
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let colors = [startColor.cgColor, endColor.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]

        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations) else { return }
        
        let startPoint = CGPoint.zero
        var endPoint = CGPoint.zero
        
        switch mode {
        case 1:
            endPoint = CGPoint(x: 0.0, y: rect.height)
        case 2:
            endPoint = CGPoint(x: rect.width, y: 0.0)
        default:
            endPoint = CGPoint(x: rect.width, y: rect.height)
        }
        
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
    }
    
}
