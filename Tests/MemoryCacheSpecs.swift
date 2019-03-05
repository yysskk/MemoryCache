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
            context("normal") {
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

            context("notFound") {
                beforeEach {
                    memoryCache.removeAll()
                }

                it("should catch MemoryCacheError.expired.notFound error") {
                    do {
                        let cache = try memoryCache.load(for: .dog)
                        fail("Catch \(cache.value)")
                    } catch {
                        guard let memoryCacheError = error as? MemoryCacheError else {
                            fail("it doesn't match \(MemoryCacheError.self) type")
                            return
                        }
                        expect(memoryCacheError == .notFound).to(beTrue())
                    }
                }
            }

            context("expired") {
                var expiration: Expiration!

                beforeEach {
                    memoryCache.removeAll()
                    expiration = .date(Date(timeIntervalSinceNow: -60))
                    memoryCache.set(dog, for: .dog, expiration: expiration)
                }

                it("should catch MemoryCacheError.expired error") {
                    do {
                        let cache = try memoryCache.load(for: .dog)
                        fail("Catch \(cache.value)")
                    } catch {
                        guard let memoryCacheError = error as? MemoryCacheError else {
                            fail("it doesn't match \(MemoryCacheError.self) type")
                            return
                        }
                        guard case .expired(let date) = memoryCacheError else {
                            fail("it isn't .expired")
                            return
                        }

                        expect(date.timeIntervalSinceReferenceDate == expiration?.date.timeIntervalSinceReferenceDate).to(beTrue())
                    }
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

            context("normal") {
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
        }

        describe("removeIfExpired") {
            var expiration: Expiration!

            context("normal") {
                beforeEach {
                    memoryCache.removeAll()
                    expiration = .date(Date(timeIntervalSinceNow: 60 * 60))
                    memoryCache.set(dog, for: .dog, expiration: expiration)
                    memoryCache.removeIfExpired(for: .dog)
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

            context("If the cache expired") {
                beforeEach {
                    memoryCache.removeAll()
                    expiration = .date(Date(timeIntervalSinceNow: -60))
                    memoryCache.set(dog, for: .dog, expiration: expiration)
                    memoryCache.removeIfExpired(for: .dog)
                }

                it("should catch MemoryCacheError.notFound error") {
                    do {
                        let cache = try memoryCache.load(for: .dog)
                        fail("Catch \(cache.value)")
                    } catch {
                        guard let memoryCacheError = error as? MemoryCacheError else {
                            fail("it doesn't match \(MemoryCacheError.self) type")
                            return
                        }
                        expect(memoryCacheError == .notFound).to(beTrue())
                    }
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

            it("should catch MemoryCacheError.notFound error") {
                do {
                    let cache = try memoryCache.load(for: .dog)
                    fail("Catch \(cache.value)")
                } catch {
                    guard let memoryCacheError = error as? MemoryCacheError else {
                        fail("it doesn't match \(MemoryCacheError.self) type")
                        return
                    }
                    expect(memoryCacheError == .notFound).to(beTrue())
                }

                do {
                    let cache = try memoryCache.load(for: .cat)
                    fail("Catch \(cache.value)")
                } catch {
                    guard let memoryCacheError = error as? MemoryCacheError else {
                        fail("it doesn't match \(MemoryCacheError.self) type")
                        return
                    }
                    expect(memoryCacheError == .notFound).to(beTrue())
                }
            }
        }

        describe("Expiration") {
            var expiration: Expiration!

            context(".never") {
                beforeEach {
                    memoryCache.removeAll()
                    expiration = .never
                    memoryCache.set(dog, for: .dog, expiration: expiration)
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

            context(".seconds") {
                context("normal") {
                    beforeEach {
                        memoryCache.removeAll()
                        expiration = .seconds(60 * 60)
                        memoryCache.set(dog, for: .dog, expiration: expiration)
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

                context("If the cache expired") {
                    beforeEach {
                        memoryCache.removeAll()
                        expiration = .seconds(-60)
                        memoryCache.set(dog, for: .dog, expiration: expiration)
                    }

                    it("should catch MemoryCacheError.expired error") {
                        do {
                            let cache = try memoryCache.load(for: .dog)
                            fail("Catch \(cache.value)")
                        } catch {
                            guard let memoryCacheError = error as? MemoryCacheError else {
                                fail("it doesn't match \(MemoryCacheError.self) type")
                                return
                            }
                            guard case .expired(let date) = memoryCacheError else {
                                fail("it isn't .expired")
                                return
                            }

                            expect(date < Date().addingTimeInterval(-60)).to(beTrue())
                        }
                    }
                }
            }

            context(".date") {
                context("normal") {
                    beforeEach {
                        memoryCache.removeAll()
                        expiration = .date(Date(timeIntervalSinceNow: 60 * 60))
                        memoryCache.set(dog, for: .dog, expiration: expiration)
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

                context("If the cache expired") {
                    beforeEach {
                        memoryCache.removeAll()
                        expiration = .date(Date(timeIntervalSinceNow: -60))
                        memoryCache.set(dog, for: .dog, expiration: expiration)
                    }

                    it("should catch MemoryCacheError.expired error") {
                        do {
                            let cache = try memoryCache.load(for: .dog)
                            fail("Catch \(cache.value)")
                        } catch {
                            guard let memoryCacheError = error as? MemoryCacheError else {
                                fail("it doesn't match \(MemoryCacheError.self) type")
                                return
                            }
                            guard case .expired(let date) = memoryCacheError else {
                                fail("it isn't .expired")
                                return
                            }

                            expect(date.timeIntervalSinceReferenceDate == expiration?.date.timeIntervalSinceReferenceDate).to(beTrue())
                        }
                    }
                }
            }
        }
    }
}
