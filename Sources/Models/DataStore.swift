import CoreData

class DataStore: ObservableObject {
    
    static let shared: DataStore = DataStore()
    
    private var container: NSPersistentContainer!
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    // MARK: - Functions
    
    func prepare(name: String = "DataStore", sync: Bool = false, configure: ((NSPersistentStoreDescription) -> Void)? = nil) {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        
        if sync {
            if #available(iOS 13.0, tvOS 13.0, *) {
                container = NSPersistentCloudKitContainer(name: name)
            } else {
                container = NSPersistentContainer(name: name)
            }
        } else {
            container = NSPersistentContainer(name: name)
        }
        
        container.loadPersistentStores() { [weak self] (storeDescription, error) in
            guard let self = self else { return }
            
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            } else {
                DispatchQueue.main.async {
                    if sync {
                        self.container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                        self.container.viewContext.automaticallyMergesChangesFromParent = true
                        
                        if #available(iOS 13.0, tvOS 13.0, *) {
                            storeDescription.setOption(NSNumber(value: true), forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
                            
                            NotificationCenter.default.addObserver(self, selector: #selector(self.persistentStoreRemoteChange), name: .NSPersistentStoreRemoteChange, object: nil)
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    
                    configure?(storeDescription)
                }
            }
        }
    }
    
    func commit() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchRequestTemplate(forName name: String) -> NSFetchRequest<NSFetchRequestResult>? {
        return container.managedObjectModel.fetchRequestTemplate(forName: name)
    }
    
    // MARK: - Notifications
    
    @objc func persistentStoreRemoteChange() {
        DispatchQueue.main.async {
            self.didChange()
        }
    }
    
}
