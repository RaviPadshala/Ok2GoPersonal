//
//  EventsViewModel.swift
//  clock2go2020
//
//  Created by Gleb on 28.05.2021.
//

import Foundation
import UIKit

class  EventsViewModel {
    
    let client: TaskObj?
    var eventsType: [RevachaEventObj]?
    var eventsName:[String] = []
    var eventsTypeId:[String] = []
    
    weak var delegate: EventsViewModelDelegate?
    
    
    let loadingView = LoadingView()
    var vc: UIViewController? {
        let vc = ViewSource.eventsView()
        self.loadingView.frame = vc.view.frame 
        return vc
    }
    
    init(selectedTask: TaskObj) {
      
        self.client = selectedTask
        self.eventsType = CompaniesDataManager.shared.getEvents()
        self.getEventsType(events: self.eventsType)
        self.delegate?.shouldRefreshView()
    }
    
    private func getEventsType(events: [RevachaEventObj]?) {
        guard let events = events else { return }
        
        var eventsName: [String] = []
        var eventsTypeId: [String] = []
        for evnt in events  {
            eventsName.append(evnt.eventName ?? "")
            eventsTypeId.append(evnt.eventType ?? "")
        }
        self.eventsName = eventsName
        self.eventsTypeId = eventsTypeId
    }
}

protocol EventsViewModelDelegate: NSObjectProtocol {
    func shouldRefreshView()
}
