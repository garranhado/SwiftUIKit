import UIKit

protocol View {
    
    var flexibility: (horizontal: ViewFlexibility, vertical: ViewFlexibility) { get }
    var priority: Double { get }
    
    func makeUIView(_ path: String, hosting: HostingView) -> UIView?
    func measureUIView(_ path: String, proposedSize: CGSize, hosting: HostingView) -> UIView?
    func transformUIView(_ path: String, hosting: HostingView) -> UIView?
    
    func queryUIView(_ path: String, hosting: HostingView) -> UIView?
    
}

enum ViewFlexibility: Int {
    case veryLow = 0 // divider
    case low = 1 // image, button, ...
    case high = 2 // text, resizable image, shape, color, ...
    case veryHigh = 3 // spacer
}

// MARK: - Defaults

extension View {
    
    var flexibility: (horizontal: ViewFlexibility, vertical: ViewFlexibility) {
        return (.high, .high)
    }
    
    var priority: Double {
        return 0.0
    }
    
    func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
        return hosting.queryUIView(uiviewPath(path))
    }
    
    func measureUIView(_ path: String, proposedSize: CGSize, hosting: HostingView) -> UIView? {
        guard let uiview = hosting.queryUIView(uiviewPath(path)) else { return nil }
        
        uiview.transform = .identity
        uiview.frame.origin = .zero
        uiview.frame.size = proposedSize
        
        return uiview
    }
    
    func transformUIView(_ path: String, hosting: HostingView) -> UIView? {
        return hosting.queryUIView(uiviewPath(path))
    }
    
    func queryUIView(_ path: String, hosting: HostingView) -> UIView? {
        return hosting.queryUIView(uiviewPath(path))
    }
    
}

// MARK: - Utils

extension View {
    
    func uiviewPath(_ path: String) -> String {
        return path + "/" + String(describing: type(of: self))
    }
    
    func uiviewIndexPath(_ path: String, index: Int) -> String {
        return path + "/\(index)"
    }

}
