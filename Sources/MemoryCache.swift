//
//  MemoryCache.h
//  MemoryCache
//
//  Created by Yusuke Morishita on 2019/02/19.
//

/// The delegate of an MemoryCache implements this protocol to perform specialized actions when an cache is about to be evicted or removed from the memoryCache.
public protocol MemoryCacheDelegate: class {
    /// Called when an cache is about to be evicted or removed from the memoryCache.
    func memoryCache(_ memoryCache: MemoryCache, willEvict cache: Any)
}

@available(iOS 8.0, *)
open class MemoryCache {

    /// Returns the default singleton instance.
    public static let `default` = MemoryCache()

    /// The memoryCache’s delegate.
    public weak var delegate: MemoryCacheDelegate? {
        didSet {
            _delegate.configure(memoryCache: self)
        }
    }

    /// The maximum total cost that the memoryCache can hold before it starts evicting caches.
    ///
    /// If 0, there is no total cost limit. The default value is smaller of the amount cost of physical memory on the computer and `Int.max`.
    public var totalCostLimit: Int {
        get {
            return cache.totalCostLimit
        }
        set {
            cache.totalCostLimit = newValue
        }
    }

    /// The maximum number of caches the memoryCache should hold.
    ///
    /// If 0, there is no count limit. The default value is 0.
    public var countLimit: Int {
        get {
            return cache.countLimit
        }
        set {
            cache.countLimit = newValue
        }
    }

    /// Whether the cache will automatically evict discardable-content caches whose content has been discarded.
    public var evictsCachesWithDiscardedContent: Bool {
        get {
            return cache.evictsObjectsWithDiscardedContent
        }
        set {
            cache.evictsObjectsWithDiscardedContent = newValue
        }
    }

    private let cache: NSCache<KeyType, AnyCache>
    private let lock = NSLock()
    private let _delegate = CacheDlegate()

    private let defaultTotalCostLimit: Int = {
        let physicalMemory = ProcessInfo().physicalMemory
        let ratio = physicalMemory <= (1024 * 1024 * 512) ? 0.1 : 0.2
        let limit = physicalMemory / UInt64(1 / ratio)
        return min(Int.max, Int(limit))
    }()

    private init() {
        cache = NSCache()
        cache.totalCostLimit = defaultTotalCostLimit
        cache.delegate = _delegate
    }

    public init(name: String) {
        cache = NSCache()
        cache.name = name
        cache.totalCostLimit = defaultTotalCostLimit
        cache.delegate = _delegate
    }

    /// Sets the value of the specified key that inherits `KeyType` in the memoryCache, and associates the key-value pair with the specified cost.
    ///
    /// The default expiration is `.never`, cost is `0`.
    public func set<T>(_ value: T, for key: KeyType, expiration: Expiration = .never, cost: Int = 0) {
        lock.lock()
        defer { lock.unlock() }

        let anyCache = AnyCache(value: value, expiration: expiration)
        cache.setObject(anyCache, forKey: key, cost: cost)
    }

    /// Returns the value associated with a given key that inherits `KeyType`.
    public func load<T>(for key: KeyType) throws -> Cache<T> {
        lock.lock()
        defer { lock.unlock() }

        guard let anyCache = cache.object(forKey: key) else {
            throw MemoryCacheError.notFound
        }
        guard let value = anyCache.value as? T else {
            throw MemoryCacheError.unexpectedObject(anyCache.value)
        }
        guard !anyCache.expiration.isExpired else {
            throw MemoryCacheError.expired(anyCache.expiration.date)
        }

        return Cache(key: key, value: value, expiration: anyCache.expiration)
    }

    /// Returns the value associated with a given key.
    public func load<T>(for key: Key<T>) throws -> Cache<T> {
        lock.lock()
        defer { lock.unlock() }

        guard let anyCache = cache.object(forKey: key) else {
            throw MemoryCacheError.notFound
        }
        guard let value = anyCache.value as? T else {
            throw MemoryCacheError.unexpectedObject(anyCache.value)
        }
        guard !anyCache.expiration.isExpired else {
            throw MemoryCacheError.expired(anyCache.expiration.date)
        }

        return Cache(key: key, value: value, expiration: anyCache.expiration)
    }

    /// Removes the value of the specified key that inherits `KeyType` in the memoryCache.
    public func remove(for key: KeyType) {
        lock.lock()
        defer { lock.unlock() }

        return cache.removeObject(forKey: key)
    }

    /// Removes the value of the specified key if it expired in the memoryCache.
    public func removeIfExpired(for key: KeyType) {
        lock.lock()
        defer { lock.unlock() }

        guard let anyCache = cache.object(forKey: key),
            anyCache.expiration.isExpired else { return }
        return cache.removeObject(forKey: key)
    }

    /// Empties the memoryCache.
    public func removeAll() {
        lock.lock()
        defer { lock.unlock() }

        return cache.removeAllObjects()
    }

}

extension MemoryCache {

    public struct Cache<T> {
        let key: KeyType
        let value: T
        let expiration: Expiration
    }

    open class KeyType: NSObject {
        override init() {}
    }

    public class Key<T>: KeyType, RawRepresentable {
        public typealias RawValue = String

        public let rawValue: RawValue

        required public init(rawValue: RawValue) {
            self.rawValue = rawValue
            super.init()
        }

        override public func isEqual(_ object: Any?) -> Bool {
            guard let key = object as? Key<T> else { return false }
            return rawValue == key.rawValue
        }
    }

}
