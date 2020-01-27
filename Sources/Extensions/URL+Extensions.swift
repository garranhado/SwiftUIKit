import Foundation

extension URL {
    
    var displayName: String {
        return deletingPathExtension().lastPathComponent
    }
    
    var fileLastUpdate: Date? {
        guard FileManager.default.fileExists(atPath: path) else { return nil }
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: path) else { return nil }
        
        return attributes[.modificationDate] as? Date
    }
    
}
