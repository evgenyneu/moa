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
      
    logger?(.RequestUrl, url, nil)
    
    cancelled = false
  
    task = MoaHttpImage.createDataTask(url,
      onSuccess: { [weak self] image in
        self?.logger?(.ResponseSuccessUrl, url, 200)
        onSuccess(image)
      },
      onError: { [weak self] error, response in
        self?.logger?(.ResponseErrorUrl, url, response?.statusCode)

        if let currentSelf = self
          where !currentSelf.cancelled { // Do not report error if task was manually cancelled
    
          onError(error, response)
        }
      }
    )
      
    task?.resume()
  }
  
  func cancel() {
    let url = task?.originalRequest?.URL?.absoluteString ?? nil
    logger?(.RequestCancelUrl, url, nil)
    
    task?.cancel()
    cancelled = true
  }
}