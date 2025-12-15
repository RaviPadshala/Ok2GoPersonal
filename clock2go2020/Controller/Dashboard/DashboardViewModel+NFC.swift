//
//  DashboardViewModel+NFC.swift
//  clock2go2020
//
//  Created by Mac on 16/03/24.
//

import Foundation
import CoreLocation

extension DashboardViewModel{
    
    
    
    private func parseCoordinates(from position: String) -> (latitude: Double, longitude: Double)? {
        let components = position.split(separator: ",")
        guard components.count == 2,
              let latitude = Double(components[0].description),
              let longitude = Double(components[1].description) else {
            return nil
        }
        return (latitude, longitude)
    }
    
    private func showErrorAndRemoveLoadingView(_ message: String) {
        self.delegate?.shouldShowErrorForNFC(message, title: nil)
        self.loadingView.removeFromSuperview()
    }
}
extension String{
    var isDouble: Bool { return Double(self) != nil }
}
