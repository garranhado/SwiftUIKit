import UIKit

struct IfElse: ViewContainer {

    let content: [View]

    init(_ conditional: Bool, trueContent: () -> View?, falseContent: () -> View?) {
        if conditional {
            if let v = trueContent() {
                self.content = [v]
            } else {
                self.content = []
            }
        } else {
            if let v = falseContent() {
                self.content = [v]
            } else {
                self.content = []
            }
        }
    }
    
}
