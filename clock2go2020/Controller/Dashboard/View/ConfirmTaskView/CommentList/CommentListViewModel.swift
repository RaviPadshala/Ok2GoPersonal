//
//  CommentListViewModel.swift
//  clock2go2020
//
//  Created by MacPro4 on 24.04.2021.
//

import Foundation

enum CommentListType: CaseIterable {
    case listOnEntry
    case listOnExit
}

class CommentListViewModel {

    var commentArray: [Int]?

    init(type: CommentListType) {
        getCommentList(type: type)
    }

    func getCommentList(type: CommentListType ) {
        switch type {
        case .listOnEntry:
            guard let items = CompaniesDataManager.shared.getAppCommentListOnEntry() else {
                return
            }
            commentArray = addItemTocommentList(items: items)

        case .listOnExit:
            guard let items = CompaniesDataManager.shared.getAppCommentListOnExit() else {
                return
            }
            commentArray = addItemTocommentList(items: items)
        }
    }

    func addItemTocommentList(items: [Int]) -> [Int]? {
        var comments: [Int] = []
        for item in items {
            comments.append(item)
        }
        return comments
    }
}
