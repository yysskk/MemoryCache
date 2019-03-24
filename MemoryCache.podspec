Pod::Spec.new do |s|
  s.name             = 'MemoryCache'
  s.version          = '1.0.0'
  s.summary          = 'MemoryCache is a LRU memory cache in swift.'

  s.description      = <<-DESC
                       MemoryCache is LRU, type-safe, thread-safe memory cache.
                        - The MemoryCache class iincorporates **LRU** policies, which ensure that a cache doesn’t use too much of the system’s memory. If memory is needed by other applications, it removes some items from the cache, minimizing its memory footprint.
                        - You can add, remove, and query items in the cache from different threads without having to lock the cache yourself.
                        - Unlike the NSCache class, the cache guarantees a type by its key.
                       DESC

  s.homepage         = 'https://github.com/yysskk/MemoryCache'
  s.license          = { :type => 'MIT', :file => './LICENSE' }
  s.author           = { 'yysskk' => 'yusuke.0213@gmail.com' }
  s.source           = { :git => 'https://github.com/yysskk/MemoryCache.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/_yysskk'

  s.platform = :ios
  s.ios.deployment_target = '8.0'

  s.swift_version = '4.2'
  s.source_files = 'Sources/**/*.swift'
end
