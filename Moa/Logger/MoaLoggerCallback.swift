
/**

A logger closure.

Parameters:

1. Type of the log.
2. URL of the request.
3. Http status code, if applicable.

*/
public typealias MoaLoggerCallback = (MoaLogType, String, Int?)->()
