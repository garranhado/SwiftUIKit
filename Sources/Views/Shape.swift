import UIKit

struct Shape: View {
    
    let path: UIBezierPath
    
    init(_ path: UIBezierPath) {
        self.path = path
    }

}

extension Shape {
    
    func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
        let uiview: ShapeView
        let path = uiviewPath(path)
        
        if let v = hosting.reuseUIView(path) {
            uiview = v as! ShapeView
        } else {
            uiview = ShapeView()
            hosting.cacheUIView(uiview, path: path)
        }
        
        uiview.path = self.path
        
        return uiview
    }
    
}
