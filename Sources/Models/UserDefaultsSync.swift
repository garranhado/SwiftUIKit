import Foundation

class UserDefaultsSync: ObservableObject {
    
    static let shared: UserDefaultsSync = UserDefaultsSync()
    
    func prepare() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateFromCloud), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateToCloud), name: UserDefaults.didChangeNotification, object: nil)
        
        NSUbiquitousKeyValueStore.default.synchronize()
    }
 
    @objc func updateToCloud() {
        let local = UserDefaults.standard.dictionary(forKey: "sync") ?? [:]
        
        let remote = NSUbiquitousKeyValueStore.default
        for kvp in local {
            remote.set(kvp.value, forKey: kvp.key)
        }
        remote.synchronize()
        
        DispatchQueue.main.async {
            self.didChange()
        }
    }
    
    @objc func updateFromCloud() {
        NotificationCenter.default.removeObserver(self, name: UserDefaults.didChangeNotification, object: nil)
        
        let remote = NSUbiquitousKeyValueStore.default.dictionaryRepresentation
        
        let local = UserDefaults.standard
        local.set(remote, forKey: "sync")
        local.synchronize()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateToCloud), name: UserDefaults.didChangeNotification, object: nil)
        
        DispatchQueue.main.async {
            self.didChange()
        }
    }
    
}
