# MemoryCache

[![CI Status](https://img.shields.io/travis/yysskk/MemoryCache.svg?style=for-the-badge)](https://travis-ci.org/yysskk/MemoryCache)
[![codecov](https://img.shields.io/codecov/c/github/yysskk/MemoryCache.svg?style=for-the-badge)](https://codecov.io/gh/yysskk/MemoryCache)
[![Version](https://img.shields.io/cocoapods/v/MemoryCache.svg?style=for-the-badge)](https://cocoapods.org/pods/MemoryCache)
[![License](https://img.shields.io/cocoapods/l/MemoryCache.svg?style=for-the-badge)](https://cocoapods.org/pods/MemoryCache)
[![Platform](https://img.shields.io/cocoapods/p/MemoryCache.svg?style=for-the-badge)](https://cocoapods.org/pods/MemoryCache)

## Overview
MemoryCache is a memory cache class in swift. 

- The MemoryCache class incorporates **LRU** policies, which ensure that a cache doesn’t use too much of the system’s memory. If memory is needed by other applications, it removes some items from the cache, minimizing its memory footprint.
- You can add, remove, and query items with **expiration** in the cache from different threads without having to lock the cache yourself. ( **thread-safe** )
- Unlike the NSCache class, the cache guarantees a type by its key. ( **type-safe** )

```swift
let memoryCache = MemoryCache.default // or initialize

// Defining a string (or hash) key for a dog value.
let dogKey = StringKey<Dog>("dog")

// Setting a dog value in memoryCache.
memoryCache.set(dog, for: dogKey)

// Getting a cached dog value in memoryCache.
let cachedDog = try? memoryCache.value(for: dogKey)

// Removing a cached dog value in memoryCache.
memoryCache.remove(for: dogKey)
```

## Usage
### Basic
####  Defining keys
```swift
let dogKey = StringKey<Dog>("dog")
```

#### Adding a Cached Value
```swift
memoryCache.set(dog, for: dogKey)
```

#### Getting a Cached Value
```swift
let dog = try? memoryCache.value(for: dogKey)
```

#### Removing Cached Values
- Removes the cache of the specified key.
```swift
memoryCache.remove(for: dogKey)
```

- Removes the cache of the specified key if it expired.
```swift
memoryCache.removeIfExpired(for: dogKey)
```

- Removes All. 
```swift
memoryCache.removeAll()
```

### Others
#### Properties
```swift
/// The maximum total cost that the memoryCache can hold before it starts evicting caches.
var totalCostLimit: Int

/// The maximum number of caches the memoryCache should hold.
var countLimit: Int

/// The total cost of values in the memoryCache.
var totalCost: Int

/// The number of values in the memoryCache.
var count: Int

/// A Boolean value indicating whether the memoryCache has no values.
var isEmpty: Bool
```

#### Implement delegate

```swift
import MemoryCache

class SomeClass: NSObject, MemoryCacheDelegate {

    let memoryCache: MemoryCache
    
    init() {
        memoryCache = MemoryCache.default
        
        ...
        
        super.init()

        memoryCache.delegate = self
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
memoryCache.set(dog, for: dogKey, expiration: .never)

/// The expiration date is `.seconds("""10s""")`.
memoryCache.set(dog, for: dogKey, expiration: .seconds(10))

/// The expiration date is `.date("""TOMORROW""")`.
memoryCache.set(dog, for: dogKey, expiration: .date(Date().addingTimeInterval(60 * 60 * 24)))

/// Remove the cache of the specified key if it expired.
memoryCache.removeIfExpired(for: dogKey)
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

## Author
### Yusuke Morishita
- [Github](https://github.com/yysskk)
- [Twitter](https://twitter.com/_yysskk)

[![Support via PayPal](https://cdn.rawgit.com/twolfson/paypal-github-button/1.0.0/dist/button.svg)](https://www.paypal.me/yysskk/980jpy)


## License

`MemoryCache` is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.
