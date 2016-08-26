import Foundation

/**

Logs image download requests, responses and errors to Xcode console for debugging.

Usage:

    Moa.logger = MoaConsoleLogger

*/
public func MoaConsoleLogger(_ type: MoaLogType, url: String, statusCode: Int?, error: Error?) {
  let text = MoaLoggerText(type, url: url, statusCode: statusCode, error: error)
  print(text)
}
