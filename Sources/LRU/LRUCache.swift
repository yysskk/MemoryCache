//
//  LRUCache.swift
//  MemoryCache
//
//  Created by Yusuke Morishita on 2019/03/23.
//

import Foundation

protocol LRUCacheDelegate: class {
    func cache(willEvict cache: Any)
}

final class LRUCache<Key, Value> where Key: Hashable {

    weak var delegate: LRUCacheDelegate?

    var totalCostLimit: Int = 0 {
        didSet { _sync() }
    }

    var countLimit: Int = 0 {
        didSet { _sync() }
    }

    private(set) var totalCost: Int = 0

    var count: Int {
        return map.count
    }

    var isEmpty: Bool {
        return list.isEmpty
    }

    private var map = [Key: LinkedList<Entry>.Node]()
    private let list = LinkedList<Entry>()
    private let lock = NSLock()

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(removeAll), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func set(_ value: Value, for key: Key, cost: Int = 0) {
        lock.lock()
        defer { lock.unlock() }

        if let node = map[key] {
            _remove(node, for: key)
        }

        let cache = Entry(key: key, value: value, cost: cost)
        map[key] = list.append(cache)
        totalCost += cost
        _sync()
    }

    func value(for key: Key) -> Value? {
        lock.lock()
        defer { lock.unlock() }

        guard let node = map[key] else {
            return nil
        }

        list.remove(node)
        list.append(node)

        return node.value.value
    }

    @discardableResult
    func remove(for key: Key) -> Value? {
        lock.lock()
        defer { lock.unlock() }

        guard let node = map[key] else { return nil }
        _remove(node, for: key)
        return node.value.value
    }

    private func _remove(_ node: LinkedList<Entry>.Node, for key: Key) {
        list.remove(node)
        totalCost -= node.value.cost
        delegate?.cache(willEvict: node.value.value)
        map.removeValue(forKey: key)
    }

    @objc func removeAll() {
        lock.lock()
        defer { lock.unlock() }

        map = [:]
        list.removeAll()
        totalCost = 0
    }

    private func _sync() {
        if totalCostLimit > 0 {
            _sync(while: { totalCostLimit < totalCost })
        }
        if countLimit > 0 {
            _sync(while: { countLimit < count })
        }
    }

    private func _sync(while condition: () -> Bool) {
        guard condition(),
            let node = list.last else { return }
        _remove(node, for: node.value.key)
        _sync(while: condition)
    }

    struct Entry {
        let key: Key
        let value: Value
        let cost: Int
    }
}
