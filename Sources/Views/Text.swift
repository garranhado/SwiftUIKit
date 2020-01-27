import UIKit

struct Text: View {
    
    let text: String
    
    init(_ text: String) {
        self.text = NSLocalizedString(text, comment: "")
    }

}

extension Text {
    
    var flexibility: (horizontal: ViewFlexibility, vertical: ViewFlexibility) {
        return (.high, .high)
    }
    
    func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
        let uiview: UILabel
        let path = uiviewPath(path)
        
        if let v = hosting.reuseUIView(path) {
            uiview = v as! UILabel
        } else {
            uiview = UILabel()
            uiview.numberOfLines = 0
            hosting.cacheUIView(uiview, path: path)
        }
        
        uiview.text = text
        
        return uiview
    }
    
    func measureUIView(_ path: String, proposedSize: CGSize, hosting: HostingView) -> UIView? {
        guard let uiview = hosting.queryUIView(uiviewPath(path)) else { return nil }
        
        uiview.transform = .identity
        uiview.frame.origin = .zero
        uiview.frame.size = uiview.sizeThatFits(proposedSize)
        
        return uiview
    }
    
}
