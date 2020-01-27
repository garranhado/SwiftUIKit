import UIKit

struct Divider: View {
    
    var flexibility: (horizontal: ViewFlexibility, vertical: ViewFlexibility) {
        return (.veryLow, .veryLow)
    }
    
    func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
        let uiview: DDivider
        let path = uiviewPath(path)
        
        if let v = hosting.reuseUIView(path) {
            uiview = v as! DDivider
        } else {
            uiview = DDivider()
            hosting.cacheUIView(uiview, path: path)
        }
        
        uiview.backgroundColor = UIColor.opaqueSeparator
        
        return uiview
    }
    
    func measureUIView(_ path: String, proposedSize: CGSize, hosting: HostingView) -> UIView? {
        guard let uiview = hosting.queryUIView(uiviewPath(path)) else { return nil }
        
        uiview.transform = .identity
        uiview.frame.origin = .zero
        uiview.frame.size = .zero
        
        return uiview
    }
    
}

extension Divider {

    class DDivider: UIView { }
    
}
