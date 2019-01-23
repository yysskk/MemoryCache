//
//  MemoryCache.h
//  MemoryCache
//
//  Created by Yusuke Morishita on 2019/02/19.
//

import Quick
import Nimble
@testable import MemoryCache

extension MemoryCache.KeyType {
    static let dog = MemoryCache.Key<Dog>(rawValue: "dog")
    static let cat = MemoryCache.Key<Cat>(rawValue: "cat")
}

final class MemoryCacheSpec: QuickSpec {

    override func spec() {
        var memoryCache: MemoryCache!
        var cat: Cat!
        var dog: Dog!

        beforeEach {
            cat = Cat(name: "CAT")
            dog = Dog(name: "DOG")
            memoryCache = MemoryCache.default
        }

        describe("set") {
            beforeEach {
                memoryCache.removeAll()
                memoryCache.set(dog, for: .dog)
            }

            it("should be dog") {
                expect(memoryCache.load(for: .dog)?.name).to(be(dog.name))
            }
        }

        describe("load") {
            beforeEach {
                memoryCache.removeAll()
                memoryCache.set(dog, for: .dog)
            }

            it("should be dog") {
                expect(memoryCache.load(for: .dog)?.name).to(be(dog.name))
            }
        }

        describe("remove") {
            beforeEach {
                memoryCache.removeAll()
                memoryCache.set(dog, for: .dog)
                memoryCache.set(cat, for: .cat)
                memoryCache.remove(for: .dog)
            }

            it("should be nil") {
                expect(memoryCache.load(for: .dog)).to(beNil())
            }

            it("should not be nil") {
                expect(memoryCache.load(for: .cat)).notTo(beNil())
            }
        }

        describe("removeAll") {
            beforeEach {
                memoryCache.removeAll()
                memoryCache.set(dog, for: .dog)
                memoryCache.set(cat, for: .cat)
                memoryCache.removeAll()
            }

            it("should be nil") {
                expect(memoryCache.load(for: .dog)).to(beNil())
                expect(memoryCache.load(for: .cat)).to(beNil())
            }
        }
    }
}
