//
//  Animals.swift
//  MemoryCache
//
//  Created by Yusuke Morishita on 2019/02/22.
//

protocol Animal {
    var name: String { get }
}

final class Cat: Animal {
    let name: String

    init(name: String) {
        self.name = name
    }
}

struct Dog: Animal {
    let name: String
}
