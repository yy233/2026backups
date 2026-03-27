Pod::Spec.new do |s|

  s.name         = "DOM"

  s.ios.deployment_target = '13.0'
  
  s.swift_version = '5.0'
  s.swift_versions = ['5.0']

  s.requires_arc = true

  s.version      = "0.0.1"
  s.summary      = "foundation lib"
  s.description  = <<-DESC
                    XML
                   DESC

  s.homepage          = "https://github.com"
  s.license           = "MIT"
  s.author            = { "sera" => "" }

  s.source       = { :git => "https://github.com", :tag => s.version.to_s }
  
  s.libraries = "xml2"
  s.vendored_frameworks = "Frameworks/DOM.framework"

end

