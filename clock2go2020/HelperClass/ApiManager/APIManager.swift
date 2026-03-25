//
//  ApiManager.swift
//  clock2go2020
//
//  Created by Admin on 1/28/20.
//

import Alamofire
import SwiftyJSON
import AnyCodable

enum NetworkEnvironment {
    case production
    case test
    case timeout
    case revacha
    case production_v2
    case vtest
    case verotest
    case production_v3
    case production_v3_01
    case production_v3_25
    case production_v3_25_03
    case production_V3_25_04
    case production_app_01_25_10
    case production_app_01_25_11
    case production_app_01_25_12
    case production_app_01_25_14
    case production_app_01_25_15
    case production_app_01_25_16
    case sandbox
}


class APIManager {

    // MARK: - Vars & Lets
    private var sessionManager: SessionManager
    
    //for developement purpose
    static let networkEnviroment: NetworkEnvironment = .verotest
    
    // For live app
//    static let networkEnviroment: NetworkEnvironment = .production_app_01_25_16
    
    private static var sharedApiManager: APIManager = {
        let apiManager = APIManager(sessionManager: SessionManager())

        return apiManager
    }()
    

    // MARK: - Accessors
    class func shared() -> APIManager {
        return sharedApiManager
    }
    
    // MARK: - Initialization
    
    private init(sessionManager: SessionManager) {
        // self.sessionManager = sessionManager
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        self.sessionManager = Alamofire.SessionManager(configuration: configuration) // not in this line
    }
    
    func call<T>(type: EndPointType, params: Parameters? = nil, body: Data? = nil, disableAuthExpireLogout: Bool = false, handler: @escaping (T?, _ error: ErrorObject?) -> Void) where T: Codable {
        
        if let bodyData = body{
            var urlRequest = try! URLRequest(url: type.url, method: type.httpMethod, headers: type.headers)
            
            urlRequest.httpBody = bodyData
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            print("RAW BODY:", String(data: body ?? Data(), encoding: .utf8) ?? "")
            
            self.sessionManager.request(urlRequest).validate().responseJSON { response in
                self.printLogs(response: response, params: params)
                switch response.result {
                case .success(_):
                    if let error = self.parseApiError(data: response.data), error.error_code == 402 {
                        UserDefaultsManager.udid = nil
                        UserDefaultsManager.phoneNumber = nil
                        NavigationController.shared?.checkRootViewController()
                    }else if let error = self.parseApiError(data: response.data), error.error_code == 602 && !disableAuthExpireLogout {
                        UserDefaultsManager.udid = nil
                        UserDefaultsManager.phoneNumber = nil
                        NavigationController.shared?.showAuthenticationErrorView()
                    } else if let error = self.parseApiError(data: response.data), error.error_code == 502 {
                        NotificationCenter.default.post(name: OfflineModeBecomesActiveNotification, object: error)
                    } else {
                        handler(self.parseApiResult(data: response.data), self.parseApiError(data: response.data))
                    }
                    // self.printLogs(response: response, params: params)
                case .failure(let error):
                    if error.localizedDescription == "cancelled" {
                        handler(nil, ErrorObject(success: false, error_message: "cancelled", error_code: -999))
                    } else {
                        handler(nil, self.parseApiError(data: response.data))
                    }
                }
            }
            
        }else{
            self.sessionManager.request(type.url,
                                        method: type.httpMethod,
                                        parameters: params,
                                        encoding: type.encoding,
                                        headers: type.headers).validate().responseJSON { response in
                self.printLogs(response: response, params: params)
                switch response.result {
                case .success(_):
                    if let error = self.parseApiError(data: response.data), error.error_code == 402 {
                        UserDefaultsManager.udid = nil
                        UserDefaultsManager.phoneNumber = nil
                        NavigationController.shared?.checkRootViewController()
                    }else if let error = self.parseApiError(data: response.data), error.error_code == 602 && !disableAuthExpireLogout {
                        UserDefaultsManager.udid = nil
                        UserDefaultsManager.phoneNumber = nil
                        NavigationController.shared?.showAuthenticationErrorView()
                    } else if let error = self.parseApiError(data: response.data), error.error_code == 502 {
                        NotificationCenter.default.post(name: OfflineModeBecomesActiveNotification, object: error)
                    } else {
                        handler(self.parseApiResult(data: response.data), self.parseApiError(data: response.data))
                    }
                    // self.printLogs(response: response, params: params)
                case .failure(let error):
                    if error.localizedDescription == "cancelled" {
                        handler(nil, ErrorObject(success: false, error_message: "cancelled", error_code: -999))
                    } else {
                        handler(nil, self.parseApiError(data: response.data))
                    }
                }
            }
        }
    }
    
    func call<T>(type: EndPointType, imagesData: [MediaObj?], params: Parameters? = nil, body: Data? = nil, handler: @escaping (T?, _ error: ErrorObject?) -> Void) where T: Codable {
        self.sessionManager.upload(multipartFormData: { (multipartFormData) in
            if let parameters = params {
                do {
                    let data = try JSONSerialization.data(withJSONObject: parameters)
                    multipartFormData.append(data, withName: "json")
                } catch let error {
                    print("Error : \(error.localizedDescription)")
                }
            }else if let bodyData = body {
                multipartFormData.append(bodyData, withName: "json")
            }
            
            for imageData in imagesData {
                if let data = imageData {
                    multipartFormData.append(data.data, withName: "file", fileName: data.filename, mimeType: data.mimeType)
                }
            }
            
        }, to: type.url, method: type.httpMethod, headers: type.headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    self.printLogs(response: response, params: params)
                    handler(self.parseApiResult(data: response.data), self.parseApiError(data: response.data))
                }
            case .failure(let error):
                print("\(error)")
                handler(nil, self.parseApiError(data: error as? Data))
            }
        }
    }
    
    private func parseApiError(data: Data?) -> ErrorObject? {
        if let jsonData = data, let error = try? JSONDecoder().decode(ErrorObject.self, from: jsonData) {
            if error.error_code == NSURLErrorTimedOut {
                // timeout error
                debugPrint("\n\n\n\n TIMEOUT \n\n\n\n")
            }
            return error
        }
        return nil
    }
    
    private func parseApiResult<T>(data: Data?) -> T? where T: Codable {
        if let jsonData = data {
            do {
                let result = try JSONDecoder().decode(T.self, from: jsonData)
                print("result", result)
                return result
            } catch let error {
                print("\n\n\(error)\n\n")
                return nil
            }
        }
        return nil
    }
    
    private func printLogs(response: DataResponse<Any>, params: Parameters?) {
        print("**********************Start*********************")
        print("Request: \(String(describing: response.request))")
        print("RequestHttpBody: \(String(describing: response.request?.httpBody))")
        print("Parameters: \(String(describing: params))")
        print("Response: \(String(describing: response.response))")
        print("Error: \(String(describing: response.error))")
        print("Timeline: \(response.timeline)")
        
        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            print("Data: \(utf8Text)")
        }
        print("**********************End*********************")
    }
    
    func cancelSession() {
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
}
