//
//  Fonts.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 9.07.2024.
//

import UIKit

public enum CustomFont: String {
    case interRegular = "Inter-Regular"
    case interBold = "Inter-Bold"
}

extension UIFont {
    static func customFont(_ customFont: CustomFont, size: CGFloat) -> UIFont {
        return UIFont(name: customFont.rawValue, size: size)!
    }
}
