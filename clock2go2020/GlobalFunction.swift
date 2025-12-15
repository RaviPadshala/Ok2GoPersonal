//
//  GlobalFunction.swift
//  clock2go2020
//
//  Created by Mac on 29/11/24.
//

import Foundation
import CoreTelephony
import Network


func isAirplaneModeOn() -> Bool {
    let networkInfo = CTTelephonyNetworkInfo()
    
    // Get the current carrier information (it will be nil if airplane mode is on)
    if networkInfo.currentRadioAccessTechnology == nil {
        return true  // Airplane mode is likely on
    } else {
        return false // Airplane mode is off
    }
}

func isAirplaneModeOn(completion: @escaping (Bool) -> Void) {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    monitor.pathUpdateHandler = { path in
        // Check if the device has a cellular or Wi-Fi connection
        if path.status == .unsatisfied {
            // No connection, possibly airplane mode is on
            completion(true)
        } else {
            // Connection is available, airplane mode is likely off
            completion(false)
        }
    }
    
    monitor.start(queue: queue)
}
