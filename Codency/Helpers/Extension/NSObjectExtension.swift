//
//  NSObjectExtension.swift
//  Codency
//
//  Created by Nabeel Nazir on 21/11/2023.
//

import Foundation
extension NSObject {
    public class var className: String {
        return String(describing: self.self)
    }
}
