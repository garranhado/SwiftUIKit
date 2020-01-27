import Foundation

class ObservableObject {
    
    private class ObserverSelector {
        
        var selector: Selector = #selector(doNothing)
        
        @objc func doNothing() { }
        
    }
    
    private var observers: NSMapTable<AnyObject, ObserverSelector> = NSMapTable.weakToStrongObjects()
    
    deinit {
        observers.removeAllObjects()
    }
    
    func subscribe(_ observer: AnyObject, selector: Selector) {
        let os = ObserverSelector()
        os.selector = selector
        
        observers.setObject(os, forKey: observer)
    }
    
    func unsubscribe(_ observer: AnyObject) {
        observers.removeObject(forKey: observer)
    }
    
    func didChange() {
        for k in observers.keyEnumerator().allObjects {
            let o = k as AnyObject
            let os = observers.object(forKey: o)
            _ = o.perform(os?.selector)
        }
    }
    
}

// MARK: - Utils -

extension ObservableObject {
    
    func notify(_ observer: AnyObject) {
        let os = observers.object(forKey: observer)
        _ = observer.perform(os?.selector)
    }
    
}
