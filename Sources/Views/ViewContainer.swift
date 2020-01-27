import UIKit

protocol ViewContainer: View {
    
    var content: [View] { get }
    
}

enum ViewAlignment {
    case bottom
    case bottomLeading
    case bottomTrailing
    case center
    case leading
    case top
    case topLeading
    case topTrailing
    case trailing
}

enum ViewHAlignment {
    case leading
    case center
    case trailing
}

enum ViewVAlignment {
    case top
    case center
    case bottom
}

@_functionBuilder
struct ViewBuilder {
    
    static func buildBlock(_ content: View) -> View {
        return content
    }
    
    static func buildBlock(_ content: View...) -> [View] {
        return content
    }
    
}
