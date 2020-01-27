import Foundation

extension Date {
    
    func hasExpired(in interval: TimeInterval) -> Bool {
        return Date(timeIntervalSinceNow:-interval) > self
    }
    
}
