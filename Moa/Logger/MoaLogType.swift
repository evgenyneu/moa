/**

Types of log messages.

*/
public enum MoaLogType: Int{
  /// Request is sent
  case RequestSent
  
  /// Request is cancelled
  case RequestCancelled
  
  /// Successful response is received
  case ResponseSuccess
  
  /// Response error is received
  case ResponseError
}
