//
//  AbsenceObj.swift
//  clock2go2020
//
//  Created by Admin on 2/12/20.
//

import UIKit

class AbsenceObj {
    var type: AbsenceTypeEntity?
    var fromDate = Date()
    var toDate = Date()
    var attachedFiles: [MediaObj] = []
    var remark: String?
}
