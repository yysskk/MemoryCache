//
//  MemoryCacheDelegate.swift
//  MemoryCache
//
//  Created by Yusuke Morishita on 2019/03/05.
//

import Foundation

final class CacheDlegate: NSObject, NSCacheDelegate {

    private var memoryCache: MemoryCache?

    func configure(memoryCache: MemoryCache?) {
        self.memoryCache = memoryCache
    }

    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        guard let memoryCache = memoryCache,
            let evictedCache = obj as? AnyCache else { return }
        memoryCache.delegate?.memoryCache(memoryCache, willEvict: evictedCache.value)
    }
}
