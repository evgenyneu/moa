import UIKit

class MoaImageDownloader {
  private var task: NSURLSessionDataTask?
  
  deinit {
    cancel()
  }
  
  func startDownload(url: String, onSuccess: (UIImage)->(),
    onError: (NSError?, NSHTTPURLResponse?)->()) {
    
    task = MoaHttpImage.createDataTask(url,
      onSuccess: onSuccess,
      onError: onError)
      
    task?.resume()
  }
  
  private func cancel() {
    task?.cancel()
    task = nil
  }
}