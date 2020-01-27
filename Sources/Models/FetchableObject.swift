import Foundation

class FetchableObject: ObservableObject {
    
    var isFetching: Bool = false
    var error: Error? = nil
    
    var lastUpdate: Date? = nil
    var expirationDate: Date? = nil
    
    func synchronize() { }
    
    // Subclass should call super before fetch
    @objc func fetch() {
        isFetching = true
        didChange()
    }
    
    // Subclass should call super before cancel fetch
    func cancelFetch() {
        isFetching = false
        didChange()
    }
    
}

// MARK: - Functions -

extension FetchableObject {
    
    // Subclass should call after synchronize / fetch finished
    func finishFetch(_ error: Swift.Error? = nil) {
        isFetching = false
        
        self.error = error
        
        if error == nil {
            lastUpdate = Date()
        }
        
        didChange()
    }
    
}
