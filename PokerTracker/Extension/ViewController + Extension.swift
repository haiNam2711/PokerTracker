//
//  ViewController + Extension.swift
//  PokerTracker
//
//  Created by Nguyễn Đình Việt on 13/04/2024.
//

import UIKit

extension UIViewController {
    var safeAreaInsets: UIEdgeInsets {
        let window = UIApplication.shared.windows[0]
        return window.safeAreaInsets
    }
}
