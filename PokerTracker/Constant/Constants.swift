//
//  Constants.swift
//  PokerTracker
//
//  Created by VietChat on 10/4/24.
//

import UIKit

extension UIColor {
    
    static func borderColorTF() -> CGColor {
        return UIColor(red: 0.17, green: 0.53, blue: 0.40, alpha: 1.00).cgColor
    }
    
    static func colorTF() -> CGColor {
        return UIColor(red: 0.93, green: 0.94, blue: 0.96, alpha: 1.00).cgColor
    }
    
    static func backColorBT() -> UIColor {
        return UIColor(red: 0.17, green: 0.53, blue: 0.40, alpha: 1)
    }
    
    static func backAlphaColorBT() -> UIColor {
        return UIColor(red: 0.17, green: 0.53, blue: 0.40, alpha: 0.3)
    }
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
