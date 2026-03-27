Pod::Spec.new do |s|

  s.name         = "LocationKit"

  s.ios.deployment_target = '13.0'
  
  s.swift_version = '5.0'
  s.swift_versions = ['5.0']

  s.requires_arc = true

  s.version      = "0.1.0"
  s.summary      = "location lib"
  s.description  = <<-DESC
                    LocationKit
                   DESC

  s.homepage          = "https://github.com"
  s.license           = "MIT"
  s.author            = { "sera" => "" }

  s.source       = { :git => "https://github.com", :tag => s.version.to_s }
  
  s.vendored_frameworks = "Frameworks/LocationKit.framework"

  s.dependency "BasicKit"

end

