Pod::Spec.new do |s|

  s.name         = "VideoPlayerKit"

  s.ios.deployment_target = '13.0'
  
  s.swift_version = '5.0'
  s.swift_versions = ['5.0']

  s.requires_arc = true

  s.version      = "0.1.0"
  s.summary      = "video player lib"
  s.description  = <<-DESC
                  AlbumUIKit
                  DESC

  s.homepage          = "https://github.com"
  s.license           = "MIT"
  s.author            = { "sera" => "" }

  s.source       = { :git => "https://github.com", :tag => s.version.to_s }
  
  s.vendored_frameworks = "Frameworks/VideoPlayerKit.framework"

  s.resource_bundles = {
      'VideoPlayerKit' => ['Resources/*']
  }
  
  s.dependency "SnapKit"
  s.dependency "BasicKit"
  s.dependency "BasicUIKit"
  s.dependency "AliPlayerSDK_iOS"
  
end

