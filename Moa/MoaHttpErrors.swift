//
// Codes for http errors
//

import Foundation

enum MoaHttpErrors: Int {
  case InvalidUrlString = -1
  
  var new: NSError {
    return NSError(domain: "MoaHttpErrorDomain", code: rawValue, userInfo: nil)
  }
}