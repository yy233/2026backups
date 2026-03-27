Pod::Spec.new do |s|

  s.name         = "ImagePreviewKit"

  s.ios.deployment_target = '13.0'
  
  s.swift_version = '5.0'
  s.swift_versions = ['5.0']

  s.requires_arc = true

  s.version      = "0.1.0"
  s.summary      = "ui lib"
  s.description  = <<-DESC
                      BasicUIKit
                   DESC

  s.homepage          = "https://github.com"
  s.license           = "MIT"
  s.author            = { "sera" => "" }

  s.source       = { :git => "https://github.com", :tag => s.version.to_s }

  s.vendored_frameworks = "Frameworks/ImagePreviewKit.framework"

  s.dependency "BasicUIKit"
  s.dependency "AlbumUIKit"
end

