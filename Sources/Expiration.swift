//
//  Expiration.swift
//  MemoryCache
//
//  Created by Yusuke Morishita on 2019/03/04.
//

import Foundation

public enum Expiration {
    case never
    case seconds(TimeInterval)
    case date(Date)

    public var date: Date {
        switch self {
        case .never:
            return Date(timeIntervalSince1970: TimeInterval.greatestFiniteMagnitude)
        case .seconds(let seconds):
            return Date().addingTimeInterval(seconds)
        case .date(let date):
            return date
        }
    }

    public var isExpired: Bool {
        return date.timeIntervalSinceNow < 0
    }
}
