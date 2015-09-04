import Foundation

/**

A helper function that creates a human readable text from log arguments.

Usage:

    Moa.logger = { type, url, statusCode, error in

      let text = MoaLoggerText(type: type, url: url, statusCode: statusCode, error: error)
      // Log log text to your destination
    }

For logging into Xcode console you can use MoaConsoleLogger function.

    Moa.logger = MoaConsoleLogger

*/
public func MoaLoggerText(type: MoaLogType, url: String, statusCode: Int?,
  error: NSError?) -> String {
  
  let time = MoaTime.nowIso8601Utc
  var text = "[moa] \(time) "
  var suffix = ""
  
  switch type {
  case .RequestSent:
    text += "GET "
  case .RequestCancelled:
    text += "Cancelled "
  case .ResponseSuccess:
    text += "Received "
  case .ResponseError:
    text += "Error "
    
    if let statusCode = statusCode {
      text += "\(statusCode) "
    }
    
    if let error = error {
      suffix = error.localizedDescription
    }
  }
  
  text += url
  
  if suffix != "" {
    text += " \(suffix)"
  }
  
  return text
}