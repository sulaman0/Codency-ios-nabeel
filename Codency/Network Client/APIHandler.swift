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
    
    private var baseUrl: String = ""
    
    var session = URLSession(configuration: .ephemeral)
    var decoder = JSONDecoder()
    
    /**
     * Return an APIError value for the error code in the response. This will
     * always return a value even if no matching error value is defined (meaning
     * the enumeration is out of date) - in this case APIError.unmapped.
     */
    func makeError(_ response: APIResponse) -> APIError {
        var err = APIError(rawValue: response.status!)
        return err!
    }
    
    /**
     * Post to the specified path. The completion handler is called on the main
     * queue.
     */
    func post<T>(_ path: String, _ argsFixed: [String: Any]) async -> (T?, APIError?) where T: APIResponse {
        let url = URL(string: baseUrl + path)!
        //        var request = URLRequest(url: url, timeoutInterval: 20)
        
        var args: [String: Any] = [:]
        args += argsFixed
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        print("API call(header): \(url)")
        print("API Call(Body): \(String(data: try! JSONSerialization.data(withJSONObject: args, options: .prettyPrinted), encoding: .utf8 )!)")
        return await withCheckedContinuation { continuation in
            let task = session.dataTask(with: request) { data1, response, error in
                DispatchQueue.main.async {[weak self] in
                    guard let self1 = self else { return }
                    
                    if let error = error {
                        print("API call to '\(url)' failed with error: \(error)")
                        continuation.resume(returning: (nil, APIError.local))
                    }
                    else {
                        do {
                            var response = try self1.decoder.decode(T.self, from: data1!)
                            print("API Call(Response): \(response)")
                            if var genProp = response as? GeneratedProperties {
                                /* As we're working with value types here any assignment
                                 * (even a cast) creates a copy, so we must copy the
                                 * generated copy back to response. */
                                genProp.generateProperties()
                                response = genProp as! T
                            }
                            continuation.resume(returning: (response, nil))
                        }
                        catch {
                            print("Error handling response from API call '\(url)': \(error)")
                            continuation.resume(returning: (nil, APIError.local))
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
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
