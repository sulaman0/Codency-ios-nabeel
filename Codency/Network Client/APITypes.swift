//
//  APITypes.swift
//  Codency
//
//  Created by Nabeel Nazir on 27/11/2023.
//

import Foundation
enum APIError: String, Error {
    case local = "0"
    case unknown
    case parsingError
}

/* Response types. */
public class BaseResponse<T: Codable>: Codable {
    var status: Bool?
    var message: String?
    
    var payload: T?
}

struct EmptyResponse: Codable {
    var message: String?
    var status: Bool?
}


struct User: Codable {
    var name: String?
    var email: String?
    var designation: String?
    var location: String?
    var phone: String?
    var token: String?
}


