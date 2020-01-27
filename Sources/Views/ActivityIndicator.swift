import UIKit

struct ActivityIndicator: View {
    
    let style: UIActivityIndicatorView.Style
    let animating: Bool
    
    init(_ style: UIActivityIndicatorView.Style, animating: Bool = false) {
        self.style = style
        self.animating = animating
    }
    
}

extension ActivityIndicator {

    var flexibility: (horizontal: ViewFlexibility, vertical: ViewFlexibility) {
        return (.low, .low)
    }
    
    func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
        let uiview: UIActivityIndicatorView
        let path = uiviewPath(path)
        
        if let v = hosting.reuseUIView(path) {
            uiview = v as! UIActivityIndicatorView
        } else {
            uiview = UIActivityIndicatorView()
            hosting.cacheUIView(uiview, path: path)
        }
        
        uiview.hidesWhenStopped = true
        
        if animating {
            uiview.startAnimating()
        } else {
            uiview.stopAnimating()
        }
        
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
