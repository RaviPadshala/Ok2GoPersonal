//
//  SearchTaskViewModel.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 25.08.2022.
//

import UIKit

class SearchTaskViewModel {
    let titleString: String = "TASK_SEARCH".localized
    let confirmButtonTitle: String = "SEARCH".localized
    let cancelButtonTitle: String = "CANCEL".localized
    let insuredIdString: String = "INSURED_ID".localized
    private(set) var searchButtonAlpha: CGFloat = 0.5
    private(set) var searchButtonEnabled: Bool = false
    
    private var searchString: String = ""
    
    func canEnterMore(_ string: String) -> Bool {
        return string.count <= 9
    }
    
    func didChangeSearchString(_ searchString: String) {
        self.searchString = searchString
        if searchString.count >= 6 && searchString.count <= 9 {
            makeSearchButtonEnabled()
        } else {
            makeSearchButtonDisabled()
        }
    }
    
    func searchTask(_ completion: @escaping ((TaskObj?, ErrorObject?) -> ())) {
        let searchEndpoint = SearchTaskEndpoint(searchString)
        searchEndpoint.apiCall { response, error in
            if let searchedTask = response?.data {
                let task = TaskObj(taskId: "\(searchedTask.taskId)", taskName: searchedTask.taskName, projectId: searchedTask.projectId, projectName: searchedTask.projectName, remark: nil, hoursLimit: nil, hoursCompleted: nil, distanceSettings: nil, fromTime: nil, toTime: nil)
                completion(task, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    private func makeSearchButtonEnabled() {
        searchButtonAlpha = 1.0
        searchButtonEnabled = true
    }
    
    private func makeSearchButtonDisabled() {
        searchButtonAlpha = 0.5
        searchButtonEnabled = false
    }
}
