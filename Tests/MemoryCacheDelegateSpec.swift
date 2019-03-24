//
//  MemoryCacheDelegateSpec.swift
//  MemoryCache
//
//  Created by Yusuke Morishita on 2019/03/24.
//

import Quick
import Nimble
@testable import MemoryCache

extension Notification.Name {
    static let dog = Notification.Name(rawValue: "Dog")
}

final class MemoryCacheDelegateSpec: QuickSpec, MemoryCacheDelegate {

    override func spec() {
        var memoryCache: MemoryCache!
        var dog: Dog!

        beforeEach {
            dog = Dog(name: "DOG")
            memoryCache = MemoryCache.default
            memoryCache.delegate = self
            memoryCache.set(dog, for: MemoryCache.Key.dog)
        }

        it("should be called delegate") {
            self.expectation(forNotification: .dog, object: nil, handler: { notification -> Bool in

                expect(notification.name).to(equal(Notification.Name.dog))
                guard let dog = notification.object as? Dog else {
                    fail("it doesn't match \(Dog.self) type")
                    return true
                }
                expect(dog.name).to(equal(dog.name))

                return true
            })

            memoryCache.remove(for: MemoryCache.Key.dog)
        }
    }


    func memoryCache(_ memoryCache: MemoryCache, willEvict cache: Any) {
        NotificationCenter.default.post(Notification(name: .dog, object: cache))
    }
}
