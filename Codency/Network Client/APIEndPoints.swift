//
//  APIEndPoints.swift
//  Codency
//
//  Created by Nabeel Nazir on 02/12/2023.
//

import Foundation

enum EndPoint: String {
    case login = "login"
    case resetPassword = "request-reset-password"
    case verifyResetPassword = "verify-reset-password-code"
    case updatePassword = "update-password"
    case emergencyCodes = "ecg/codes"
    case alert = "ecg/alerts"
    case emergencyCodeList = "ecg-codes-list"
    case users = "users-list"
}
