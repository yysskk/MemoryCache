//
//  MemoryCache+.swift
//  MemoryCache
//
//  Created by Yusuke Morishita on 2019/03/24.
//

@testable import MemoryCache

extension MemoryCache {
    enum Key {
        static let dog = StringKey<Dog>("dog")
        static let dog2 = StringKey<Dog>("dog2")
        static let cat = StringKey<Cat>("cat")
    }
}
