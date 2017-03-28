//
//  Logger.swift
//  Yara
//
//  Created by Ryan Grigsby on 3/24/17.
//  Copyright © 2017 Grigs-b. All rights reserved.
//

import Foundation


enum LogSeverity: Int {
    case verbose
    case info
    case warning
    case error
}

protocol Logger {
    var level: LogSeverity {get}
    func log(_ severity: LogSeverity, message: String)
}

extension Logger {

    func verbose(message: String) {
        log(.verbose, message: message)
    }

    func info(message: String) {
        log(.info, message: message)
    }

    func warning(message: String) {
        log(.warning, message: message)
    }

    func error(message: String) {
        log(.error, message: message)
    }
}

struct ConsoleLogger: Logger {
    let level: LogSeverity

    init(level: LogSeverity = .info) {
        self.level = level
    }

    func log(_ severity: LogSeverity, message: String) {
        if severity.rawValue >= level.rawValue {
            print(message)
        }
    }
}
