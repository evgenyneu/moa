
import Foundation

/**

Helper functions for downloading an image and processing the response.

*/
struct MoaHttpImage {
  static func createDataTask(_ url: String,
    onSuccess: (MoaImage)->(),
    onError: (NSError?, HTTPURLResponse?)->()) -> URLSessionDataTask? {
    
    return MoaHttp.createDataTask(url,
      onSuccess: { data, response in
        self.handleSuccess(data, response: response, onSuccess: onSuccess, onError: onError)
      },
      onError: onError
    )
  }
  
  static func handleSuccess(_ data: Data?,
    response: HTTPURLResponse,
    onSuccess: (MoaImage)->(),
    onError: (NSError, HTTPURLResponse?)->()) {
      
    // Show error if response code is not 200
    if response.statusCode != 200 {
      onError(MoaError.httpStatusCodeIsNot200.nsError, response)
      return
    }
    
    // Ensure response has the valid MIME type
    if let mimeType = response.mimeType {
      if !validMimeType(mimeType) {
        // Not an image Content-Type http header
        let error = MoaError.notAnImageContentTypeInResponseHttpHeader.nsError
        onError(error, response)
        return
      }
    } else {
      // Missing Content-Type http header
      let error = MoaError.missingResponseContentTypeHttpHeader.nsError
      onError(error, response)
      return
    }
      
    if let data = data, image = MoaImage(data: data) {
      onSuccess(image)
    } else {
      // Failed to convert response data to UIImage
      let error = MoaError.failedToReadImageData.nsError
      onError(error, response)
    }
  }
  
  private static func validMimeType(_ mimeType: String) -> Bool {
    let validMimeTypes = ["image/jpeg", "image/jpg", "image/pjpeg", "image/png", "image/gif"]
    return validMimeTypes.contains(mimeType)
  }
}
