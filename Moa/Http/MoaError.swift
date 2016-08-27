import Foundation

/**
 
 Errors reported by the moa downloader
 
*/
public enum MoaError: Error {
  /// Incorrect URL is supplied. Error code: 0.
  case invalidUrlString
  
  /// Response HTTP status code is not 200. Error code: 1.
  case httpStatusCodeIsNot200
  
  /// Response is missing Content-Type http header. Error code: 2.
  case missingResponseContentTypeHttpHeader
  
  /// Response Content-Type http header is not an image type. Error code: 3.
  case notAnImageContentTypeInResponseHttpHeader
  
  /// Failed to convert response data to UIImage. Error code: 4.
  case failedToReadImageData
  
  /// Simulated error used in unit tests. Error code: 5.
  case simulatedError
  
  /// A human-friendly error description.
  var localizedDescription: String {
    let comment = "Moa image downloader error"
  
    switch self {
    case .invalidUrlString:
      return NSLocalizedString("Invalid URL.", comment: comment)
    
    case .httpStatusCodeIsNot200:
      return NSLocalizedString("Response HTTP status code is not 200.", comment: comment)
      
    case .missingResponseContentTypeHttpHeader:
      return NSLocalizedString("Response HTTP header is missing content type.", comment: comment)
      
    case .notAnImageContentTypeInResponseHttpHeader:
      return NSLocalizedString("Response content type is not an image type. Content type needs to be  'image/jpeg', 'image/pjpeg', 'image/png' or 'image/gif'",
        comment: comment)
      
    case .failedToReadImageData:
      return NSLocalizedString("Could not convert response data to an image format.",
        comment: comment)
      
    case .simulatedError:
      return NSLocalizedString("Test error.", comment: comment)
    }
  }
  
  var code: Int {
    return (self as Error)._code
  }
}
