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

    /// The total cost of values in the memoryCache.
    public var totalCost: Int {
        return cache.totalCost
    }

    /// The number of values in the memoryCache.
    public var count: Int {
        return cache.count
    }

    /// A Boolean value indicating whether the memoryCahc has no values.
    public var isEmpty: Bool {
        return cache.isEmpty
    }

    private let cache: LRUCache<AnyKey, AnyCache>
    private let _delegate = CacheDlegate()

    private let defaultTotalCostLimit: Int = {
        let physicalMemory = ProcessInfo().physicalMemory
        let ratio = physicalMemory <= (1024 * 1024 * 512) ? 0.1 : 0.2
        let limit = physicalMemory / UInt64(1 / ratio)
        return min(Int.max, Int(limit))
    }()

    public init(totalCostLimit: Int? = nil,
                countLimit: Int = 0) {
        cache = LRUCache()
        cache.delegate = _delegate
        self.totalCostLimit = totalCostLimit ?? defaultTotalCostLimit
        self.countLimit = countLimit
    }

    /// Sets the value of the specified key that inherits `KeyType` in the memoryCache, and associates the key-value pair with the specified cost.
    ///
    /// The default expiration is `.never`, cost is `0`.
    public func set<Key: KeyType, Value>(_ value: Value?, for key: Key, expiration: Expiration = .never, cost: Int = 0) where Key.RelatedValue == Value {
        switch value {
        case let .some(wrapped):
            let anyCache = AnyCache(value: wrapped, expiration: expiration)
            cache.set(anyCache, for: AnyKey(key: key), cost: cost)
        case .none:
            remove(for: key)
        }
    }

    /// Returns the value associated with a given key that inherits `KeyType`.
    public func value<Key: KeyType, Value>(for key: Key) throws -> Entry<Key, Value> where Key.RelatedValue == Value {
        guard let anyCache = cache.value(for: AnyKey(key: key)) else {
            throw MemoryCacheError.notFound
        }
        guard let value = anyCache.value as? Value else {
            throw MemoryCacheError.unexpectedObject(anyCache.value)
        }
        guard !anyCache.expiration.isExpired else {
            cache.remove(for: AnyKey(key: key))
            throw MemoryCacheError.expired(anyCache.expiration.date)
        }

        return Entry(key: key, value: value, expiration: anyCache.expiration)
    }

    /// Removes the value of the specified key that inherits `KeyType` in the memoryCache.
    public func remove<Key: KeyType, Value>(for key: Key) where Key.RelatedValue == Value {
        cache.remove(for: AnyKey(key: key))
    }

    /// Removes the value of the specified key if it expired in the memoryCache.
    public func removeIfExpired<Key: KeyType>(for key: Key) {
        guard let anyCache = cache.value(for: AnyKey(key: key)),
            anyCache.expiration.isExpired else { return }
        cache.remove(for: AnyKey(key: key))
    }

    /// Empties the memoryCache.
    public func removeAll() {
        return cache.removeAll()
    }

    public subscript<Key: KeyType, Value>(key: Key) -> Value? where Key.RelatedValue == Value {
        get {
            return try? value(for: key).value
        }
        set(value) {
            set(value, for: key)
        }
    }
}

extension MemoryCache {
    public struct Entry<Key: KeyType, Value> {
        let key: Key
        let value: Value
        let expiration: Expiration
    }
}
