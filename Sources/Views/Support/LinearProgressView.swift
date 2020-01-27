import UIKit

class LinearProgressView: UIView {
    
    @IBInspectable
    var trackColor: UIColor = .lightGray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var progressInset: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var progressColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var progress: Float = 0.5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var isSharp: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        let radius = rect.height / 2.0
        
        // track
        
        trackColor.setFill()
        
        let trackPath = isSharp ? UIBezierPath(rect: rect) : UIBezierPath(roundedRect: rect, cornerRadius: radius)
        trackPath.fill()
        
        // progress
        
        if progress > 0.0 {
            progressColor.setFill()
            
            let diff2 = progressInset
            let diff = diff2 / 2.0
            let rc = CGRect(x: diff, y: diff, width: (rect.width * CGFloat(progress)) - diff2, height: rect.height - diff2)
            
            let progressPath = isSharp ? UIBezierPath(rect: rc) : UIBezierPath(roundedRect: rc, cornerRadius: radius)
            progressPath.fill()
        }
    }
    
}
