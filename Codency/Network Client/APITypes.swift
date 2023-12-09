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

struct UserData: Codable {
    var user: User?
    var token: String?
}

struct User: Codable {
    var name: String?
    var email: String?
    var designation: String?
    var location: String?
    var phone: String?
}

struct VerifyCode: Codable {
    var token: String?
}

struct EmergencyCodeResponse: Codable {
    var data: [EmergencyCode]?
    var meta: Meta?
}

struct EmergencyCode: Codable {
    var id: Int?
    var serial_no: Int?
    var name: String?
    var code: String?
    var clr_code: String?
}

struct Meta: Codable {
    var total_records: Int?
    var current_records: Int?
    var per_page: Int?
    var current_page: Int?
    var total_pages: Int?
    var next_page: String?
    var previous_page: String?
    var is_last_page: Bool?
    var query_strings: String?
    
    var shouldCallAPI: Bool? {
        get {
            !(is_last_page ?? false)
        }
    }
}
