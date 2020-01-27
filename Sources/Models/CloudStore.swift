import Foundation
import UIKit
import CloudKit

class CloudStore: ObservableObject {
    
    struct Item {
        
        let id: String?
        let lastUpdate: Date?
                
        let content: [CKRecord.FieldKey: CKRecordValueProtocol]
        
    }
    
    static let shared: CloudStore = CloudStore()
    
    // MARK: - Functions
    
    func fetch(collection: String, desiredKeys: [String]? = nil, completion: @escaping ([Item]) -> Void) {
        var items: [Item] = []
        
        let database = CKContainer.default().privateCloudDatabase
        
        let query = CKQuery(recordType: collection, predicate: NSPredicate(value: true))
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = desiredKeys
        
        let recordFetchedBlock = { (record: CKRecord) in
            var content: [CKRecord.FieldKey: CKRecordValueProtocol] = [:]
            for k in record.allKeys() {
                content[k] = record[k]
            }
            
            items.append(Item(id: record.recordID.recordName,
                              lastUpdate: record.modificationDate,
                              content: content))
        }
        
        let queryCompletionBlock = { (cursor: CKQueryOperation.Cursor?, error: Error?) in
            if error != nil {
                DispatchQueue.main.async {
                    completion([])
                }
            } else if let cursor = cursor {
                let newOperation = CKQueryOperation(cursor: cursor)
                newOperation.desiredKeys = queryOperation.desiredKeys
                newOperation.recordFetchedBlock = queryOperation.recordFetchedBlock
                newOperation.queryCompletionBlock = queryOperation.queryCompletionBlock
                database.add(newOperation)
            } else {
                DispatchQueue.main.async {
                    completion(items)
                }
            }
        }
        
        queryOperation.recordFetchedBlock = recordFetchedBlock
        queryOperation.queryCompletionBlock = queryCompletionBlock
        
        database.add(queryOperation)
    }
    
    func fetchItem(withItemId id: String, completion: @escaping (Item?) -> Void) {
        let database = CKContainer.default().privateCloudDatabase
        
        database.fetch(withRecordID: CKRecord.ID(recordName: id)) { record, error in
            if error == nil, let record = record {
                var content: [CKRecord.FieldKey: CKRecordValueProtocol] = [:]
                for k in record.allKeys() {
                    content[k] = record[k]
                }
                
                DispatchQueue.main.async {
                    completion(Item(id: record.recordID.recordName,
                                    lastUpdate: record.modificationDate,
                                    content: content))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func save(item: Item, inCollection collection: String) {
        let database = CKContainer.default().privateCloudDatabase
        
        let record = CKRecord(recordType: collection)
        for kvp in item.content {
            record[kvp.key] = kvp.value
        }
        
        database.save(record) { _, _ in }
    }
    
    func delete(withItemId id: String) {
        let database = CKContainer.default().privateCloudDatabase
        database.delete(withRecordID: CKRecord.ID(recordName: id)) { _, _ in }
    }
    
    // MARK: - Notifications
    
    func subscribe(collection: String, completion: @escaping (String?) -> Void) {
        let database = CKContainer.default().privateCloudDatabase
        
        let subscription = CKQuerySubscription(recordType: collection, predicate: NSPredicate(value: true), options: [.firesOnRecordCreation, .firesOnRecordUpdate, .firesOnRecordDeletion])
        database.save(subscription) { subscription, error in
            if error == nil, let subscription = subscription {
                DispatchQueue.main.async {
                    completion(subscription.subscriptionID)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func unsubscribe(subscriptionId: String) {
        let database = CKContainer.default().privateCloudDatabase
        database.delete(withSubscriptionID: subscriptionId) { _, _ in }
    }
    
    /*
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DataStoreSync.shared.prepareForNotifications()
        return true
    }
 
     */
    
    func prepareForNotifications() {
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    /*
     
     func application(_ application: UIApplication,
                      didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                      fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
         DataStoreSync.shared.handleNotification(userInfo: userInfo)
         completionHandler(.newData)
     }
     
     */
    func handleNotification(userInfo: [AnyHashable : Any]) {
        guard CKQueryNotification(fromRemoteNotificationDictionary: userInfo) != nil else {
            return
        }
        
        DispatchQueue.main.async {
            self.didChange()
        }
    }
    
}
