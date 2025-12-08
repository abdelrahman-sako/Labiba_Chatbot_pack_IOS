import Foundation
import SystemConfiguration

final class ReachabilityObserver {
    static let shared = ReachabilityObserver()
    
    private var timer: Timer?
    private(set) var isConnected: Bool = false {
        didSet {
            guard oldValue != isConnected else { return }
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: ReachabilityObserver.statusDidChangeNotification,
                    object: nil,
                    userInfo: ["isConnected": self.isConnected]
                )
                self.onStatusChange?(self.isConnected)
            }
        }
    }
    
    static let statusDidChangeNotification = Notification.Name("ReachabilityStatusDidChange")
    var onStatusChange: ((Bool) -> Void)?
    
    private init() {}
    
    func startMonitoring(interval: TimeInterval = 5.0) {
        // Check immediately and then every few seconds
        checkReachability()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.checkReachability()
        }
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
    
    private func checkReachability() {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let reachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            isConnected = false
            return
        }
        
        var flags = SCNetworkReachabilityFlags()
        if SCNetworkReachabilityGetFlags(reachability, &flags) {
            isConnected = flags.contains(.reachable) && !flags.contains(.connectionRequired)
        } else {
            isConnected = false
        }
    }
}
