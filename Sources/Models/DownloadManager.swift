import Foundation

class DownloadManager: ObservableObject {
    
    static let shared: DownloadManager = DownloadManager()
    
    let session: URLSession
    
    var downloading: [URL: URLSessionTask] = [:]
    var errors: Set<URL> = []
    
    let folderURL: URL
    
    // MARK: - Initialization
    
    override init() {
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        session = URLSession(configuration: sessionConfiguration)
        
        folderURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("Downloads")
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            try? FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
        }
    }
    
    // MARK: - Functions
    
    func localURL(for url: URL) -> URL {
        let filename = url.absoluteString.MD5
        return folderURL.appendingPathComponent(filename)
    }
    
    func data(for url: URL) -> Data? {
        let dataURL = localURL(for: url)
        return try? Data(contentsOf: dataURL)
    }
    
    func deleteData(for url: URL) {
        cancelDownload(url)
        
        let dataURL = localURL(for: url)
        try? FileManager.default.removeItem(at: dataURL)
    }
    
    func lastUpdate(for url: URL) -> Date? {
        return localURL(for: url).fileLastUpdate
    }
    
    func needsUpdateData(at url: URL, with interval: TimeInterval) -> Bool {
        return lastUpdate(for: url)?.hasExpired(in: interval) ?? true
    }
    
    func download(_ url: URL, force: Bool = false) {
        let sourceURL = url
        
        if !force, downloading[sourceURL] != nil {
            return
        }
        
        cancelDownload(sourceURL)
        
        let dataURL = localURL(for: sourceURL)
        
        let task = session.downloadTask(with: sourceURL) { [weak self] url, response, error in
            guard let self = self else { return }
            
            guard error == nil,
                let r = response as? HTTPURLResponse, r.statusCode == 200,
                let u = url else {
                    self.finishDownload(for: sourceURL, error: true)
                    return
            }
            
            try? FileManager.default.removeItem(at: dataURL)
            try? FileManager.default.copyItem(at: u, to: dataURL)
            
            self.finishDownload(for: sourceURL, error: false)
        }
        
        downloading[sourceURL] = task
        task.resume()
    }
    
    func finishDownload(for url: URL, error: Bool) {
        DispatchQueue.main.async {
            self.downloading.removeValue(forKey: url)
            
            if error {
                self.errors.insert(url)
            }
            
            self.didChange()
        }
    }
    
    func cancelDownload(_ url: URL) {
        guard let task = downloading[url] else { return }
        
        task.cancel()
        downloading.removeValue(forKey: url)
    }
    
    func cancelAllDownloads(_ url: URL) {
        guard !downloading.isEmpty else { return }
        
        let keys = downloading.keys
        
        for k in keys {
            if let task = downloading[k] {
                task.cancel()
                downloading.removeValue(forKey: k)
            }
        }
    }
    
    func clearErrors() {
        errors.removeAll()
    }
    
}
