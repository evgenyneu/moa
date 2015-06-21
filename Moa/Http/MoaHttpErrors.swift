import Foundation

/**

Http error types.

*/
public enum MoaHttpErrors: Int {
  /// Incorrect URL is supplied.
  case InvalidUrlString = -1
  
  internal var new: NSError {
    return NSError(domain: "MoaHttpErrorDomain", code: rawValue, userInfo: nil)
  }
}