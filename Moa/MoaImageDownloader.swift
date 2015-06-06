import Foundation
    
final class MoaImageDownloader {
  var task: NSURLSessionDataTask?
  var cancelled = false
  
  deinit {
    cancel()
  }
  
  func startDownload(url: String, onSuccess: (MoaImage)->(),
    onError: (NSError, NSHTTPURLResponse?)->()) {
    
    cancelled = false
  
    task = MoaHttpImage.createDataTask(url,
      onSuccess: onSuccess,
      onError: { [weak self] error, response in
        if let currentSelf = self
          where !currentSelf.cancelled { // Do not report error if task was manually cancelled
    
          onError(error, response)
        }
      }
    )
      
    task?.resume()
  }
  
  func cancel() {
    task?.cancel()
    cancelled = true
  }
}