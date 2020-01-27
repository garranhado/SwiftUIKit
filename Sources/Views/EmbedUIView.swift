import UIKit

struct EmbedUIView: View {
    
    weak var uiview: UIView? = nil
    
    init(_ uiview: UIView) {
        self.uiview = uiview
    }
    
}

extension EmbedUIView {
    
    func makeUIView(_ path: String, hosting: HostingView) -> UIView? {        
        return uiview
    }

}
