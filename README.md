# MemoryCache

[![CI Status](https://img.shields.io/travis/yysskk/MemoryCache.svg?style=for-the-badge)](https://travis-ci.org/yysskk/MemoryCache)
[![Version](https://img.shields.io/cocoapods/v/MemoryCache.svg?style=for-the-badge)](https://cocoapods.org/pods/MemoryCache)
[![License](https://img.shields.io/cocoapods/l/MemoryCache.svg?style=for-the-badge)](https://cocoapods.org/pods/MemoryCache)
[![Platform](https://img.shields.io/cocoapods/p/MemoryCache.svg?style=for-the-badge)](https://cocoapods.org/pods/MemoryCache)

## Overview
MemoryCache is type-safe memory cache. It can benefit from [`NSCache`](https://developer.apple.com/documentation/foundation/nscache) features by wrapping `NSCache` .

```swift
let memoryCache = MemoryCache(name: "dog")

// Set dog in memoryCache.
memoryCache.set(dog, for: .dog)

// Load dog in memoryCache.
let cachedDog = try memoryCache.load(for: .dog)

// Remove dog in memoryCache.
memoryCache.remove(for: .dog)
```

## Usage
### Basic
####  Define keys
```swift
extension MemoryCache.KeyType {
    static let dog = MemoryCache.Key<Dog>(rawValue: "dog")
}
```

#### Set caches
```swift
MemoryCache.default.set(dog, for: .dog)
```

#### Load caches
```swift
let dog = try MemoryCache.default.load(for: .dog)
```

#### Remove caches
- Removes the cache of the specified key.
```swift
MemoryCache.default.remove(for: .dog)
```

- Removes the cache of the specified key if it expired.
```swift
MemoryCache.default.removeIfExpired(for: .dog)
```

- Removes All. 
```swift
MemoryCache.default.removeAll()
```

### Others
#### Properties
```swift
/// The maximum total cost that the memoryCache can hold before it starts evicting caches.
var totalCostLimit: Int

/// The maximum number of caches the memoryCache should hold.
var countLimit: Int

/// Whether the cache will automatically evict discardable-content caches whose content has been discarded.
var evictsCachesWithDiscardedContent: Bool
```

#### Implement delegate

```swift
import MemoryCache

class SomeClass: NSObject, MemoryCacheDelegate {

    init() {
        ...
        super.init()

        MemoryCache.default.delegate = self
    }
    
    func memoryCache(_ memoryCache: MemoryCache, willEvict cache: Any) {
        // Called when an cache is about to be evicted or removed from the memoryCache.
    }
}
```

#### Expiration date
You can specify expiration date for cache. The default expiration is `.never`.

```swift

/// The expiration date is `.never`.
memoryCache.set(dog, for: .dog, expiration: .never)

/// The expiration date is `.seconds("""10s""")`.
memoryCache.set(dog, for: .dog, expiration: .seconds(10))

/// The expiration date is `.date("""TOMORROW""")`.
memoryCache.set(dog, for: .dog, expiration: .date(Date().addingTimeInterval(60 * 60 * 24)))

/// Remove the cache of the specified key if it expired.
memoryCache.removeIfExpired(for: .dog)
```

## Requirements
- Swift 4.2  ~
- Xcode 10.1 ~

## Installation
### CocoaPods

MemoryCache is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MemoryCache'
```

### Carthage

You can integrate via [Carthage](https://github.com/carthage/carthage), too.
Add the following line to your `Cartfile` :

```
github "yysskk/MemoryCache"
```

and run `carthage update`

## To do
- [x] expiration date of cache
- [ ] LRU

## Author
### Yusuke Morishita
- [Github](https://github.com/yysskk)
- [Twitter](https://twitter.com/_yysskk)

[![Support via PayPal](https://cdn.rawgit.com/twolfson/paypal-github-button/1.0.0/dist/button.svg)](https://www.paypal.me/yysskk/980jpy)


## License

`MemoryCache` is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.
