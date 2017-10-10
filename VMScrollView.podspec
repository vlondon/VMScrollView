Pod::Spec.new do |s|

  s.name         = "VMScrollView"
  s.version      = "1.0.1"
  s.summary      = "Infinite horizontal scrolling view with parallax effect."

  s.homepage     = "https://github.com/vlondon/VMScrollView"
  
  s.license      = "MIT"

  s.author       = { "Vladimirs Matusevics" => "vladimir.matusevic@gmail.com" }
  
  s.platform     = :ios, "11.0"

  s.source       = { :git => "https://github.com/vlondon/VMScrollView.git", :tag => "1.0.1" }

  s.source_files  = ["VMScrollView/*"]
  s.exclude_files = ["VMScrollViewDemo/*"]

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

end
