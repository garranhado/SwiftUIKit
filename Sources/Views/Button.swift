import UIKit

struct Button: View {
    
    typealias CoreView = UIButton
    
    let type: UIButton.ButtonType
    var update: (CoreView) -> Void

    init(_ type: UIButton.ButtonType, update: @escaping (CoreView) -> Void) {
        self.type = type
        self.update = update
    }

}

extension Button {

    var flexibility: (horizontal: ViewFlexibility, vertical: ViewFlexibility) {
        return (.low, .low)
    }
    
    func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
        let uiview: CoreView
        let path = uiviewPath(path)
        
        if let v = hosting.reuseUIView(path) {
            uiview = v as! CoreView
        } else {
            uiview = CoreView(type: type)
            hosting.cacheUIView(uiview, path: path)
        }
        
        update(uiview)
        
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
