//
//  APITypes.swift
//  Codency
//
//  Created by Nabeel Nazir on 27/11/2023.
//

import Foundation
enum APIError: Error {
    case serverError(String)
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

struct AlarmResponse: Codable {
    var data: [Alarm]?
    var meta: Meta?
}

struct Alarm: Codable {
    var id: Int?
    var name: String?
    var ecg_code: String?
    var ecg_color_code: String?
    var details: AlarmDetail?
    var responded_action: String?
    var should_show_action_btn: Bool?
}

struct AlarmDetail: Codable {
    var location: GenericDetail?
    var alarm_by: GenericDetail?
    var alarm_triggered_at: GenericDetail?
}

struct GenericDetail: Codable {
    var name: String?
    var value: String?
}
