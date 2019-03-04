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
                do {
                    let cache = try memoryCache.load(for: .dog)
                    expect(cache.value.name).to(be(dog.name))
                } catch {
                    fail("Catch \(error.localizedDescription)")
                }
            }
        }

        describe("load") {
            beforeEach {
                memoryCache.removeAll()
                memoryCache.set(dog, for: .dog)
            }

            it("should be dog") {
                do {
                    let cache = try memoryCache.load(for: .dog)
                    expect(cache.value.name).to(be(dog.name))
                } catch {
                    fail("Catch \(error.localizedDescription)")
                }
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
                do {
                    let cache = try memoryCache.load(for: .dog)
                    fail("Catch \(cache.value)")
                } catch {
                    guard let memoryCacheError = error as? MemoryCacheError else {
                        fail("it not match \(MemoryCacheError.self) type")
                        return
                    }
                    expect(memoryCacheError == .notFound).to(beTrue())
                }
            }

            it("should not be nil") {
                do {
                    let cache = try memoryCache.load(for: .cat)
                    expect(cache.value.name).to(be(cat.name))
                } catch {
                    fail("Catch \(error.localizedDescription)")
                }
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
                do {
                    let cache = try memoryCache.load(for: .dog)
                    fail("Catch \(cache.value)")
                } catch {
                    guard let memoryCacheError = error as? MemoryCacheError else {
                        fail("it not match \(MemoryCacheError.self) type")
                        return
                    }
                    expect(memoryCacheError == .notFound).to(beTrue())
                }

                do {
                    let cache = try memoryCache.load(for: .cat)
                    fail("Catch \(cache.value)")
                } catch {
                    guard let memoryCacheError = error as? MemoryCacheError else {
                        fail("it not match \(MemoryCacheError.self) type")
                        return
                    }
                    expect(memoryCacheError == .notFound).to(beTrue())
                }
            }
        }
    }
}
