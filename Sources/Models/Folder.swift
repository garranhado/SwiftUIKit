import Foundation

class Folder: ObservableObject {
    
    static var document: Folder {
        return Folder(url: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)
    }
    
    static var library: Folder {
        return Folder(url: FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first)
    }
    
    static var applicationSupport: Folder {
        return Folder(url: FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first)
    }
    
    static var caches: Folder {
        return Folder(url: FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first)
    }
    
    var folderURL: URL? = nil
    
    var extensions: [String] = []
    var shouldSortContents: Bool = false
    
    var contents: [URL] = []
    
    var dispatchQueue = DispatchQueue.global()
    var dispatchSource: DispatchSourceFileSystemObject? = nil
    
    weak var eventTimer: Timer? = nil
    
    // MARK: - Initialization
    
    init(url: URL?) {
        folderURL = url
    }
    
    // MARK: - Functions
    
    func synchronize() {
        guard let folder = folderURL else { return }
        guard let contents = try? FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsHiddenFiles]) else { return }
        
        if extensions.isEmpty {
            self.contents = contents
        } else {
            self.contents = contents.filter { extensions.contains($0.pathExtension.lowercased()) }
        }
        
        if shouldSortContents {
            self.contents.sort { $0.lastPathComponent.lowercased() < $1.lastPathComponent.lowercased() }
        }
    }
    
    func startWatching() {
        guard dispatchSource == nil else { return }
        guard let folder = folderURL else { return }
        
        let descriptor = open(folder.path, O_EVTONLY)
        guard descriptor != -1 else { return }
        
        dispatchSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: descriptor, eventMask: .write, queue: dispatchQueue)
        
        guard let dispatchSource = dispatchSource else { return }
        
        dispatchSource.setEventHandler {
            [weak self] in
            DispatchQueue.main.async {
                self?.scheduleContentsDidChange()
            }
        }
        
        dispatchSource.setCancelHandler() {
            close(descriptor)
        }
        
        dispatchSource.resume()
    }
    
    func stopWatching() {
        eventTimer?.invalidate()
        
        dispatchSource?.cancel()
        dispatchSource = nil
    }
    
    func scheduleContentsDidChange() {
        eventTimer?.invalidate()
        eventTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(contentsDidChange), userInfo: nil, repeats: false)
    }
    
    @objc func contentsDidChange() {
        synchronize()
        didChange()
    }
    
    func performUpdates(_ updates: () -> Void) {
        eventTimer?.invalidate()
        
        let watching = dispatchSource != nil
        
        if watching {
            stopWatching()
        }
        
        updates()
        
        if watching {
            startWatching()
        }
    }
    
}

