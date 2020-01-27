import UIKit

struct ScrollView: View {
    
    let content: View
    
    let axis: Axis
    let indicators: UIScrollView.IndicatorStyle?
    
    weak var delegate: UIScrollViewDelegate?
    
    init(_ axis: Axis = .vertical, indicators: UIScrollView.IndicatorStyle? = .default, delegate: UIScrollViewDelegate? = nil, @ViewBuilder content: () -> View) {
        self.content = content()
        
        self.axis = axis
        self.indicators = indicators
        
        self.delegate = delegate
    }
    
}

extension ScrollView {

    func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
        let uiview: UIScrollView
        let path = uiviewPath(path)
        
        if let v = hosting.reuseUIView(path) {
            uiview = v as! UIScrollView
            uiview.subviews.forEach { $0.removeFromSuperview() }
        } else {
            uiview = UIScrollView()
            uiview.backgroundColor = .clear
            uiview.contentInsetAdjustmentBehavior = .never
            
            hosting.cacheUIView(uiview, path: path)
            
            DispatchQueue.main.async {
                uiview.contentOffset = CGPoint(x: 0.0, y: -uiview.contentInset.top)
            }
        }
        
        if let uiviewi = content.makeUIView(path, hosting: hosting) {
            uiview.addSubview(uiviewi)
        }
        
        if let style = indicators {
            uiview.indicatorStyle = style
            
            uiview.showsVerticalScrollIndicator = axis != .horizontal
            uiview.showsHorizontalScrollIndicator = axis != .vertical
        } else {
            uiview.showsVerticalScrollIndicator = false
            uiview.showsHorizontalScrollIndicator = false
        }
        
        uiview.alwaysBounceVertical = axis != .horizontal
        uiview.alwaysBounceHorizontal = axis != .vertical
        
        uiview.delegate = delegate
        
        return uiview
    }
    
    func measureUIView(_ path: String, proposedSize: CGSize, hosting: HostingView) -> UIView? {
        let path = uiviewPath(path)
        guard let uiview = hosting.queryUIView(path) else { return nil }
        
        uiview.transform = .identity
        uiview.frame.origin = .zero
        uiview.frame.size = proposedSize
        
        if let uiviewi = content.measureUIView(path, proposedSize: proposedSize, hosting: hosting) {
            (uiview as! UIScrollView).contentSize = uiviewi.frame.size
            
            if axis == .vertical || axis == .both {
                uiviewi.frame.origin.x += (uiview.frame.width - uiviewi.frame.width) / 2.0
            }

            if axis == .horizontal || axis == .both {
                uiviewi.frame.origin.y += (uiview.frame.height - uiviewi.frame.height) / 2.0
            }
        }
        
        return uiview
    }

}

extension ScrollView {
    
    enum Axis {
        case vertical
        case horizontal
        case both
    }
    
}
