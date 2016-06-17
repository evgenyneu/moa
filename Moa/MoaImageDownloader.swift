import Foundation

/// Downloads an image.
protocol MoaImageDownloader {
  func startDownload(_ url: String, onSuccess: (MoaImage)->(),
    onError: (NSError?, HTTPURLResponse?)->())
  
  func cancel()
}
