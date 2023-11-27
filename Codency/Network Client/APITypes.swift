//
//  APITypes.swift
//  Codency
//
//  Created by Nabeel Nazir on 27/11/2023.
//

import Foundation
enum APIError: String {
    case local = "0"
}

protocol GeneratedProperties: Codable {
    /**
     * The API class will automatically make this call on responses from the server.
     */

    mutating func generateProperties()
}

/* Response types. */
protocol APIResponse: Codable {
    var status: String? { get }
    
    var msg_en: String? { get }
    var msg_ar: String? { get }
}

struct EmptyResponse: APIResponse {
    var status: String?
    var msg_en: String?
    var msg_ar: String?
}
