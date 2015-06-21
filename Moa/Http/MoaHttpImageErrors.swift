import Foundation

/**

Image download error types.

*/
public enum MoaHttpImageErrors: Int {
  /// Response HTTP status code is not 200.
  case HttpStatusCodeIsNot200 = -1
  
  /// Response is missing Content-Type http header.
  case MissingResponseContentTypeHttpHeader = -2
  
  /// Response Content-Type http header is not an image type.
  case NotAnImageContentTypeInResponseHttpHeader = -3
  
  /// Failed to convert response data to UIImage.
  case FailedToReadImageData = -4

  internal var new: NSError {
    return NSError(domain: "MoaHttpImageErrorDomain", code: rawValue, userInfo: nil)
  }
}