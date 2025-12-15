//
//  ApproveHourEditScreenModel.swift
//  clock2go2020
//
//  Created by Mac on 19/03/24.
//

import Foundation

import UIKit
class ApproveHoursEditModel {
   
    
    let loadingView = LoadingView()
    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }
    
    func sentHoursApproved(hourId : Int?,hoursApproved : Int?,completion : @escaping((Bool,ErrorObject?)->())){
        vc?.view.addSubview(loadingView)
        
       
        
        let sentHourApprovedEndpoint = SentHoursApprovedEndpoint(hourId: hourId, hourApproved: hoursApproved)
        sentHourApprovedEndpoint.apiCall { (result, error) in
            self.loadingView.removeFromSuperview()
            
            if error?.success ?? false {
                        completion(true,nil)
            } else {
                completion(false,error)
            }
        }
    }
    
    
}
