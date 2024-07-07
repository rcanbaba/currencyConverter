//
//  Logger.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import Foundation

class Logger {
    enum MessageType {
        case info
        case warning
    }
    
    private init() {}
    
    private static func print(_ message: String, type: MessageType = .info) {
        #if DEBUG
        let prefix: String
        switch type {
        case .info:
            prefix = "💚 INFO: "
        case .warning:
            prefix = "❤️ WARNING: "
        }
        Swift.print("\(prefix)\(message)")
        #endif
    }
    
    public static func info(_ message: String) {
        print(message, type: .info)
    }
    
    public static func warning(_ message: String) {
        print(message, type: .warning)
    }
}
