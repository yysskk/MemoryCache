//
//  MemoryCacheError.swift
//  MemoryCache
//
//  Created by Yusuke Morishita on 2019/03/04.
//

import Foundation

public enum MemoryCacheError: Error {
    case notFound
    case unexpectedObject(Any)
    case expired(Date)
}
