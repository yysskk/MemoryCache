//
//  MemoryCacheError+.swift
//  MemoryCache
//
//  Created by Yusuke Morishita on 2019/03/04.
//

import Foundation
import MemoryCache

extension MemoryCacheError: Equatable {
    public static func == (lhs: MemoryCacheError, rhs: MemoryCacheError) -> Bool {
        switch (lhs, rhs) {
        case (.notFound, .notFound):
            return true
        case (.expired(let lDate), .expired(let rDate)):
            return lDate == rDate
        default:
            return false
        }
    }
}
