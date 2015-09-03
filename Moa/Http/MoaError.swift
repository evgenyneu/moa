import Foundation

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
  
  static func fromError(error: NSError) -> MoaError? {
    if !MoaString.contains(error.domain, substring: "MoaError") { return nil }
    
    switch error.code {
    case 0: return .InvalidUrlString
    case 1: return .HttpStatusCodeIsNot200
    case 2: return .MissingResponseContentTypeHttpHeader
    case 3: return .NotAnImageContentTypeInResponseHttpHeader
    case 4: return .FailedToReadImageData
    case 5: return .SimulatedError

    default: return nil
    }
  }
}