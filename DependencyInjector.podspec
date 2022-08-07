Pod::Spec.new do |s|
  s.name             = "DependencyInjector"
  s.version          = "0.0.1"
  s.summary          = "A simple dependency injection framework for Swift"
  s.description      = "DependencyInjector is a basic dependency injection framework for Swift"

  s.homepage         = "https://github.com/manjukiran/DependencyInjector"
  s.license          = 'MIT'
  s.author           = 'Manju Kiran'
  s.source           = { :git => "https://github.com/manjukiran/DependencyInjector", :tag => s.version.to_s }

  s.swift_version    = '5.0'
  s.source_files     = 'Sources/**/*.{swift,h}'

  s.ios.deployment_target     = '9.0'
  s.osx.deployment_target     = '10.10'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target    = '9.0'
end
