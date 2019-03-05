//
//  AnyCache.swift
//  MemoryCache
//
//  Created by Yusuke Morishita on 2019/02/19.
//

final class AnyCache: NSObject {

    let value: Any
    let expiration: Expiration

    init(value: Any,
         expiration: Expiration) {

        self.value = value
        self.expiration = expiration
    }

}
