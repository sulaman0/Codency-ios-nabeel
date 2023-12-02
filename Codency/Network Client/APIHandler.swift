//
//  APIHandler.swift
//  Codency
//
//  Created by Nabeel Nazir on 27/11/2023.
//

import Foundation

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
    func post<T: Codable>(_ path: String, _ argsFixed:[String: Any]!) async throws -> BaseResponse<T> {
        let url = URL(string: baseUrl + path)!
        var args: [String: Any] = [:]
        if argsFixed != nil {
            args += argsFixed!
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = getAPIHeaders()
        request.httpBody = try? JSONSerialization.data(withJSONObject: args,
                                                      options: [])
        
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
        [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "http-x-lang": "en"
        ]
    }
    
    func login(with email: String, password: String) async throws -> BaseResponse<User>?  {
        return try await post(EndPoint.login.rawValue,
                              ["email": email,
                               "password": password])
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
