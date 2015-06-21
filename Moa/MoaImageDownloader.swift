import Foundation

/// Downloads an image.
protocol MoaImageDownloader {
  func startDownload(url: String, onSuccess: (MoaImage)->(),
    onError: (NSError, NSHTTPURLResponse?)->())
  
  func cancel()
}
