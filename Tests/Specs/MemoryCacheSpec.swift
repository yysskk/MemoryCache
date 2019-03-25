//
//  MemoryCacheSpec.swift
//  MemoryCache
//
//  Created by Yusuke Morishita on 2019/02/19.
//

import Quick
import Nimble
@testable import MemoryCache

final class MemoryCacheSpec: QuickSpec {

    override func spec() {
        var memoryCache: MemoryCache!
        var dog: Dog!
        var dog2: Dog!
        var cat: Cat!

        beforeEach {
            dog = Dog(name: "DOG")
            dog2 = Dog(name: "DOG2")
            cat = Cat(name: "CAT")
            memoryCache = MemoryCache.default
        }

        describe("totalCostLimit") {
            context("setter") {
                beforeEach {
                    memoryCache.totalCostLimit = 1
                    memoryCache.countLimit = 0
                    memoryCache.removeAll()
                    memoryCache.set(dog, for: MemoryCache.Key.dog, cost: 1)
                    memoryCache.set(cat, for: MemoryCache.Key.cat, cost: 1)
                }

                it("should remove dog") {
                    expect(memoryCache[MemoryCache.Key.dog]).to(beNil())
                    expect(memoryCache[MemoryCache.Key.cat]?.name).to(be(cat.name))
                }
            }

            context("getter") {
                var totalCostLimit: Int!

                beforeEach {
                    totalCostLimit = 1
                    memoryCache.totalCostLimit = totalCostLimit
                }

                it("should equal totalCostLimit") {
                    expect(memoryCache.totalCostLimit).to(equal(memoryCache.totalCostLimit))
                }
            }
        }

        describe("countLimit") {
            context("setter") {
                beforeEach {
                    memoryCache.totalCostLimit = 0
                    memoryCache.countLimit = 1
                    memoryCache.removeAll()
                    memoryCache.set(dog, for: MemoryCache.Key.dog)
                    memoryCache.set(cat, for: MemoryCache.Key.cat)
                }

                it("should remove dog") {
                    expect(memoryCache[MemoryCache.Key.dog]).to(beNil())
                    expect(memoryCache[MemoryCache.Key.cat]?.name).to(be(cat.name))
                }
            }

            context("setter") {

                var countLimit: Int!

                beforeEach {
                    countLimit = 1
                    memoryCache.countLimit = countLimit
                }

                it("should equal countLimit") {
                    expect(memoryCache.countLimit).to(equal(countLimit))
                }
            }
        }

        describe("totalCost") {
            var dogCost: Int!

            beforeEach {
                memoryCache.totalCostLimit = 0
                memoryCache.countLimit = 0
                dogCost = 1
                memoryCache.removeAll()
                memoryCache.set(dog, for: MemoryCache.Key.dog, cost: dogCost)
            }

            it("should be dog") {
                expect(memoryCache.totalCost).to(equal(dogCost))
            }
        }

        describe("count") {

            beforeEach {
                memoryCache.totalCostLimit = 0
                memoryCache.countLimit = 0
                memoryCache.removeAll()
                memoryCache.set(dog, for: MemoryCache.Key.dog)
            }

            it("should be dog") {
                expect(memoryCache.count).to(be(1))
            }
        }

        describe("isEmpty") {
            context("empty") {
                beforeEach {
                    memoryCache.removeAll()
                }

                it("should be true") {
                    expect(memoryCache.isEmpty).to(beTrue())
                }
            }

            context("not empty") {
                beforeEach {
                    memoryCache.removeAll()
                    memoryCache.set(dog, for: MemoryCache.Key.dog)
                }

                it("should be true") {
                    expect(memoryCache.isEmpty).to(beFalse())
                }
            }
        }

        describe("set") {
            context("StringKey") {

                context("set dog") {
                    beforeEach {
                        memoryCache.totalCostLimit = 0
                        memoryCache.countLimit = 0
                        memoryCache.removeAll()
                        memoryCache.set(dog, for: MemoryCache.Key.dog)
                    }

                    it("should be dog") {
                        do {
                            let cache = try memoryCache.value(for: MemoryCache.Key.dog)
                            expect(cache.value.name).to(be(dog.name))
                        } catch {
                            fail("Catch \(error.localizedDescription)")
                        }
                    }
                }

                context("set nil") {
                    beforeEach {
                        memoryCache.totalCostLimit = 0
                        memoryCache.countLimit = 0
                        memoryCache.removeAll()
                        memoryCache.set(nil, for: MemoryCache.Key.dog)
                    }

                    it("should catch MemoryCacheError.expired.notFound error") {
                        do {
                            let cache = try memoryCache.value(for: MemoryCache.Key.dog)
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

            context("HashKey") {
                beforeEach {
                    memoryCache.totalCostLimit = 0
                    memoryCache.countLimit = 0
                    memoryCache.removeAll()
                    memoryCache.set(cat, for: MemoryCache.Key.cat)
                }

                it("should be cat") {
                    do {
                        let cache = try memoryCache.value(for: MemoryCache.Key.cat)
                        expect(cache.value.name).to(be(cat.name))
                    } catch {
                        fail("Catch \(error.localizedDescription)")
                    }
                }
            }

            context("expiration") {
                var expiration: Expiration!
                
                context(".never") {
                    beforeEach {
                        memoryCache.totalCostLimit = 0
                        memoryCache.countLimit = 0
                        memoryCache.removeAll()
                        expiration = .never
                        memoryCache.set(dog, for: MemoryCache.Key.dog, expiration: expiration)
                    }
                    
                    it("should be dog") {
                        do {
                            let cache = try memoryCache.value(for: MemoryCache.Key.dog)
                            expect(cache.value.name).to(be(dog.name))
                        } catch {
                            fail("Catch \(error.localizedDescription)")
                        }
                    }
                }
                
                context(".seconds") {
                    context("normal") {
                        beforeEach {
                            memoryCache.totalCostLimit = 0
                            memoryCache.countLimit = 0
                            memoryCache.removeAll()
                            expiration = .seconds(60 * 60)
                            memoryCache.set(dog, for: MemoryCache.Key.dog, expiration: expiration)
                        }
                        
                        it("should be dog") {
                            do {
                                let cache = try memoryCache.value(for: MemoryCache.Key.dog)
                                expect(cache.value.name).to(be(dog.name))
                            } catch {
                                fail("Catch \(error.localizedDescription)")
                            }
                        }
                    }
                    
                    context("If the cache expired") {
                        beforeEach {
                            memoryCache.totalCostLimit = 0
                            memoryCache.countLimit = 0
                            memoryCache.removeAll()
                            expiration = .seconds(-60)
                            memoryCache.set(dog, for: MemoryCache.Key.dog, expiration: expiration)
                        }
                        
                        it("should catch MemoryCacheError.expired error") {
                            do {
                                let cache = try memoryCache.value(for: MemoryCache.Key.dog)
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
                            memoryCache.totalCostLimit = 0
                            memoryCache.countLimit = 0
                            memoryCache.removeAll()
                            expiration = .date(Date(timeIntervalSinceNow: 60 * 60))
                            memoryCache.set(dog, for: MemoryCache.Key.dog, expiration: expiration)
                        }
                        
                        it("should be dog") {
                            do {
                                let cache = try memoryCache.value(for: MemoryCache.Key.dog)
                                expect(cache.value.name).to(be(dog.name))
                            } catch {
                                fail("Catch \(error.localizedDescription)")
                            }
                        }
                    }
                    
                    context("If the cache expired") {
                        beforeEach {
                            memoryCache.totalCostLimit = 0
                            memoryCache.countLimit = 0
                            memoryCache.removeAll()
                            expiration = .date(Date(timeIntervalSinceNow: -60))
                            memoryCache.set(dog, for: MemoryCache.Key.dog, expiration: expiration)
                        }
                        
                        it("should catch MemoryCacheError.expired error") {
                            do {
                                let cache = try memoryCache.value(for: MemoryCache.Key.dog)
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

        describe("value(for:)") {
            context("normal") {
                context("StringKey") {
                    beforeEach {
                        memoryCache.totalCostLimit = 0
                        memoryCache.countLimit = 0
                        memoryCache.removeAll()
                        memoryCache.set(dog, for: MemoryCache.Key.dog)
                    }

                    it("should be dog") {
                        do {
                            let cache = try memoryCache.value(for: MemoryCache.Key.dog)
                            expect(cache.value.name).to(be(dog.name))
                        } catch {
                            fail("Catch \(error.localizedDescription)")
                        }
                    }
                }

                context("HashKey") {
                    beforeEach {
                        memoryCache.totalCostLimit = 0
                        memoryCache.countLimit = 0
                        memoryCache.removeAll()
                        memoryCache.set(cat, for: MemoryCache.Key.cat)
                    }

                    it("should be cat") {
                        do {
                            let cache = try memoryCache.value(for: MemoryCache.Key.cat)
                            expect(cache.value.name).to(be(cat.name))
                            expect(cache.key.element).to(equal(MemoryCache.Key.cat.element))

                        } catch {
                            fail("Catch \(error.localizedDescription)")
                        }
                    }
                }
            }

            context("error") {
                context("notFound") {
                    beforeEach {
                        memoryCache.totalCostLimit = 0
                        memoryCache.countLimit = 0
                        memoryCache.removeAll()
                    }

                    it("should catch MemoryCacheError.notFound error") {
                        do {
                            let cache = try memoryCache.value(for: MemoryCache.Key.dog)
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

                context("unexpectedObject") {
                    var missDogKey: StringKey<Cat>!

                    beforeEach {
                        missDogKey = StringKey<Cat>("dog")
                        memoryCache.totalCostLimit = 0
                        memoryCache.countLimit = 0
                        memoryCache.removeAll()
                        memoryCache.set(dog, for: MemoryCache.Key.dog)
                        memoryCache.set(cat, for: missDogKey)
                    }

                    it("should catch MemoryCacheError.unexpectedObject error") {
                        do {
                            let cache = try memoryCache.value(for: MemoryCache.Key.dog)
                            fail("Catch \(cache.value)")
                        } catch {
                            guard let memoryCacheError = error as? MemoryCacheError,
                            case .unexpectedObject = memoryCacheError else {
                                fail("it doesn't match \(MemoryCacheError.self) type")
                                return
                            }
                            expect(true).to(beTrue())
                        }
                    }
                }

                context("expired") {
                    var expiration: Expiration!

                    beforeEach {
                        memoryCache.totalCostLimit = 0
                        memoryCache.countLimit = 0
                        memoryCache.removeAll()
                        expiration = .date(Date(timeIntervalSinceNow: -60))
                        memoryCache.set(dog, for: MemoryCache.Key.dog, expiration: expiration)
                    }

                    it("should catch MemoryCacheError.expired error") {
                        do {
                            let cache = try memoryCache.value(for: MemoryCache.Key.dog)
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

        describe("remove") {
            beforeEach {
                memoryCache.totalCostLimit = 0
                memoryCache.countLimit = 0
                memoryCache.removeAll()
                memoryCache.set(dog, for: MemoryCache.Key.dog)
                memoryCache.set(dog2, for: MemoryCache.Key.dog2)
                memoryCache.remove(for: MemoryCache.Key.dog)
            }

            it("should remove dog") {
                expect(memoryCache[MemoryCache.Key.dog2]?.name).to(equal(dog2.name))
            }

            it("should be dog2") {
                do {
                    let cache = try memoryCache.value(for: MemoryCache.Key.dog2)
                    expect(cache.value.name).to(be(dog2.name))
                } catch {
                    fail("Catch \(error.localizedDescription)")
                }
            }
        }

        describe("removeIfExpired") {
            var expiration: Expiration!

            context("normal") {
                beforeEach {
                    memoryCache.totalCostLimit = 0
                    memoryCache.countLimit = 0
                    memoryCache.removeAll()
                    expiration = .date(Date(timeIntervalSinceNow: 60 * 60))
                    memoryCache.set(dog, for: MemoryCache.Key.dog, expiration: expiration)
                    memoryCache.removeIfExpired(for: MemoryCache.Key.dog)
                }

                it("should be dog") {
                    do {
                        let cache = try memoryCache.value(for: MemoryCache.Key.dog)
                        expect(cache.value.name).to(be(dog.name))
                    } catch {
                        fail("Catch \(error.localizedDescription)")
                    }
                }
            }

            context("If the cache expired") {
                beforeEach {
                    memoryCache.totalCostLimit = 0
                    memoryCache.countLimit = 0
                    memoryCache.removeAll()
                    expiration = .date(Date(timeIntervalSinceNow: -60))
                    memoryCache.set(dog, for: MemoryCache.Key.dog, expiration: expiration)
                    memoryCache.removeIfExpired(for: MemoryCache.Key.dog)
                }

                it("should catch MemoryCacheError.notFound error") {
                    do {
                        let cache = try memoryCache.value(for: MemoryCache.Key.dog)
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
                memoryCache.totalCostLimit = 0
                memoryCache.countLimit = 0
                memoryCache.removeAll()
                memoryCache.set(dog, for: MemoryCache.Key.dog)
                memoryCache.set(dog2, for: MemoryCache.Key.dog2)
                memoryCache.removeAll()
            }

            it("should catch MemoryCacheError.notFound error") {
                do {
                    let cache = try memoryCache.value(for: MemoryCache.Key.dog)
                    fail("Catch \(cache.value)")
                } catch {
                    guard let memoryCacheError = error as? MemoryCacheError else {
                        fail("it doesn't match \(MemoryCacheError.self) type")
                        return
                    }
                    expect(memoryCacheError == .notFound).to(beTrue())
                }

                do {
                    let cache = try memoryCache.value(for: MemoryCache.Key.cat)
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

        describe("subscript") {
            context("setter") {
                beforeEach {
                    memoryCache.totalCostLimit = 0
                    memoryCache.countLimit = 0
                    memoryCache.removeAll()
                    memoryCache[MemoryCache.Key.dog] = dog
                }

                it("should be dog") {
                    do {
                        let cache = try memoryCache.value(for: MemoryCache.Key.dog)
                        expect(cache.value.name).to(be(dog.name))
                    } catch {
                        fail("Catch \(error.localizedDescription)")
                    }
                }
            }

            context("getter") {
                beforeEach {
                    memoryCache.totalCostLimit = 0
                    memoryCache.countLimit = 0
                    memoryCache.removeAll()
                    memoryCache.set(dog, for: MemoryCache.Key.dog)
                }

                it("should be dog") {
                    let cache = memoryCache[MemoryCache.Key.dog]
                    expect(cache?.name).to(be(dog.name))
                }
            }
        }
    }
}
