
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
  
  Respond to existing download requests with the supplied image.
  
  :param: image: Image that will be passed to success handler
  
  */
  public func respondWithImage(image: UIImage) {
    onSuccess?(image)
  }
  
  /**
  
  Respond to existing download requests with the error.
  
  */
  public func respondWithError(error: NSError? = nil, response: NSHTTPURLResponse? = nil) {
    onError?(error ?? MoaHttpImageErrors.SimulatedError.new, response)
  }
}