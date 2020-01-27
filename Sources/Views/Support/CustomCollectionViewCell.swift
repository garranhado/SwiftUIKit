import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    static func cell(withIdentifier: String, for indexPath: IndexPath, collectionView: UICollectionView, data: Any) -> CustomCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:withIdentifier, for: indexPath) as! CustomCollectionViewCell
        cell.prepareForData(data)
        return cell
    }
    
    @IBInspectable
    var selectedBackgroundColor: UIColor? = nil
    
    @IBInspectable
    var selectedAlpha: CGFloat = 1.0
    
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
    
    @IBOutlet weak var selectedView: UIView? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let view = UIView()
        view.backgroundColor = backgroundColor
        backgroundView = view
        
        if let color = selectedBackgroundColor {
            let view = UIView()
            view.backgroundColor = color
            selectedBackgroundView = view
        } else {
            selectedBackgroundView = nil
        }
        
        if let view = selectedView {
            view.isHidden = true
        }
        
        backgroundColor = .clear
    }
    
    override var isHighlighted: Bool {
        didSet {
            if let view = selectedView {
                view.isHidden = !(isSelected || isHighlighted)
            }
            
            alpha = (isSelected || isHighlighted) ? selectedAlpha : 1.0
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if let view = selectedView {
                view.isHidden = !isSelected
            }
            
            alpha = isSelected ? selectedAlpha : 1.0
        }
    }
    
    func prepareForData(_ data: Any) { }
    
}
