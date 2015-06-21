
import UIKit

/**

Simulates download of images in unit test. This downloader is used instead of the HTTP downloaded when the moa simulator is started: MoaSimulator.start().

*/
public final class MoaSimulatedImageDownloader: MoaImageDownloader {
  
  /// Url of the downloader.
  public let url: String
  
  /// Indicates if the request was cancelled.
  public var cancelled = false
  
  var onSuccess: ((MoaImage)->())?
  var onError: ((NSError, NSHTTPURLResponse?)->())?

  init(url: String) {
    self.url = url
  }
  
  func startDownload(url: String, onSuccess: (MoaImage)->(),
    onError: (NSError, NSHTTPURLResponse?)->()) {
      
    self.onSuccess = onSuccess
    self.onError = onError
  }
  
  func cancel() {
    cancelled = true
  }
  
  /**
  
  Simulate successful response by calling the success handler with the supplied image.
  
  :param: image: Image that will be passed to success handler
  
  */
  public func simulateSuccess(image: UIImage) {
    onSuccess?(image)
  }
  
  /**
  
  Simulate an error response by calling the error handler.
  
  */
  public func simulateError(error: NSError? = nil, response: NSHTTPURLResponse? = nil) {
    onError?(error ?? MoaHttpImageErrors.SimulatedError.new, response)
  }
}