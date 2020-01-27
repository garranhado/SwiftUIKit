import Foundation
import CommonCrypto

// MARK: - Hash and Crypto

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var MD5: String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        
        if let d = data(using: String.Encoding.utf8) {
            _ = d.withUnsafeBytes { buffer in
                CC_MD5(buffer.baseAddress, CC_LONG(buffer.count), &digest)
            }
        }
        
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
    
}
