/**

Types of log messages.

*/
public enum MoaLogType: Int{
  /// Request is sent
  case requestSent
  
  /// Request is cancelled
  case requestCancelled
  
  /// Successful response is received
  case responseSuccess
  
  /// Response error is received
  case responseError
}
