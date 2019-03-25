//
//  LRUCacheSpec.swift
//  MemoryCache
//
//  Created by Yusuke Morishita on 2019/03/25.
//

import Quick
import Nimble
@testable import MemoryCache

final class LRUCacheSpec: QuickSpec {

    override func spec() {
        var cache: LRUCache<AnyKey, AnyCache>?

        describe("deinit") {
            beforeEach {
                cache = LRUCache()
                cache = nil
            }

            it("should be nil") {
                expect(cache).to(beNil())
            }
        }
    }

}
