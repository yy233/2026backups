Pod::Spec.new do |s|

  s.name         = "APIKit"

  s.ios.deployment_target = '13.0'
  
  s.swift_version = '5.0'
  s.swift_versions = ['5.0']

  s.requires_arc = true

  s.version      = "0.3.1"
  s.summary      = "api lib"
  s.description  = <<-DESC
                    BasicKit
                   DESC

  s.homepage          = "https://github.com"
  s.license           = "MIT"
  s.author            = { "sera" => "" }

  s.source       = { :git => "https://github.com", :tag => s.version.to_s }
  
  s.vendored_frameworks = "Frameworks/APIKit.framework"

  s.dependency "Alamofire"
  s.dependency "Kingfisher"
  s.dependency "BasicKit"

end

