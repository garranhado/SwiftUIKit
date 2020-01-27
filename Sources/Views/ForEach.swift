import UIKit

struct ForEach: ViewContainer {

    let content: [View]

    init(_ data: Range<Int>, content: (Int) -> View) {
        var views: [View] = []

        for i in data {
            views.append(content(i))
        }
        
        self.content = views
    }

    init<T>(_ data: [T], content: (T) -> View) {
        var views: [View] = []

        for i in data {
            views.append(content(i))
        }
        
        self.content = views
    }

}
