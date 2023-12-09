//
//  APIHandler.swift
//  Codency
//
//  Created by Nabeel Nazir on 27/11/2023.
//

import Foundation

enum HttpMethod: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
}

class APIHandler {
    /**
     * Shared instance. Before this can be used, configure() must be called.
     */
    static var shared: APIHandler = APIHandler()
    
    private var baseUrl: String = "https://codency.pmitc.com.sa/api/"
    
    var session = URLSession(configuration: .ephemeral)
    var decoder = JSONDecoder()
    
    /**
     * Post to the specified path. The completion handler is called on the main
     * queue.
     */
    func call<T: Codable>(_ path: String,
                          _ argsFixed:[String: Any]? = nil,
                          headers: [String: String]? = nil,
                          method: HttpMethod = .post) async throws -> BaseResponse<T> {
        let url = URL(string: baseUrl + path)!
        var args: [String: Any] = [:]
        if argsFixed != nil {
            args += argsFixed!
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        var apiHeaders = getAPIHeaders()
        if let headers {
            apiHeaders += headers
        }
        request.allHTTPHeaderFields = apiHeaders
        if method == .get {
            
        } else {
            request.httpBody = try? JSONSerialization.data(withJSONObject: args,
                                                           options: [])
        }
        
        print("API call(header): \(url)")
        print("API Call(Body): \(String(data: try! JSONSerialization.data(withJSONObject: args, options: .prettyPrinted), encoding: .utf8 )!)")
        let (data, response) = try await session.data(for: request)
        
        guard let response  = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIError.unknown
        }
        
        do {
            let responseObj = try self.decoder.decode(BaseResponse<T>.self, from: data)
            print("API Call(Response): \(responseObj)")
            return responseObj
        }
        catch {
            print("Error handling response from API call '\(url)': \(error)")
            throw APIError.parsingError
        }
    }
    
    func getAPIHeaders() -> [String: String] {
        var headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "http-x-lang": "en"
        ]
        if UserDefaultsConfig.token.isSome {
            headers["Authorization"] = "Bearer \(UserDefaultsConfig.token!)"
        }
        return headers
    }
    
    //MARK:- Auth
    func login(with email: String, password: String) async throws -> BaseResponse<UserData>?  {
        return try await call(EndPoint.login.rawValue,
                              ["email": email,
                               "password": password])
    }
    
    @discardableResult
    func resetPassword(with email: String) async throws -> BaseResponse<EmptyResponse>?  {
        return try await call(EndPoint.resetPassword.rawValue,
                              ["email": email])
    }
    
    func verifyCode(with email: String, code: String) async throws -> BaseResponse<VerifyCode>?  {
        return try await call(EndPoint.verifyResetPassword.rawValue,
                              ["email": email,
                               "code": code])
    }
    
    func updatePassword(with password: String,
                        confirmPassword: String,
                        token: String) async throws -> BaseResponse<User>?  {
        return try await call(EndPoint.updatePassword.rawValue,
                              ["password": password,
                               "password_confirmation": confirmPassword],
                              headers: ["Authorization": "Bearer \(token)"],
                              method: .put)
    }
    
    //MARK:- Home
    func getEmergencyCodes() async throws -> BaseResponse<EmergencyCodeResponse>?  {
        return try await call(EndPoint.emergencyCodes.rawValue,
                              method: .get)
    }
    
    @discardableResult
    func sendAlert(to codeId: Int) async throws -> BaseResponse<EmptyResponse>?  {
        return try await call(EndPoint.alert.rawValue,
                              ["code_id": codeId],
                              method: .post)
    }
    
    func getAlarmAlerts() async throws -> BaseResponse<AlarmResponse>?  {
        return try await call(EndPoint.alert.rawValue,
                              method: .get)
    }
}

/**
 * Dictionary addition operator.
 */
func += <K, V> (left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left[k] = v
    }
}
