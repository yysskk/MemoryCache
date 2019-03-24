//
//  LinkedList.swift
//  MemoryCache
//
//  Created by Yusuke Morishita on 2019/03/23.
//

import Foundation

/// A doubly linked list
final class LinkedList<Element> {

    final class Node {
        let value: Element
        var next: Node?
        weak var previous: Node?

        init(_ value: Element,
             next: Node? = nil,
             previous: Node? = nil) {
            self.value = value
            self.next = next
            self.previous = previous
        }
    }

    var isEmpty: Bool {
        return last == nil
    }

    private(set) var first: Node?
    private(set) var last: Node?

    init() {
        first = nil
        last = nil
    }

    deinit {
        removeAll()
    }

    @discardableResult
    func append(_ element: Element) -> Node {
        let node = Node(element, previous: first)
        append(node)
        return node
    }

    func append(_ node: Node) {
        switch last {
        case .some:
            first = node
        case .none:
            first = node
            last = node
        }
    }

    func remove(_ node: Node) {
        node.next?.previous = node.previous
        node.previous?.next = node.next

        if node === last {
            last = node.previous
        }

        if node === first {
            first = node.next
        }

        node.next = nil
        node.previous = nil
    }

    func removeAll() {
        guard let _first = first else { return }
        _removeAll(node: _first)
        first = nil
        last = nil
    }

    private func _removeAll(node: Node) {
        guard let next = node.next else { return }
        node.next = nil
        next.previous = nil
        _removeAll(node: next)
    }
}
