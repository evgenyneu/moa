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
  
  var localizedDescription: String {
    let comment = "Moa image downloader error"
  
    switch self {
    case .InvalidUrlString:
      return NSLocalizedString("Invalid URL.", comment: comment)
    
    case .HttpStatusCodeIsNot200:
      return NSLocalizedString("Response HTTP status code is not 200.", comment: comment)
      
    case .MissingResponseContentTypeHttpHeader:
      return NSLocalizedString("Response HTTP header is missing content type.", comment: comment)
      
    case .NotAnImageContentTypeInResponseHttpHeader:
      return NSLocalizedString("Response content type is not an image type. Content type needs to be  'image/jpeg', 'image/pjpeg' or 'image/png'",
        comment: comment)
      
    case .FailedToReadImageData:
      return NSLocalizedString("Could not convert response data to an image format.",
        comment: comment)
      
    case .SimulatedError:
      return NSLocalizedString("Test error.", comment: comment)
    }
  }
  
  var code: Int {
    return (self as NSError).code
  }
  
  var nsError: NSError {
    return NSError(
      domain: "MoaError",
      code: code,
      userInfo: [NSLocalizedDescriptionKey: localizedDescription])
  }
}