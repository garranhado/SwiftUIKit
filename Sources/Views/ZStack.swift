import UIKit

struct ZStack: ViewContainer {

    let content: [View]
    
    let alignment: ViewAlignment
    
    init(alignment: ViewAlignment = .center, @ViewBuilder content: () -> View) {
        var views: [View] = []

        let v = content()
        
        if let vi = v as? ForEach {
            views.append(contentsOf: vi.content)
        } else if let vi = v as? IfElse {
            views.append(vi.content as! View)
        } else {
            views.append(v)
        }

        self.content = views
        
        self.alignment = alignment
    }
    
    init(alignment: ViewAlignment = .center, @ViewBuilder content: () -> [View]) {
        var views: [View] = []

        for v in content() {
            if let vi = v as? ForEach {
                views.append(contentsOf: vi.content)
            } else if let vi = v as? IfElse {
                views.append(vi.content as! View)
            } else {
                views.append(v)
            }
        }

        self.content = views
        
        self.alignment = alignment
    }

}

extension ZStack {
    
    var flexibility: (horizontal: ViewFlexibility, vertical: ViewFlexibility) {
        return (.high, .high)
    }
    
    func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
        let uiview: UIView
        let path = uiviewPath(path)
        
        if let v = hosting.reuseUIView(path) {
            uiview = v
            uiview.subviews.forEach { $0.removeFromSuperview() }
        } else {
            uiview = UIView()
            uiview.autoresizesSubviews = false
            
            hosting.cacheUIView(uiview, path: path)
        }
        
        for c in content.enumerated() {
            if let uiviewi = c.element.makeUIView(uiviewIndexPath(path, index: c.offset), hosting: hosting) {
                uiview.addSubview(uiviewi)
            }
        }
        
        return uiview
    }
    
    func measureUIView(_ path: String, proposedSize: CGSize, hosting: HostingView) -> UIView? {
        let path = uiviewPath(path)
        guard let uiview = hosting.queryUIView(path) else { return nil }
        
        var size: CGSize = .zero
        
        for c in content.enumerated() {
            if let uiviewi = c.element.measureUIView(uiviewIndexPath(path, index: c.offset), proposedSize: proposedSize, hosting: hosting) {
                size.width = max(size.width, uiviewi.frame.width)
                size.height = max(size.height, uiviewi.frame.height)
            }
        }
        
        for v in uiview.subviews {
            switch alignment {
            case .bottom:
                v.frame.origin.x += (size.width - v.frame.width) / 2.0
                v.frame.origin.y += size.height - v.frame.height
            case .bottomLeading:
                v.frame.origin.x += 0.0
                v.frame.origin.y += size.height - v.frame.height
            case .bottomTrailing:
                v.frame.origin.x += size.width - v.frame.width
                v.frame.origin.y += size.height - v.frame.height
            case .center:
                v.frame.origin.x += (size.width - v.frame.width) / 2.0
                v.frame.origin.y += (size.height - v.frame.height) / 2.0
            case .leading:
                v.frame.origin.x += 0.0
                v.frame.origin.y += (size.height - v.frame.height) / 2.0
            case .top:
                v.frame.origin.x += (size.width - v.frame.width) / 2.0
                v.frame.origin.y += 0.0
            case .topLeading:
                v.frame.origin.x += 0.0
                v.frame.origin.y += 0.0
            case .topTrailing:
                v.frame.origin.x += size.width - v.frame.width
                v.frame.origin.y += 0.0
            case .trailing:
                v.frame.origin.x += size.width - v.frame.width
                v.frame.origin.y += (size.height - v.frame.height) / 2.0
            }
        }
        
        uiview.transform = .identity
        uiview.frame.origin = .zero
        uiview.frame.size = size
        
        return uiview
    }
    
    func transformUIView(_ path: String, hosting: HostingView) -> UIView? {
        let path = uiviewPath(path)
        for c in content.enumerated() {
            _ = c.element.transformUIView(uiviewIndexPath(path, index: c.offset), hosting: hosting)
        }
        
        return hosting.reuseUIView(path)
    }
    
}
