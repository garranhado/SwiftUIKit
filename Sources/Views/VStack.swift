import UIKit

struct VStack: ViewContainer {

    let content: [View]
    
    let alignment: ViewHAlignment
    let spacing: CGFloat
    
    init(alignment: ViewHAlignment = .center, spacing: CGFloat = 5.0, @ViewBuilder content: () -> View) {
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
        self.spacing = spacing
    }
    
    init(alignment: ViewHAlignment = .center, spacing: CGFloat = 5.0, @ViewBuilder content: () -> [View]) {
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
        self.spacing = spacing
    }

}

extension VStack {
    
    var flexibility: (horizontal: ViewFlexibility, vertical: ViewFlexibility) {
        return (.low, .high)
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
        
        // Filter hidden
        
        var spacerCount: Int = 0
        
        let filteredContent = content.enumerated().filter {
            if $0.element is Spacer {
                spacerCount += 1
                return false
            }
            return true
        }

        guard !filteredContent.isEmpty else {
            uiview.frame.size = .zero
            return uiview
        }
        
        //
        
        var size: CGSize = .zero
        
        // Sizing
        
        let sortedContent = filteredContent.sorted {
            if $0.element.flexibility.vertical == .high, $1.element.flexibility.vertical == .high {
                return $0.element.priority > $1.element.priority
            }

            return $0.element.flexibility.vertical.rawValue < $1.element.flexibility.vertical.rawValue
        }
        
        var unallocatedSpace: CGFloat = max(0.0, proposedSize.height - (CGFloat(uiview.subviews.count - 1) * spacing))
        
        var count = sortedContent.count
        for c in sortedContent {
            var dividedSpace: CGFloat = 0.0
            
            if c.element.flexibility.vertical == .high, c.element.priority > 0 {
                dividedSpace = unallocatedSpace
            } else {
                dividedSpace = unallocatedSpace / CGFloat(count)
            }
            
            if let uiviewi = c.element.measureUIView(uiviewIndexPath(path, index: c.offset), proposedSize: CGSize(width: proposedSize.width, height: max(1.0, dividedSpace)), hosting: hosting) {
                
                if c.element is Divider {
                    uiviewi.frame.size.height = 1.0
                }
                
                size.width = max(size.width, uiviewi.frame.width)
                unallocatedSpace = max(0.0, unallocatedSpace - uiviewi.frame.height)
            }
            
            count -= 1
        }
        
        var dividedSpace: CGFloat = 0.0
        if spacerCount > 0 {
            dividedSpace = unallocatedSpace / CGFloat(spacerCount)
        }
        
        // Arrange
        
        for v in uiview.subviews {
            v.frame.origin.y += size.height
            
            if v is Spacer.DSpacer {
                v.frame.size.width = size.width
                v.frame.size.height = dividedSpace
            } else if v is Divider.DDivider {
                v.frame.size.width = size.width
            } else {
                switch alignment {
                case .center:
                    v.frame.origin.x += (size.width - v.frame.width) / 2.0
                case .leading:
                    v.frame.origin.x += 0.0
                case .trailing:
                    v.frame.origin.x += size.width - v.frame.width
                }
            }
            
            size.height += v.frame.size.height + spacing
        }
        
        size.height = max(0.0, size.height - spacing)
        
        //
        
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
