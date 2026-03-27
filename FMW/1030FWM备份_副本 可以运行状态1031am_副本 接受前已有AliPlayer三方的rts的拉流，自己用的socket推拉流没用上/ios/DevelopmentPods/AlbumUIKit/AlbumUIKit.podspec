Pod::Spec.new do |s|

  s.name         = "AlbumUIKit"

  s.ios.deployment_target = '13.0'
  
  s.swift_version = '5.0'
  s.swift_versions = ['5.0']

  s.requires_arc = true

  s.version      = "0.2.6"
  s.summary      = "album lib"
  s.description  = <<-DESC
                  AlbumUIKit
                  DESC

  s.homepage          = "https://github.com"
  s.license           = "MIT"
  s.author            = { "sera" => "" }

  s.source       = { :git => "https://github.com", :tag => s.version.to_s }
  
  s.vendored_frameworks = "Frameworks/AlbumUIKit.framework"
  s.resource_bundles = {
    'AlbumUIKit' => ['Resources/*']
  }

  s.dependency "BasicUIKit"
  s.dependency "BasicKit"
  s.dependency "SnapKit"
end

