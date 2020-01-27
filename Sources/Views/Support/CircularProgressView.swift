import UIKit

class CircularProgressView: UIView {
    
    @IBInspectable
    var offsetAngle: Double = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var trackLineWidth: CGFloat = 8.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
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
        let center = CGPoint(x: rect.width / 2.0, y: rect.height / 2.0)
        let radius = min(center.x, center.y)
        let diff = trackLineWidth / 2.0
        
        // track
        
        trackColor.setStroke()
        
        let trackPath = UIBezierPath(arcCenter: center, radius: radius - diff, startAngle: 0.0, endAngle: .pi * 2.0, clockwise: true)
        trackPath.lineWidth = trackLineWidth
        trackPath.stroke()
        
        // progress
        
        if progress > 0.0 {
            progressColor.setStroke()
            
            let startAngle = deg2rad(offsetAngle) - (.pi / 2.0)
            let endAngle = startAngle + ((.pi * 2.0) * Double(progress))
            
            let progressPath = UIBezierPath(arcCenter: center, radius: radius - diff, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
            progressPath.lineWidth = trackLineWidth - progressInset
            progressPath.lineCapStyle = isSharp ? .butt : .round
            progressPath.stroke()
        }
    }
    
    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180.0
    }
    
}
