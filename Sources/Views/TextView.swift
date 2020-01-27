import UIKit

struct TextView: View {
    
    let text: String
    
    weak var delegate: UITextViewDelegate?
    
    init(_ text: String, delegate: UITextViewDelegate? = nil) {
        self.text = text
        
        self.delegate = delegate
    }
    
}

extension TextView {

    func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
        let uiview: CustomTextView
        let path = uiviewPath(path)
        
        if let v = hosting.reuseUIView(path) {
            uiview = v as! CustomTextView
        } else {
            uiview = CustomTextView()
            uiview.backgroundColor = .clear
            uiview.contentInsetAdjustmentBehavior = .never
            
            hosting.cacheUIView(uiview, path: path)
            
            DispatchQueue.main.async {
                uiview.contentOffset = CGPoint(x: 0.0, y: -uiview.contentInset.top)
            }
        }
        
        uiview.text = text
                
        uiview.delegate = delegate
        
        return uiview
    }
    
    func measureUIView(_ path: String, proposedSize: CGSize, hosting: HostingView) -> UIView? {
        guard let uiview = hosting.queryUIView(uiviewPath(path)) else { return nil }
        
        uiview.transform = .identity
        uiview.frame.origin = .zero
        uiview.frame.size = proposedSize
        
        return uiview
    }

}
