import UIKit

class CustomTableViewCell: UITableViewCell {
    
    static func cell(withIdentifier: String, for indexPath: IndexPath, tableView: UITableView, data: Any) -> CustomTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:withIdentifier, for: indexPath) as! CustomTableViewCell
        cell.prepareForData(data)
        return cell
    }
    
    @IBInspectable
    var selectedBackgroundColor: UIColor? = nil
    
    @IBInspectable
    var multipleSelectionBackgroundColor: UIColor? = nil
    
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
        
        if let color = multipleSelectionBackgroundColor {
            let view = UIView()
            view.backgroundColor = color
            multipleSelectionBackgroundView = view
        } else {
            multipleSelectionBackgroundView = nil
        }
        
        backgroundColor = .clear
    }
    
    func prepareForData(_ data: Any) { }

}
