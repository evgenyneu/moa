//
// Codes for image download errors
//

import Foundation

enum MoaHttpImageErrors: Int {
  case HttpStatusCodeIsNot200 = -1
  case MissingResponseContentTypeHttpHeader = -2
  case NotAnImageContentTypeInResponseHttpHeader = -3

  var new: NSError {
    return NSError(domain: "MoaHttpImageErrorDomain", code: rawValue, userInfo: nil)
  }
}