//
//  AnyCache.swift
//  MemoryCache
//
//  Created by Yusuke Morishita on 2019/02/19.
//

final class AnyCache: NSObject, RawRepresentable {
    typealias RawValue = Any


    let rawValue: RawValue

    init(rawValue: RawValue) {
        self.rawValue = rawValue
    }

}
