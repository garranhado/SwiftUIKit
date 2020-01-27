import UIKit

protocol ViewModifier: View {
    
    var content: View { get }
}

enum ScrollInsetReference {
    case none
    case safeArea(top: Bool = false, leading: Bool = false, bottom: Bool = false, trailing: Bool = false)
}

// MARK: - Defaults and Utils

extension ViewModifier {
    
    var flexibility: (horizontal: ViewFlexibility, vertical: ViewFlexibility) {
        return content.flexibility
    }
    
    var priority: Double {
        return content.priority
    }
    
    func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
        return content.makeUIView(path, hosting: hosting)
    }
    
    func measureUIView(_ path: String, proposedSize: CGSize, hosting: HostingView) -> UIView? {
        return content.measureUIView(path, proposedSize: proposedSize, hosting: hosting)
    }
    
    func transformUIView(_ path: String, hosting: HostingView) -> UIView? {
        return content.transformUIView(path, hosting: hosting)
    }
    
    func queryUIView(_ path: String, hosting: HostingView) -> UIView? {
        let pathi = uiviewPath(path)
        
        guard let uiview = hosting.queryUIView(pathi) else {
            return content.queryUIView(path, hosting: hosting)
        }
        
        return uiview
    }
    
}

// MARK: - Modifiers

extension View {
    
    func frame(width: CGFloat? = nil, height: CGFloat? = nil, alignment: ViewAlignment = .center) -> View {
        return ViewModifiers.Frame(content: self,
                                   width: width,
                                   minWidth: nil,
                                   maxWidth: nil,
                                   height: height,
                                   minHeight: nil,
                                   maxHeight: nil,
                                   alignment: alignment)
    }
    
    func frame(minWidth: CGFloat? = nil, maxWidth: CGFloat? = nil, minHeight: CGFloat? = nil, maxHeight: CGFloat? = nil, alignment: ViewAlignment = .center) -> View {
        return ViewModifiers.Frame(content: self,
                                   width: nil,
                                   minWidth: minWidth,
                                   maxWidth: maxWidth,
                                   height: nil,
                                   minHeight: minHeight,
                                   maxHeight: maxHeight,
                                   alignment: alignment)
    }
    
    func fixedSize() -> View {
        return ViewModifiers.FixedSize(content: self, horizontal: true, vertical: true)
    }
    
    func fixedSize(horizontal: Bool, vertical: Bool) -> View {
        return ViewModifiers.FixedSize(content: self, horizontal: horizontal, vertical: vertical)
    }
    
    func layoutPriority(_ value: Double) -> View {
        return ViewModifiers.LayoutPriority(content: self, value: value)
    }

    func padding(_ all: CGFloat = 16.0) -> View {
        return ViewModifiers.Padding(content: self, top: all, leading: all, bottom: all, trailing: all)
    }

    func padding(horizontal: CGFloat = 0.0, vertical: CGFloat = 0.0) -> View {
        return ViewModifiers.Padding(content: self, top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }

    func padding(top: CGFloat = 0.0, leading: CGFloat = 0.0, bottom: CGFloat = 0.0, trailing: CGFloat = 0.0) -> View {
        return ViewModifiers.Padding(content: self, top: top, leading: leading, bottom: bottom, trailing: trailing)
    }

    func edgesIgnoringSafeArea(_ all: Bool = true) -> View {
        return ViewModifiers.EdgesIgnoringSafeArea(content: self, top: all, leading: all, bottom: all, trailing: all)
    }

    func edgesIgnoringSafeArea(top: Bool = false, leading: Bool = false, bottom: Bool = false, trailing: Bool = false) -> View {
        return ViewModifiers.EdgesIgnoringSafeArea(content: self, top: top, leading: leading, bottom: bottom, trailing: trailing)
    }

    func offset(x: CGFloat = 0.0, y: CGFloat = 0.0) -> View {
        return ViewModifiers.Offset(content: self, x: x, y: y)
    }

    func transformEffect(_ transform: CGAffineTransform) -> View {
        return ViewModifiers.TransformEffect(content: self, transform: transform)
    }
    
    func rotationEffect(angle: CGFloat) -> View {
        return ViewModifiers.TransformEffect(content: self, transform: CGAffineTransform(rotationAngle: angle * 0.0174533))
    }

    func scaleEffect(x: CGFloat, y: CGFloat) -> View {
        return ViewModifiers.TransformEffect(content: self, transform: CGAffineTransform(scaleX: x, y: y))
    }

    func opacity(_ opacity: Double) -> View {
        return ViewModifiers.Opacity(content: self, value: opacity)
    }

    func backgroundColor(_ color: UIColor) -> View {
        return ViewModifiers.BackgroundColor(content: self, color: color)
    }
    
    func background(_ background: View, alignment: ViewAlignment = .center) -> View {
        return ViewModifiers.Background(content: self, backgroundContent: background, alignment: alignment)
    }
    
    func overlay(_ overlay: View, alignment: ViewAlignment = .center) -> View {
        return ViewModifiers.Overlay(content: self, overlayContent: overlay, alignment: alignment)
    }

    func accentColor(_ color: UIColor?) -> View {
        return ViewModifiers.AccentColor(content: self, color: color)
    }

    func zIndex(_ value: Double) -> View {
        ViewModifiers.ZIndex(content: self, value: value)
    }

    func tag(_ tag: Int) -> View {
        return ViewModifiers.Tag(content: self, value: tag)
    }

    func cornerRadius(_ radius: CGFloat = 12) -> View {
        return ViewModifiers.CornerRadius(content: self, value: radius)
    }

    func border(width: CGFloat, color: UIColor) -> View {
        return ViewModifiers.Border(content: self, width: width, color: color)
    }

    func shadow(opacity: Double = 0.5, radius: CGFloat = 15.0, offsetX: CGFloat = 0.0, offsetY: CGFloat = 5.0, color: UIColor = .black) -> View {
        return ViewModifiers.Shadow(content: self, opacity: opacity, radius: radius, offset: CGSize(width: offsetX, height: offsetY), color: color)
    }

    func hidden(_ hidden: Bool = true) -> View {
        return ViewModifiers.Hidden(content: self, value: hidden)
    }

    func clipped(_ clipped: Bool = true) -> View {
        return ViewModifiers.Clipped(content: self, value: clipped)
    }

    func allowsHitTesting(_ enabled: Bool) -> View {
        return ViewModifiers.AllowsHitTesting(content: self, value: enabled)
    }

    func shouldRasterize() -> View {
        return ViewModifiers.ShouldRasterize(content: self)
    }

    // Text

    func font(style: UIFont.TextStyle) -> View {
        let font = UIFont.preferredFont(forTextStyle: style)
        return ViewModifiers.Font(content: self, value: font)
    }

    func font(name fontName: String, size fontSize: CGFloat) -> View {
        let font = UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        return ViewModifiers.Font(content: self, value: font)
    }

    func font(font: UIFont) -> View {
        return ViewModifiers.Font(content: self, value: font)
    }

    func foregroundColor(_ color: UIColor, highlightedColor: UIColor? = nil) -> View {
        return ViewModifiers.ForegroundColor(content: self, color: color, highlightedColor: highlightedColor)
    }

    func lineLimit(_ number: Int) -> View {
        return ViewModifiers.LineLimit(content: self, value: number)
    }

    func multilineTextAlignment(_ alignment: NSTextAlignment) -> View {
        return ViewModifiers.MultilineTextAlignment(content: self, value: alignment)
    }

    func minimumScaleFactor(_ factor: CGFloat) -> View {
        return ViewModifiers.MinimumScaleFactor(content: self, value: factor)
    }

    // Shape & Image

    func resizable(_ resizable: Bool = true) -> View {
        return ViewModifiers.Resizable(content: self)
    }
    
    func scaledToFill() -> View {
        return ViewModifiers.ScaledToFill(content: self)
    }

    func scaledToFit() -> View {
        return ViewModifiers.ScaledToFit(content: self)
    }
    
    func aspectRatio(_ aspectRatio: CGFloat) -> View {
        return ViewModifiers.AspectRatio(content: self, value: aspectRatio)
    }

    // Shape

    func fill(_ color: UIColor) -> View {
        return ViewModifiers.Fill(content: self, value: color)
    }

    func stroke(_ color: UIColor) -> View {
        return ViewModifiers.Stroke(content: self, value: color)
    }

    func lineWidth(_ width: CGFloat) -> View {
        return ViewModifiers.LineWidth(content: self, value: width)
    }

    // Controls

    func target(_ target: AnyObject, action: Selector, event: UIControl.Event) -> View {
        return ViewModifiers.Target(content: self, target: target, action: action, event: event)
    }
    
    func disabled(_ disabled: Bool = true) -> View {
        return ViewModifiers.Disabled(content: self, value: disabled)
    }
    
    func keyboard(type: UIKeyboardType = .default, appearance: UIKeyboardAppearance = .default, returnKeyType: UIReturnKeyType = .default) -> View {
        return ViewModifiers.Keyboard(content: self, type: type, appearance: appearance, returnKeyType: returnKeyType)
    }

    // ScrollView
    
    func scrollInsets(_ insets: UIEdgeInsets = .zero, insetReference: ScrollInsetReference = .none) -> View {
        return ViewModifiers.ScrollInsets(content: self, contentInset: insets, indicatorInsets: insets, insetReference: insetReference)
    }
    
    func scrollInsets(_ contentInset: UIEdgeInsets = .zero, indicatorInsets: UIEdgeInsets = .zero, insetReference: ScrollInsetReference = .none) -> View {
        return ViewModifiers.ScrollInsets(content: self, contentInset: contentInset, indicatorInsets: indicatorInsets, insetReference: insetReference)
    }
    
    func scrollPaging(_ paging: Bool = true) -> View {
        return ViewModifiers.ScrollPaging(content: self, paging: paging)
    }
    
    // Gesture
    
    func gesture(_ gesture: UIGestureRecognizer) -> View {
        return ViewModifiers.Gesture(content: self, gesture: gesture)
    }

}

struct ViewModifiers {
        
    struct Frame: ViewModifier {

        let content: View
        
        let width: CGFloat?
        let minWidth: CGFloat?
        let maxWidth: CGFloat?
        
        let height: CGFloat?
        let minHeight: CGFloat?
        let maxHeight: CGFloat?
        
        let alignment: ViewAlignment
        
        var flexibility: (horizontal: ViewFlexibility, vertical: ViewFlexibility) {
            return (width == nil ? .high : .low, height == nil ? .high : .low)
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
            
            if let uiviewi = content.makeUIView(path, hosting: hosting) {
                uiview.addSubview(uiviewi)
            }
            
            return uiview
        }
        
        func measureUIView(_ path: String, proposedSize: CGSize, hosting: HostingView) -> UIView? {
            let path = uiviewPath(path)
            guard let uiview = hosting.queryUIView(path) else { return nil }
            
            var size: CGSize = proposedSize
            
            if let w = width {
                size.width = w
            } else {
                if let w = minWidth {
                    size.width = max(size.width, w)
                }
                
                if let w = maxWidth {
                    size.width = min(size.width, w)
                }
            }
            
            if let h = height {
                size.height = h
            } else {
                if let h = minHeight {
                    size.height = max(size.height, h)
                }
                
                if let h = maxHeight {
                    size.height = min(size.height, h)
                }
            }
            
            guard let uiviewi = content.measureUIView(path, proposedSize: size, hosting: hosting) else {
                uiview.transform = .identity
                uiview.frame.origin = .zero
                uiview.frame.size = size
                return uiview
            }
            
            if width == nil, maxWidth == nil {
                if let w = minWidth {
                    size.width = max(uiviewi.frame.size.width, w)
                } else {
                    size.width = uiviewi.frame.size.width
                }
            }
            
            if height == nil, maxHeight == nil {
                if let h = minHeight {
                    size.height = max(uiviewi.frame.size.height, h)
                } else {
                    size.height = uiviewi.frame.size.height
                }
            }
            
            uiview.transform = .identity
            uiview.frame.origin = .zero
            uiview.frame.size = size
            
            switch alignment {
            case .bottom:
                uiviewi.frame.origin.x += (size.width - uiviewi.frame.width) / 2.0
                uiviewi.frame.origin.y += size.height - uiviewi.frame.height
            case .bottomLeading:
                uiviewi.frame.origin.x += 0.0
                uiviewi.frame.origin.y += size.height - uiviewi.frame.height
            case .bottomTrailing:
                uiviewi.frame.origin.x += size.width - uiviewi.frame.width
                uiviewi.frame.origin.y += size.height - uiviewi.frame.height
            case .center:
                uiviewi.frame.origin.x += (size.width - uiviewi.frame.width) / 2.0
                uiviewi.frame.origin.y += (size.height - uiviewi.frame.height) / 2.0
            case .leading:
                uiviewi.frame.origin.x += 0.0
                uiviewi.frame.origin.y += (size.height - uiviewi.frame.height) / 2.0
            case .top:
                uiviewi.frame.origin.x += (size.width - uiviewi.frame.width) / 2.0
                uiviewi.frame.origin.y += 0.0
            case .topLeading:
                uiviewi.frame.origin.x += 0.0
                uiviewi.frame.origin.y += 0.0
            case .topTrailing:
                uiviewi.frame.origin.x += size.width - uiviewi.frame.width
                uiviewi.frame.origin.y += 0.0
            case .trailing:
                uiviewi.frame.origin.x += size.width - uiviewi.frame.width
                uiviewi.frame.origin.y += (size.height - uiviewi.frame.height) / 2.0
            }
            
            return uiview
        }
        
        func transformUIView(_ path: String, hosting: HostingView) -> UIView? {
            return hosting.queryUIView(uiviewPath(path))
        }
        
        func queryUIView(_ path: String, hosting: HostingView) -> UIView? {
            return hosting.queryUIView(uiviewPath(path))
        }
        
    }
    
    struct FixedSize: ViewModifier {

        let content: View

        let horizontal: Bool
        let vertical: Bool

        func measureUIView(_ path: String, proposedSize: CGSize, hosting: HostingView) -> UIView? {
            var size = proposedSize
            
            if horizontal {
                size.width = .infinity
            }
            
            if vertical {
                size.height = .infinity
            }
            
            return content.measureUIView(path, proposedSize: size, hosting: hosting)
        }

    }
    
    struct LayoutPriority: ViewModifier {

        let content: View

        let value: Double

        var priority: Double {
            return value
        }

    }
    
    struct Offset: ViewModifier {
        
        let content: View
        
        let x: CGFloat
        let y: CGFloat
        
        func measureUIView(_ path: String, proposedSize: CGSize, hosting: HostingView) -> UIView? {
            guard let uiview = content.measureUIView(path, proposedSize: proposedSize, hosting: hosting) else { return nil }
            
            uiview.frame.origin.x += x
            uiview.frame.origin.y += y
            
            return uiview
        }
        
    }
    
    struct Padding: ViewModifier {
        
        let content: View
        
        let top: CGFloat
        let leading: CGFloat
        let bottom: CGFloat
        let trailing: CGFloat
        
        var flexibility: (horizontal: ViewFlexibility, vertical: ViewFlexibility) {
            return (.low, .low)
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
            
            if let uiviewi = content.makeUIView(path, hosting: hosting) {
                uiview.addSubview(uiviewi)
            }
            
            return uiview
        }
        
        func measureUIView(_ path: String, proposedSize: CGSize, hosting: HostingView) -> UIView? {
            let path = uiviewPath(path)
            guard let uiview = hosting.queryUIView(path) else { return nil }
            
            var size = proposedSize
            
            size.width = max(0.0, size.width - (leading + trailing))
            size.height = max(0.0, size.height - (top + bottom))
            
            guard let uiviewi = content.measureUIView(path, proposedSize: size, hosting: hosting) else {
                uiview.transform = .identity
                uiview.frame.origin = .zero
                uiview.frame.size = proposedSize
                
                return uiview
            }
            
            uiviewi.frame.origin.x += leading
            uiviewi.frame.origin.y += top
            
            uiview.transform = .identity
            uiview.frame.origin = .zero
            
            uiview.frame.size.width = max(0.0, uiviewi.frame.width + leading + trailing)
            uiview.frame.size.height = max(0.0, uiviewi.frame.height + top + bottom)
            
            return uiview
        }
        
        func transformUIView(_ path: String, hosting: HostingView) -> UIView? {
            return hosting.queryUIView(uiviewPath(path))
        }
        
        func queryUIView(_ path: String, hosting: HostingView) -> UIView? {
            return hosting.queryUIView(uiviewPath(path))
        }
        
    }
    
    struct EdgesIgnoringSafeArea: ViewModifier {
        
        let content: View
        
        let top: Bool
        let leading: Bool
        let bottom: Bool
        let trailing: Bool
        
        var flexibility: (horizontal: ViewFlexibility, vertical: ViewFlexibility) {
            return (.low, .low)
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
            
            if let uiviewi = content.makeUIView(path, hosting: hosting) {
                uiview.addSubview(uiviewi)
            }
            
            return uiview
        }
        
        func measureUIView(_ path: String, proposedSize: CGSize, hosting: HostingView) -> UIView? {
            let path = uiviewPath(path)
            guard let uiview = hosting.queryUIView(path) else { return nil }
            
            uiview.transform = .identity
            uiview.frame.origin = .zero
            uiview.frame.size = proposedSize
            
            let safeAreaInsets = hosting.safeAreaInsets
            var size = proposedSize
            
            if top {
                size.height += safeAreaInsets.top
            }
            
            if leading {
                size.width += safeAreaInsets.left
            }
            
            if bottom {
                size.height += safeAreaInsets.bottom
            }
            
            if trailing {
                size.width += safeAreaInsets.right
            }
            
            guard let uiviewi = content.measureUIView(path, proposedSize: size, hosting: hosting) else { return uiview }
            
            uiviewi.frame.origin.y += (size.height - uiviewi.frame.height) / 2.0
            uiviewi.frame.origin.x += (size.width - uiviewi.frame.width) / 2.0
            
            if top {
                uiviewi.frame.origin.y -= safeAreaInsets.top
            }
            
            if leading {
                uiviewi.frame.origin.x -= safeAreaInsets.left
            }
            
            return uiview
        }
        
        func transformUIView(_ path: String, hosting: HostingView) -> UIView? {
            return hosting.queryUIView(uiviewPath(path))
        }
        
        func queryUIView(_ path: String, hosting: HostingView) -> UIView? {
            return hosting.queryUIView(uiviewPath(path))
        }
        
    }
    
    struct Opacity: ViewModifier {
        
        let content: View
        
        let value: Double
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            guard let uiview = content.makeUIView(path, hosting: hosting) else { return nil }
            
            uiview.alpha = CGFloat(value)
            
            return uiview
        }
        
    }
    
    struct BackgroundColor: ViewModifier {
        
        let content: View
        
        let color: UIColor?
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            guard let uiview = content.makeUIView(path, hosting: hosting) else { return nil }
            
            uiview.backgroundColor = color
            
            return uiview
        }
        
    }
    
    struct Background: ViewModifier {
        
        let content: View
        
        let backgroundContent: View
        let alignment: ViewAlignment
        
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
            
            if let uiviewi = backgroundContent.makeUIView(path, hosting: hosting) {
                uiview.addSubview(uiviewi)
            }
            
            if let uiviewi = content.makeUIView(path, hosting: hosting) {
                uiview.addSubview(uiviewi)
            }
            
            return uiview
        }
        
        func measureUIView(_ path: String, proposedSize: CGSize, hosting: HostingView) -> UIView? {
            let path = uiviewPath(path)
            guard let uiview = hosting.queryUIView(path) else { return nil }
            guard let uiviewi = content.measureUIView(path, proposedSize: proposedSize, hosting: hosting) else { return uiview }
            
            let size = uiviewi.frame.size
            
            if let uiviewii = backgroundContent.measureUIView(path, proposedSize: size, hosting: hosting) {
                switch alignment {
                case .bottom:
                    uiviewii.frame.origin.x += (size.width - uiviewii.frame.width) / 2.0
                    uiviewii.frame.origin.y += size.height - uiviewii.frame.height
                case .bottomLeading:
                    uiviewii.frame.origin.x += 0.0
                    uiviewii.frame.origin.y += size.height - uiviewii.frame.height
                case .bottomTrailing:
                    uiviewii.frame.origin.x += size.width - uiviewii.frame.width
                    uiviewii.frame.origin.y += size.height - uiviewii.frame.height
                case .center:
                    uiviewii.frame.origin.x += (size.width - uiviewii.frame.width) / 2.0
                    uiviewii.frame.origin.y += (size.height - uiviewii.frame.height) / 2.0
                case .leading:
                    uiviewii.frame.origin.x += 0.0
                    uiviewii.frame.origin.y += (size.height - uiviewii.frame.height) / 2.0
                case .top:
                    uiviewii.frame.origin.x += (size.width - uiviewii.frame.width) / 2.0
                    uiviewii.frame.origin.y += 0.0
                case .topLeading:
                    uiviewii.frame.origin.x += 0.0
                    uiviewii.frame.origin.y += 0.0
                case .topTrailing:
                    uiviewii.frame.origin.x += size.width - uiviewii.frame.width
                    uiviewii.frame.origin.y += 0.0
                case .trailing:
                    uiviewii.frame.origin.x += size.width - uiviewii.frame.width
                    uiviewii.frame.origin.y += (size.height - uiviewii.frame.height) / 2.0
                }
            }
            
            uiview.transform = .identity
            uiview.frame.origin = .zero
            uiview.frame.size = size
            
            return uiview
        }
        
        func transformUIView(_ path: String, hosting: HostingView) -> UIView? {
            return hosting.queryUIView(uiviewPath(path))
        }
        
        func queryUIView(_ path: String, hosting: HostingView) -> UIView? {
            return hosting.queryUIView(uiviewPath(path))
        }
        
    }
    
    struct Overlay: ViewModifier {
        
        let content: View
        
        let overlayContent: View
        let alignment: ViewAlignment
        
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
            
            if let uiviewi = content.makeUIView(path, hosting: hosting) {
                uiview.addSubview(uiviewi)
            }
            
            if let uiviewi = overlayContent.makeUIView(path, hosting: hosting) {
                uiview.addSubview(uiviewi)
            }
            
            return uiview
        }
        
        func measureUIView(_ path: String, proposedSize: CGSize, hosting: HostingView) -> UIView? {
            let path = uiviewPath(path)
            guard let uiview = hosting.queryUIView(path) else { return nil }
            guard let uiviewi = content.measureUIView(path, proposedSize: proposedSize, hosting: hosting) else { return uiview }
            
            let size = uiviewi.frame.size
            
            if let uiviewii = overlayContent.measureUIView(path, proposedSize: size, hosting: hosting) {
                switch alignment {
                case .bottom:
                    uiviewii.frame.origin.x += (size.width - uiviewii.frame.width) / 2.0
                    uiviewii.frame.origin.y += size.height - uiviewii.frame.height
                case .bottomLeading:
                    uiviewii.frame.origin.x += 0.0
                    uiviewii.frame.origin.y += size.height - uiviewii.frame.height
                case .bottomTrailing:
                    uiviewii.frame.origin.x += size.width - uiviewii.frame.width
                    uiviewii.frame.origin.y += size.height - uiviewii.frame.height
                case .center:
                    uiviewii.frame.origin.x += (size.width - uiviewii.frame.width) / 2.0
                    uiviewii.frame.origin.y += (size.height - uiviewii.frame.height) / 2.0
                case .leading:
                    uiviewii.frame.origin.x += 0.0
                    uiviewii.frame.origin.y += (size.height - uiviewii.frame.height) / 2.0
                case .top:
                    uiviewii.frame.origin.x += (size.width - uiviewii.frame.width) / 2.0
                    uiviewii.frame.origin.y += 0.0
                case .topLeading:
                    uiviewii.frame.origin.x += 0.0
                    uiviewii.frame.origin.y += 0.0
                case .topTrailing:
                    uiviewii.frame.origin.x += size.width - uiviewii.frame.width
                    uiviewii.frame.origin.y += 0.0
                case .trailing:
                    uiviewii.frame.origin.x += size.width - uiviewii.frame.width
                    uiviewii.frame.origin.y += (size.height - uiviewii.frame.height) / 2.0
                }
            }
            
            uiview.transform = .identity
            uiview.frame.origin = .zero
            uiview.frame.size = size
            
            return uiview
        }
        
        func transformUIView(_ path: String, hosting: HostingView) -> UIView? {
            return hosting.queryUIView(uiviewPath(path))
        }
        
        func queryUIView(_ path: String, hosting: HostingView) -> UIView? {
            return hosting.queryUIView(uiviewPath(path))
        }
        
    }
    
    struct AccentColor: ViewModifier {
        
        let content: View
        
        let color: UIColor?
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            guard let uiview = content.makeUIView(path, hosting: hosting) else { return nil }
            
            uiview.tintColor = color
            
            return uiview
        }
        
    }
    
    struct ZIndex: ViewModifier {
        
        let content: View
        
        let value: Double
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            guard let uiview = content.makeUIView(path, hosting: hosting) else { return nil }
            
            uiview.layer.zPosition = CGFloat(value)
            
            return uiview
        }
        
    }
    
    struct Tag: ViewModifier {
        
        let content: View
        
        let value: Int
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            guard let uiview = content.makeUIView(path, hosting: hosting) else { return nil }
            
            uiview.tag = value
            
            return uiview
        }
        
    }
    
    struct Hidden: ViewModifier {
        
        let content: View
        
        let value: Bool
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            guard let uiview = content.makeUIView(path, hosting: hosting) else { return nil }
            
            uiview.isHidden = value
            
            return uiview
        }
        
    }
    
    struct Clipped: ViewModifier {
        
        let content: View
        
        let value: Bool
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            guard let uiview = content.makeUIView(path, hosting: hosting) else { return nil }
            
            uiview.clipsToBounds = value
            
            return uiview
        }
        
    }
    
    struct AllowsHitTesting: ViewModifier {
        
        let content: View
        
        let value: Bool
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            guard let uiview = content.makeUIView(path, hosting: hosting) else { return nil }
            
            uiview.isUserInteractionEnabled = value
            
            return uiview
        }
        
    }
    
    struct ShouldRasterize: ViewModifier {
        
        let content: View
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            guard let uiview = content.makeUIView(path, hosting: hosting) else { return nil }
            
            uiview.layer.shouldRasterize = true
            uiview.layer.rasterizationScale = UIScreen.main.scale
            
            return uiview
        }
        
    }
    
    struct CornerRadius: ViewModifier {
        
        let content: View
        
        let value: CGFloat
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            guard let uiview = content.makeUIView(path, hosting: hosting) else { return nil }
            
            uiview.layer.cornerRadius = value
            if #available(iOS 13.0, *) {
                uiview.layer.cornerCurve = .continuous
            } else {
                // Fallback on earlier versions
            }
            
            return uiview
        }
        
    }
    
    struct Border: ViewModifier {
        
        let content: View
        
        let width: CGFloat
        let color: UIColor
     
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            guard let uiview = content.makeUIView(path, hosting: hosting) else { return nil }
            
            uiview.layer.borderWidth = width
            uiview.layer.borderColor = color.cgColor
            
            return uiview
        }
        
    }
    
    struct Shadow: ViewModifier {
        
        let content: View
        
        let opacity: Double
        let radius: CGFloat
        let offset: CGSize
        let color: UIColor
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            guard let uiview = content.makeUIView(path, hosting: hosting) else { return nil }
            
            uiview.layer.shadowOpacity = Float(opacity)
            uiview.layer.shadowRadius = radius
            uiview.layer.shadowOffset = offset
            uiview.layer.shadowColor = color.cgColor
            
            return uiview
        }
        
    }
    
    struct TransformEffect: ViewModifier {
        
        let content: View
        
        let transform: CGAffineTransform
        
        func transformUIView(_ path: String, hosting: HostingView) -> UIView? {
            guard let uiview = content.transformUIView(path, hosting: hosting) else { return nil }
            
            uiview.transform = uiview.transform.concatenating(transform)
            
            return uiview
        }
        
    }
    
    // Text
    
    struct Font: ViewModifier {
        
        let content: View
        
        let value: UIFont
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            let uiview = content.makeUIView(path, hosting: hosting)
            
            if let view = uiview as? UILabel {
                view.font = value
            } else if let view = uiview as? UITextField {
                view.font = value
            } else if let view = uiview as? UITextView {
                view.font = value
            }
            
            return uiview
        }
        
    }
    
    struct ForegroundColor: ViewModifier {
        
        let content: View
        
        let color: UIColor
        let highlightedColor: UIColor?
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            let uiview = content.makeUIView(path, hosting: hosting)
            
            if let view = uiview as? UILabel {
                view.textColor = color
                view.highlightedTextColor = highlightedColor
            } else if let view = uiview as? UITextField {
                view.textColor = color
            } else if let view = uiview as? UITextView {
                view.textColor = color
            }
            
            return uiview
        }
        
    }
    
    struct LineLimit: ViewModifier {
        
        let content: View
        
        let value: Int
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            guard let uiview = content.makeUIView(path, hosting: hosting) as? UILabel else { return nil }
            
            uiview.numberOfLines = value
            
            return uiview
        }
        
    }
    
    struct MultilineTextAlignment: ViewModifier {
        
        let content: View
        
        let value: NSTextAlignment
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            let uiview = content.makeUIView(path, hosting: hosting)
            
            if let view = uiview as? UILabel {
                view.textAlignment = value
            } else if let view = uiview as? UITextField {
                view.textAlignment = value
            } else if let view = uiview as? UITextView {
                view.textAlignment = value
            }
            
            return uiview
        }
        
    }
    
    struct MinimumScaleFactor: ViewModifier {
        
        let content: View
        
        let value: CGFloat
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            guard let uiview = content.makeUIView(path, hosting: hosting) as? UILabel else { return nil }
            
            uiview.minimumScaleFactor = value
            uiview.adjustsFontSizeToFitWidth = value < 1.0
            
            return uiview
        }
        
    }
    
    // Image & Shape
    
    struct Resizable: ViewModifier {
        
        let content: View
        
        var flexibility: (horizontal: ViewFlexibility, vertical: ViewFlexibility) {
            return (.high, .high)
        }
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            guard let uiview = content.makeUIView(path, hosting: hosting) else { return nil }
            
            uiview.contentMode = .scaleToFill
            
            return uiview
        }
        
        func measureUIView(_ path: String, proposedSize: CGSize, hosting: HostingView) -> UIView? {
            guard let uiview = content.measureUIView(path, proposedSize: proposedSize, hosting: hosting) else { return nil }
            
            uiview.frame.size = proposedSize
            
            return uiview
        }
        
    }
    
    struct ScaledToFill: ViewModifier {
        
        let content: View
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            guard let uiview = content.makeUIView(path, hosting: hosting) else { return nil }
            
            uiview.contentMode = .scaleAspectFill
            
            return uiview
        }
        
    }
    
    struct ScaledToFit: ViewModifier {
        
        let content: View
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            guard let uiview = content.makeUIView(path, hosting: hosting) else { return nil }
            
            uiview.contentMode = .scaleAspectFit
            
            return uiview
        }
        
    }
    
    struct AspectRatio: ViewModifier {
        
        let content: View
        
        let value: CGFloat
        
        var flexibility: (horizontal: ViewFlexibility, vertical: ViewFlexibility) {
            if value >= 1.0 {
                return (.high, .low)
            } else if value > 0.0 {
                return (.low, .high)
            }
            
            return (.high, .high)
        }
        
        func measureUIView(_ path: String, proposedSize: CGSize, hosting: HostingView) -> UIView? {
            guard let uiview = content.measureUIView(path, proposedSize: proposedSize, hosting: hosting) else { return nil }
            
            if value >= 1.0 {
                uiview.frame.size.height = uiview.frame.size.width / value
            } else if value > 0.0 {
                uiview.frame.size.width = uiview.frame.size.height * value
            }
            
            return uiview
        }
        
    }
    
    // Shape only
    
    struct Fill: ViewModifier {
        
        let content: View
        
        let value: UIColor
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            guard let uiview = content.makeUIView(path, hosting: hosting) as? ShapeView else { return nil }
            
            uiview.fill = value
            uiview.setNeedsDisplay()
            
            return uiview
        }
        
    }
    
    struct Stroke: ViewModifier {
        
        let content: View
        
        let value: UIColor
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            guard let uiview = content.makeUIView(path, hosting: hosting) as? ShapeView else { return nil }
            
            uiview.stroke = value
            uiview.setNeedsDisplay()
            
            return uiview
        }
        
    }
    
    struct LineWidth: ViewModifier {
        
        let content: View
        
        let value: CGFloat
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            guard let uiview = content.makeUIView(path, hosting: hosting) as? ShapeView else { return nil }
            
            uiview.path.lineWidth = value
            uiview.setNeedsDisplay()
            
            return uiview
        }
        
    }
    
    // Controls
    
    struct Target: ViewModifier {
        
        let content: View

        weak var target: AnyObject? = nil
        let action: Selector
        let event: UIControl.Event
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            guard let uiview = content.makeUIView(path, hosting: hosting) else { return nil }
            
            (uiview as? UIControl)?.addTarget(target, action: action, for: event)
            
            return uiview
        }
        
    }
    
    struct Disabled: ViewModifier {
        
        let content: View
        
        let value: Bool
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            guard let uiview = content.makeUIView(path, hosting: hosting) else { return nil }
            
            (uiview as? UIControl)?.isEnabled = !value
            
            return uiview
        }
        
    }
    
    struct Keyboard: ViewModifier {
        
        let content: View
        
        let type: UIKeyboardType
        let appearance: UIKeyboardAppearance
        let returnKeyType: UIReturnKeyType
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            let uiview = content.makeUIView(path, hosting: hosting)
            
            if let view = uiview as? UITextField {
                view.keyboardType = type
                view.keyboardAppearance = appearance
                view.returnKeyType = returnKeyType
            } else if let view = uiview as? UITextView {
                view.keyboardType = type
                view.keyboardAppearance = appearance
                view.returnKeyType = returnKeyType
            }
            
            return uiview
        }
        
    }
    
    // Scroll
    
    struct ScrollInsets: ViewModifier {
        
        let content: View
        
        let contentInset: UIEdgeInsets
        let indicatorInsets: UIEdgeInsets
        
        let insetReference: ScrollInsetReference
        
        func measureUIView(_ path: String, proposedSize: CGSize, hosting: HostingView) -> UIView? {
            guard let uiview = queryUIView(path, hosting: hosting) as? UIScrollView else { return nil }
            
            switch insetReference {
            case .safeArea(let top, let leading, let bottom, let trailing):
                let sat = top ? hosting.safeAreaInsets.top : 0.0
                uiview.contentInset.top = contentInset.top + sat
                uiview.scrollIndicatorInsets.top = indicatorInsets.top + sat
                
                let sal = leading ? hosting.safeAreaInsets.left : 0.0
                uiview.contentInset.left = contentInset.left + sal
                uiview.scrollIndicatorInsets.left = indicatorInsets.left + sal
                
                let sab = bottom ? hosting.safeAreaInsets.bottom : 0.0
                uiview.contentInset.bottom = contentInset.bottom + sab
                uiview.scrollIndicatorInsets.bottom = indicatorInsets.bottom + sab
                
                let sar = trailing ? hosting.safeAreaInsets.right : 0.0
                uiview.contentInset.right = contentInset.right + sar
                uiview.scrollIndicatorInsets.right = indicatorInsets.right + sar
            default:
                uiview.contentInset = contentInset
                uiview.scrollIndicatorInsets = indicatorInsets
            }
            
            return content.measureUIView(path, proposedSize: proposedSize, hosting: hosting)
        }
        
    }
    
    struct ScrollPaging: ViewModifier {
        
        let content: View
        
        let paging: Bool
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            guard let uiview = content.makeUIView(path, hosting: hosting) as? UIScrollView else { return nil }
            
            uiview.isPagingEnabled = paging
            
            return uiview
        }
        
    }
    
    // Gestures
    
    struct Gesture: ViewModifier {
        
        let content: View
        
        let gesture: UIGestureRecognizer
        
        func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
            guard let uiview = content.makeUIView(path, hosting: hosting) else { return nil }
            
            uiview.addGestureRecognizer(gesture)
            
            return uiview
        }
        
    }
    
}
