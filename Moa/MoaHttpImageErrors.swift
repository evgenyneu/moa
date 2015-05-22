//
// Codes for image download errors
//

import Foundation

enum MoaHttpImageErrors: Int {
  case HttpStatusCodeIsNot200 = -1
  
  var new: NSError {
    return NSError(domain: "MoaHttpImageErrorDomain", code: rawValue, userInfo: nil)
  }
}