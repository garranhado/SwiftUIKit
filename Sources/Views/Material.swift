import UIKit

struct Material: View {

    let style: UIBlurEffect.Style
    
    init(_ style: UIBlurEffect.Style) {
        self.style = style
    }

}

extension Material {
    
    func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
        let uiview: UIVisualEffectView
        let path = uiviewPath(path)
        
        if let v = hosting.reuseUIView(path) {
            uiview = v as! UIVisualEffectView
        } else {
            uiview = UIVisualEffectView()
            hosting.cacheUIView(uiview, path: path)
        }
        
        uiview.effect = nil
        uiview.effect = UIBlurEffect(style: style)
        
        return uiview
    }

}
