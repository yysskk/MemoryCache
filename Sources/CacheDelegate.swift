//
//  CacheDelegate.swift
//  MemoryCache
//
//  Created by Yusuke Morishita on 2019/03/05.
//

import Foundation

final class CacheDlegate: LRUCacheDelegate {

    private var memoryCache: MemoryCache?

    func configure(memoryCache: MemoryCache?) {
        self.memoryCache = memoryCache
    }

    func cache(willEvict cache: Any) {
        guard let memoryCache = memoryCache,
            let cache = cache as? AnyCache else { return }
        memoryCache.delegate?.memoryCache(memoryCache, willEvict: cache.value)
    }
}
