import UIKit

struct Image: View {
    
    enum CornerRadius {
        case none
        case rounded(_ radius: CGFloat)
        case roundedTop(_ radius: CGFloat)
        case roundedBottom(_ radius: CGFloat)
        case circle
    }
    
    let source: Any
    let sourceType: Int
    let maxWidth: CGFloat?
    let placeholder: String?
    let transition: Bool
    let cornerRadius: CornerRadius
    
    let highlighted: String?
    
    init(image: UIImage) {
        self.source = image
        self.sourceType = 0
        self.maxWidth = nil
        self.placeholder = nil
        self.transition = false
        self.cornerRadius = .none
        
        self.highlighted = nil
    }
    
    init(data: Data) {
        self.source = data
        self.sourceType = 1
        self.maxWidth = nil
        self.placeholder = nil
        self.transition = false
        self.cornerRadius = .none
        
        self.highlighted = nil
    }
    
    init(named: String, highlight: String? = nil) {
        self.source = named
        self.sourceType = 2
        self.maxWidth = nil
        self.placeholder = nil
        self.transition = false
        self.cornerRadius = .none
        
        self.highlighted = highlight
    }
    
    init(file: URL, placeholder: String? = nil, maxWidth: CGFloat? = nil, cornerRadius: CornerRadius = .none, transition: Bool = false) {
        self.source = file
        self.sourceType = 3
        self.maxWidth = maxWidth
        self.placeholder = placeholder
        self.transition = transition
        self.cornerRadius = cornerRadius
        
        self.highlighted = nil
    }
    
    init(url: URL, placeholder: String? = nil, maxWidth: CGFloat? = nil, cornerRadius: CornerRadius = .none, transition: Bool = false) {
        self.source = url
        self.sourceType = 4
        self.maxWidth = maxWidth
        self.placeholder = placeholder
        self.transition = transition
        self.cornerRadius = cornerRadius
        
        self.highlighted = nil
    }

}

extension Image {
    
    var flexibility: (horizontal: ViewFlexibility, vertical: ViewFlexibility) {
        return (.low, .low)
    }
    
    func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
        let uiview: CustomImageView
        let path = uiviewPath(path)
        
        if let v = hosting.reuseUIView(path) {
            uiview = v as! CustomImageView
        } else {
            uiview = CustomImageView()
            hosting.cacheUIView(uiview, path: path)
        }
        
        switch cornerRadius {
        case .none:
            uiview.cornerRadius = 0.0
            uiview.cornerRadiusMode = 0
        case .rounded(let radius):
            uiview.cornerRadius = radius
            uiview.cornerRadiusMode = 0
        case .roundedTop(let radius):
            uiview.cornerRadius = radius
            uiview.cornerRadiusMode = 1
        case .roundedBottom(let radius):
            uiview.cornerRadius = radius
            uiview.cornerRadiusMode = 2
        case .circle:
            uiview.cornerRadius = -1.0
            uiview.cornerRadiusMode = 0
        }
        
        switch sourceType {
        case 0:
            uiview.cancel()
            uiview.image = source as? UIImage
        case 1:
            uiview.cancel()
            uiview.image = UIImage(data: source as! Data)
        case 2:
            uiview.cancel()
            uiview.image = UIImage(named: source as! String)
            
            if let h = highlighted {
                uiview.highlightedImage = UIImage(named: h)
            } else {
                uiview.highlightedImage = nil
            }
        case 3:
            guard uiview.task == nil else { return uiview }
            
            if let p = placeholder {
                uiview.placeholderImage = UIImage(named: p)
            }
            
            uiview.maxWidth = maxWidth ?? 0.0
            uiview.transition = transition
            uiview.imageFrom(file: source as! URL, cache: hosting.imageCache) { [weak hosting] _ in
                hosting?.layout()
            }
        case 4:
            guard uiview.task == nil else { return uiview }
            
            if let p = placeholder {
                uiview.placeholderImage = UIImage(named: p)
            }
            
            uiview.maxWidth = maxWidth ?? 0.0
            uiview.transition = transition
            uiview.imageFrom(url: source as! URL, cache: hosting.imageCache) { [weak hosting] _ in
                hosting?.layout()
            }
        default:
            break
        }
        
        return uiview
    }
    
    func measureUIView(_ path: String, proposedSize: CGSize, hosting: HostingView) -> UIView? {
        guard let uiview = hosting.queryUIView(uiviewPath(path)) else { return nil }
        
        uiview.transform = .identity
        uiview.frame.origin = .zero
        uiview.frame.size = uiview.sizeThatFits(proposedSize)
        
        return uiview
    }
    
}
