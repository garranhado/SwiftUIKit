import UIKit

struct AttributedText: View {
    
    let text: NSAttributedString?
    
    init(_ text: NSAttributedString) {
        self.text = text
    }

}

extension AttributedText {
    
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
            hosting.cacheUIView(uiview, path: path)
        }
        
        uiview.attributedText = text
        
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
