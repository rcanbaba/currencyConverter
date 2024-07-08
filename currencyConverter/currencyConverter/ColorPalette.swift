//
//  ColorPalette.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import UIKit

//TODO: add fonts on figma

extension UIColor {
    struct Custom {
        struct Converter {
            
            static let backgroundColor = UIColor("EDF0F4")
            
            struct Error {
                static let maxErrorTextColor = UIColor("E5476D")
                static let maxErrorBackgroundColor = UIColor("E5476D").withAlphaComponent(0.1)
                static let networkErrorTitleColor = UIColor("001A3F")
                static let networkErrorDescriptionColor = UIColor("6C727A")
                static let borderColor = UIColor("F8326A")
            }

            struct Rate {
                static let backgroundColor = UIColor("000000")
                static let textColor = UIColor("FFFFFF")
            }
            
            struct Sender {
                static let titleTextColor = UIColor("6C727A")
                static let currencyCodeColor = UIColor("000000")
                static let backgroundColor = UIColor("FFFFFF")
            }
            struct Receiver {
                static let titleTextColor = UIColor("6C727A")
                static let currencyCodeColor = UIColor("000000")
                static let backgroundColor = UIColor("FFFFFF").withAlphaComponent(0.0)
            }
            
            struct Amount {
                static let blueText = UIColor("317FF5")
                static let redText = UIColor("F8326A")
                static let blackText = UIColor("000000")
            }
        }
        
        struct Picker {
            static let backgroundColor = UIColor("FFFFFF")
            static let titleTextColor = UIColor("000000")
            static let itemDetailTextColor = UIColor("6C727A")
            static let itemFlagBackgroundColor = UIColor("EDF0F4")
            
            struct SearchBar {
                static let backgroundColor = UIColor("FFFFFF")
                static let borderColor = UIColor("A2ABB8")
                static let textColor = UIColor("6C727A")
            }
        }
    }
}
