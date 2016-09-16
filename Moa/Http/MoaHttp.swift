import Foundation

/**

Shortcut function for creating URLSessionDataTask.

*/
struct MoaHttp {
  static func createDataTask(_ url: String,
    onSuccess: @escaping (Data?, HTTPURLResponse)->(),
    onError: @escaping (Error?, HTTPURLResponse?)->()) -> URLSessionDataTask? {
      
    if let urlObject = URL(string: url) {
      return createDataTask(urlObject: urlObject, onSuccess: onSuccess, onError: onError)
    }
    
    // Error converting string to NSURL
    onError(MoaError.invalidUrlString, nil)
    return nil
  }
  
  private static func createDataTask(urlObject: URL,
    onSuccess: @escaping (Data?, HTTPURLResponse)->(),
    onError: @escaping (Error?, HTTPURLResponse?)->()) -> URLSessionDataTask? {
      
    return MoaHttpSession.session?.dataTask(with: urlObject) { (data, response, error) in
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
