/**

Types of log messages.

*/
public enum MoaLogType: Int{
  /// String containing request URL
  case RequestUrl
  
  /// String containing request URL
  case ResponseSuccessUrl
  
  /// Contains reponse error message for HTTP error like "No internet connection"
  case ResponseErrorUrl
  
  /// Sent when request is cancelled
  case RequestCancelUrl
}
