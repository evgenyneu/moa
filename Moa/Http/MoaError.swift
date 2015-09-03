enum MoaError: ErrorType {
  /// Incorrect URL is supplied. Error code: 0.
  case InvalidUrlString
  
  /// Response HTTP status code is not 200. Error code: 1.
  case HttpStatusCodeIsNot200
  
  /// Response is missing Content-Type http header. Error code: 2.
  case MissingResponseContentTypeHttpHeader
  
  /// Response Content-Type http header is not an image type. Error code: 3.
  case NotAnImageContentTypeInResponseHttpHeader
  
  /// Failed to convert response data to UIImage. Error code: 4.
  case FailedToReadImageData
  
  /// Simulated error used in unit tests. Error code: 5.
  case SimulatedError
}