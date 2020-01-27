import UIKit

struct Color: View {
    
    let color: UIColor
    
    init(_ color: UIColor) {
        self.color = color
    }
    
}

extension Color {
    
    func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
        let uiview: UIView
        let path = uiviewPath(path)
        
        if let v = hosting.reuseUIView(path) {
            uiview = v
        } else {
            uiview = UIView()
            hosting.cacheUIView(uiview, path: path)
        }
        
        uiview.backgroundColor = color
        
        return uiview
    }
    
}
