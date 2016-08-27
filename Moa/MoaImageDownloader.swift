import Foundation

/// Downloads an image.
protocol MoaImageDownloader {
  func startDownload(_ url: String, onSuccess: @escaping (MoaImage)->(),
    onError: @escaping (Error?, HTTPURLResponse?)->())
  
  func cancel()
}
