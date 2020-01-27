import UIKit

class ShapeView: UIView {
    
    var path: UIBezierPath = UIBezierPath() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var fill: UIColor = .white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var stroke: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        fill.setFill()
        path.fill()

        if path.lineWidth > 0.0 {
            stroke.setStroke()
            path.stroke()
        }
    }
    
}
