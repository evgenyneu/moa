import Foundation

final class MoaHttpImageDownloader: MoaImageDownloader {
  var task: NSURLSessionDataTask?
  var cancelled = false
  
  var logger: MoaLoggerCallback?
  
  init(logger: MoaLoggerCallback?) {
    self.logger = logger
  }
  
  deinit {
    cancel()
  }
  
  func startDownload(url: String, onSuccess: (MoaImage)->(),
    onError: (NSError?, NSHTTPURLResponse?)->()) {
      
    logger?(.RequestSent, url, nil)
    
    cancelled = false
  
    task = MoaHttpImage.createDataTask(url,
      onSuccess: { [weak self] image in
        self?.logger?(.ResponseSuccess, url, 200)
        onSuccess(image)
      },
      onError: { [weak self] error, response in
        if let currentSelf = self where !currentSelf.cancelled {
          // Do not report error if task was manually cancelled
          self?.logger?(.ResponseError, url, response?.statusCode)
          onError(error, response)
        }
      }
    )
      
    task?.resume()
  }
  
  func cancel() {
    let url = task?.originalRequest?.URL?.absoluteString ?? ""
    logger?(.RequestCancelled, url, nil)
    
    task?.cancel()
    cancelled = true
  }
}