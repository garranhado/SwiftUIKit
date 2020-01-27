import UIKit

struct Spacer: View {
    
    var flexibility: (horizontal: ViewFlexibility, vertical: ViewFlexibility) {
        return (.veryHigh, .veryHigh)
    }
    
    func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
        let uiview: DSpacer
        let path = uiviewPath(path)
        
        if let v = hosting.reuseUIView(path) {
            uiview = v as! DSpacer
        } else {
            uiview = DSpacer()
            hosting.cacheUIView(uiview, path: path)
        }
        
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

extension Spacer {

    class DSpacer: UIView { }

}
