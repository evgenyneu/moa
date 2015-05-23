Pod::Spec.new do |s|
  s.name        = "moa"
  s.version     = "1.0.10"
  s.license     = { :type => "MIT" }
  s.homepage    = "https://github.com/evgenyneu/moa"
  s.summary     = "Image downloader for iOS/Swift."
  s.authors     = { "Evgenii Neumerzhitckii" => "sausageskin@gmail.com" }
  s.source      = { :git => "https://github.com/evgenyneu/moa.git", :tag => "v1.0.10"}
  s.source_files = "Moa/*.swift"
  s.ios.deployment_target = "8.0"
end