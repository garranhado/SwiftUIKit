import UIKit

struct HStack: ViewContainer {

    let content: [View]
    
    let alignment: ViewVAlignment
    let spacing: CGFloat
    
    init(alignment: ViewVAlignment = .center, spacing: CGFloat = 5.0, @ViewBuilder content: () -> View) {
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
    
    init(alignment: ViewVAlignment = .center, spacing: CGFloat = 5.0, @ViewBuilder content: () -> [View]) {
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

extension HStack {
    
    var flexibility: (horizontal: ViewFlexibility, vertical: ViewFlexibility) {
        return (.high, .low)
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
            if $0.element.flexibility.horizontal == .high, $1.element.flexibility.horizontal == .high {
                return $0.element.priority > $1.element.priority
            }

            return $0.element.flexibility.horizontal.rawValue < $1.element.flexibility.horizontal.rawValue
        }
        
        var unallocatedSpace: CGFloat = max(0.0, proposedSize.width - (CGFloat(uiview.subviews.count - 1) * spacing))
        
        var count = sortedContent.count
        for c in sortedContent {
            var dividedSpace: CGFloat = 0.0
            
            if c.element.flexibility.horizontal == .high, c.element.priority > 0 {
                dividedSpace = unallocatedSpace
            } else {
                dividedSpace = unallocatedSpace / CGFloat(count)
            }
            
            if let uiviewi = c.element.measureUIView(uiviewIndexPath(path, index: c.offset), proposedSize: CGSize(width: max(1.0, dividedSpace), height: proposedSize.height), hosting: hosting) {
                
                if c.element is Divider {
                    uiviewi.frame.size.width = 1.0
                }
                
                size.height = max(size.height, uiviewi.frame.height)
                unallocatedSpace = max(0.0, unallocatedSpace - uiviewi.frame.width)
            }
            
            count -= 1
        }
        
        var dividedSpace: CGFloat = 0.0
        if spacerCount > 0 {
            dividedSpace = unallocatedSpace / CGFloat(spacerCount)
        }
        
        // Arrange
        
        for v in uiview.subviews {
            v.frame.origin.x += size.width
            
            if v is Spacer.DSpacer {
                v.frame.size.width = dividedSpace
                v.frame.size.height = size.height
            } else if v is Divider.DDivider {
                v.frame.size.height = size.height
            } else {
                switch alignment {
                case .bottom:
                    v.frame.origin.y += size.height - v.frame.height
                case .center:
                    v.frame.origin.y += (size.height - v.frame.height) / 2.0
                case .top:
                    v.frame.origin.y += 0.0
                }
            }
            
            size.width += v.frame.size.width + spacing
        }
        
        size.width = max(0.0, size.width - spacing)
        
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
