//
//  ReachabilityObserverDelegate.swift
//  clock2go2020
//
//  Created by Svitlana Davydiuk on 14.08.2020.
//

import Foundation
import Reachability
import Network
import SystemConfiguration

private var reachability: Reachability?

protocol ReachabilityActionDelegate {
    func reachabilityChanged(_ isReachable: Bool)
}

protocol ReachabilityObserverDelegate: AnyObject, ReachabilityActionDelegate {
    func addReachabilityObserver() throws
    func removeReachabilityObserver()
}

// Declaring default implementation of adding/removing observer
extension ReachabilityObserverDelegate {

    /** Subscribe on reachability changing */
    func addReachabilityObserver() throws {
        reachability = try Reachability()

        reachability?.whenReachable = { [weak self] _ in
            self?.reachabilityChanged(true)
        }

        reachability?.whenUnreachable = { [weak self] _ in
            self?.reachabilityChanged(false)
        }

        try reachability?.startNotifier()
    }

    /** Unsubscribe */
    func removeReachabilityObserver() {
        reachability?.stopNotifier()
        reachability = nil
    }
}

final class ReachabilityManager {

    //TODO: change logic of this manager
    var hasInternetConnection: Bool = false

    static let shared = ReachabilityManager()
    let monitor = NWPathMonitor()
    private(set) var isOnline: Bool = false
    
    private init() {}
    
    func start() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isOnline = path.availableInterfaces.count > 0
        }

        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    func checkFlightMode() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return !(isReachable && !needsConnection)
    }

    func isWiFiConnection() -> Bool {
        if reachability?.connection == .wifi {
            return true
        }
        return false
    }
    
    func isCellularConnection() -> Bool {
        if reachability?.connection == .cellular {
            return true
        }
        return false
    }
    
    func isMobileDataDisabled() -> Bool {
        if reachability?.connection == .unavailable {
            return true
        }
        return false
    }
}
