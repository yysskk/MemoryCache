Pod::Spec.new do |s|
  s.name             = 'MemoryCache'
  s.version          = '0.3.0'
  s.summary          = 'MemoryCache is type-safe memory cache.'

  s.description      = <<-DESC
                       MemoryCache is type-safe memory cache. It can benefit from `NSCache` features by wrapping `NSCache`.
                       DESC

  s.homepage         = 'https://github.com/yysskk/MemoryCache'
  s.license          = { :type => 'MIT', :file => './LICENSE' }
  s.author           = { 'yysskk' => 'yusuke.0213@gmail.com' }
  s.source           = { :git => 'https://github.com/yysskk/MemoryCache.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/_yysskk'

  s.platform = :ios
  s.ios.deployment_target = '8.0'

  s.swift_version = '4.2'
  s.source_files = 'Sources/*.swift'
end
