//
//  UpdateEmpReportEndpoint.swift
//  clock2go2020
//
//  Created by Admin on 3/23/20.
//

import Alamofire

extension Encodable {

    var dict : [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return nil }
        return json
    }
}

class UpdateDailyStudentReportEndpoint: EndpointItem {

    var studentDataArr = [Studentsdata]()
    
    init(obj: [Studentsdata]) {
        self.studentDataArr = obj
        super.init(endpointType: .setStudentAction)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()
        dict["clientId"] = UserDefaultsManager.clientId ?? 0
        dict["entryEditTime"] = self.getCurrentDateString()
        
        var studentData = [[String: Any]]()
        
        if self.studentDataArr.count > 0{
            let filterArr = self.studentDataArr.filter({$0.isUpdateRecrod == true})
            for item in filterArr{
                var tempDict = [String: Any]()
                
                var scoreRYG = String()
                
                if let score = item.scoreRYG{
                    if score.R! == 1{
                        scoreRYG = "R"
                    }else if score.Y! == 1{
                        scoreRYG = "Y"
                    }else if score.G! == 1{
                        scoreRYG = "G"
                    }
                }
                
                var transTIme = String()
                if let currentDateTime = item.trnsInCoordinator, currentDateTime.count > 0{
                    transTIme = currentDateTime
                }else{
                    transTIme = item.trnsTime ?? ""
                }
                
                tempDict = [
                    "presenceConfirmation": item.presenceConfirmation ?? 0,
                    "TransID": item.TransId ?? 0,
                    "TrnsTime": transTIme,
//                    "trnsInCoordinator": item.trnsInCoordinator ?? "",
                    "scoreRYG": scoreRYG,
                    "comment": item.comment ?? "",
                    "WorkScheduleID": item.WorkScheduleID ?? 0
                ]
                studentData.append(tempDict)
            }
        }
        dict["studentdata"] = studentData
        return dict
    }

    func apiCall(handler: @escaping (_ response: [String: EmpDayReportsObj]?, _ error: ErrorObject?) -> Void) {
        print("convertToDictionary() : \n", convertToDictionary())
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: EmpUpdateReportsResult?, error: ErrorObject?) in
            handler(response?.data, error)
        }
    }
    
    func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let result = formatter.string(from: date)

        return result
    }
}
