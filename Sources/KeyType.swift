//
//  KeyType.swift
//  MemoryCache
//
//  Created by Yusuke Morishita on 2019/03/24.
//

import Foundation

public protocol KeyType {
    associatedtype RelatedValue
    associatedtype Element: Hashable

    var element: Element { get }
}

public struct StringKey<T>: KeyType {
    public typealias RelatedValue = T
    public typealias Element = String

    public let element: Element

    public init(_ element: Element) {
        self.element = element
    }
}

public struct HashKey<T>: KeyType {
    public typealias RelatedValue = T
    public typealias Element = Int

    public let element: Element

    public init(_ element: Element) {
        self.element = element
    }
}
