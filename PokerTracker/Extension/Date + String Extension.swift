//
//  Date + String Extension.swift
//  PokerTracker
//
//  Created by VietChat on 9/4/24.
//

import Foundation

extension Date {
    func toString() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}
