import UIKit

class RoundedView: UIView {
    
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
    var cornerRadiusMode: Int = 0 {
        didSet {
            switch cornerRadiusMode {
            case 1:
                layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            case 2:
                layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            default:
                layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            }
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
    var rasterize: Bool {
        set {
            layer.shouldRasterize = newValue
            layer.rasterizationScale = UIScreen.main.scale
        }
        get {
            return layer.shouldRasterize
        }
    }
    
}
