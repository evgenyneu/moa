import Foundation

/**

Shortcut function for creating NSURLSessionDataTask.

*/
struct MoaHttp {
  static func createDataTask(_ url: String,
    onSuccess: (Data?, HTTPURLResponse)->(),
    onError: (NSError?, HTTPURLResponse?)->()) -> URLSessionDataTask? {
      
    if let nsUrl = URL(string: url) {
      return createDataTask(nsUrl, onSuccess: onSuccess, onError: onError)
    }
    
    // Error converting string to NSURL
    onError(MoaError.invalidUrlString.nsError, nil)
    return nil
  }
  
  private static func createDataTask(_ nsUrl: URL,
    onSuccess: (Data?, HTTPURLResponse)->(),
    onError: (NSError?, HTTPURLResponse?)->()) -> URLSessionDataTask? {
      
    return MoaHttpSession.session?.dataTask(with: nsUrl) { (data, response, error) in
      if let httpResponse = response as? HTTPURLResponse {
        if error == nil {
          onSuccess(data, httpResponse)
        } else {
          onError(error, httpResponse)
        }
      } else {
        onError(error, nil)
      }
    }
  }
}
