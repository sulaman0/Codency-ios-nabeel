//
//  ArrayExtension.swift
//  Codency
//
//  Created by Nabeel Nazir on 09/12/2023.
//

import Foundation

extension Array {
    public func isLastCell(index: Int) -> Bool {
        index == 0 ? false : (index == count - 1 /*&& isInternetConnected*/)
    }
}
