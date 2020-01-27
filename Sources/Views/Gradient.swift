import UIKit

struct Gradient: View {
    
    let axis: Axis
    let startColor: UIColor
    let endColor: UIColor
    
    init(_ axis: Axis = .vertical, startColor: UIColor, endColor: UIColor) {
        self.axis = axis
        self.startColor = startColor
        self.endColor = endColor
    }
    
}

extension Gradient {

    func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
        let uiview: GradientView
        let path = uiviewPath(path)
        
        if let v = hosting.reuseUIView(path) {
            uiview = v as! GradientView
        } else {
            uiview = GradientView()
            hosting.cacheUIView(uiview, path: path)
        }
        
        switch axis {
        case .vertical:
            uiview.mode = 1
        case .horizontal:
            uiview.mode = 2
        default:
            uiview.mode = 0
        }
        
        uiview.startColor = startColor
        uiview.endColor = endColor
        
        return uiview
    }
    
}

extension Gradient {
    
    enum Axis {
        case vertical
        case horizontal
        case both
    }
    
}
