//
//  OptionalsExtension.swift
//  Codency
//
//  Created by Nabeel Nazir on 27/11/2023.
//

import Foundation
extension Optional {
    var isNone: Bool {
        return self == nil
    }
    var isSome: Bool {
        return self != nil
    }
}
