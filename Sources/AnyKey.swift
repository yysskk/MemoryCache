//
//  AnyKey.swift
//  MemoryCache
//
//  Created by Yusuke Morishita on 2019/03/24.
//

import Foundation

struct AnyKey: Hashable {

    let element: Any

    var hashValue: Int {
        guard let element = element as? AnyHashable else { return 0 }
        return element.hashValue
    }

    init<Key: KeyType>(key: Key) {
        self.element = key.element
    }

    static func == (lhs: AnyKey, rhs: AnyKey) -> Bool {
        guard let lhs = lhs.element as? AnyHashable,
            let rhs = rhs.element as? AnyHashable else { return false }
        return lhs == rhs
    }

}
