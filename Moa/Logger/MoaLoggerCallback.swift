import Foundation

/**

A logger closure.

Parameters:

1. Type of the log.
2. URL of the request.
3. Http status code, if applicable.
4. Error object, if applicable. Read its localizedDescription property to get a human readable error description.

*/
public typealias MoaLoggerCallback = (MoaLogType, String, Int?, Error?)->()
