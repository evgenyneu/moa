Pod::Spec.new do |s|
  s.name        = "moa"
  s.version     = "1.0.37"
  s.license     = { :type => "MIT" }
  s.homepage    = "https://github.com/evgenyneu/moa"
  s.summary     = "An image download extension for UIImageView written in Swift."
  s.description  = <<-DESC
                   Moa is an image download library for iOS written in Swift.
                   It allows to download and show an image in UIImageView by setting its moa.url property.

                   * Images are downloaded asynchronously.
                   * Uses NSURLSession for networking and caching.
                   * Allows to configure cache size and policy.
                   * Can be used without UIImageView.
                   * Provides closure properties for image manipulation and error handling.
                   DESC
  s.authors     = { "Evgenii Neumerzhitckii" => "sausageskin@gmail.com" }
  s.source      = { :git => "https://github.com/evgenyneu/moa.git", :tag => s.version }
  s.screenshots  = "https://raw.githubusercontent.com/evgenyneu/moa/master/Graphics/Hunting_Moa.jpg"
  s.source_files = "Moa/*.swift"
  s.ios.deployment_target = "8.0"
end