import UIKit
import OHHTTPStubs

class StubHttp {
  class func removeAllStubs() {
    OHHTTPStubs.removeAllStubs()
  }
  
  class func with96pxPngImage() {
    let imageName = "96px.png"
    withImage(imageName, forUrlPart: imageName, responseHeaders: ["Content-Type" as NSObject: "image/png" as AnyObject])
  }
  
  class func with67pxPngImage() {
    let imageName = "67px.png"
    withImage(imageName, forUrlPart: imageName, responseHeaders: ["Content-Type" as NSObject: "image/png" as AnyObject])
  }
  
  class func with35pxJpgImage() {
    let imageName = "35px.jpg"
    withImage(imageName, forUrlPart: imageName, responseHeaders: ["Content-Type" as NSObject: "image/jpeg" as AnyObject])
  }
  
  class func requestUrlIncludes(_ urlPart:String) -> ((URLRequest)->Bool) {
    return { req in
      MoaString.contains(req.url!.absoluteString, substring: urlPart)
    }
  }
  
  private class func fixture(filename: String,
    responseHeaders: [NSObject : AnyObject]?,
    statusCode: Int = 200,
    responseTime: TimeInterval = 0) -> ((URLRequest)->OHHTTPStubsResponse) {
      
    let filePath = Bundle(for: self).path(forResource: filename, ofType: nil)!
    
    return { _ in
      var response = OHHTTPStubsResponse(fileAtPath: filePath,
        statusCode: Int32(statusCode), headers: responseHeaders)
      
      if responseTime > 0 {
        response = response.requestTime(0, responseTime: responseTime)
      }
      
      return response
    }
  }
  
  class func withImage(_ imageName: String,
    forUrlPart urlPart: String,
    responseHeaders: [NSObject : AnyObject]? = ["Content-Type" as NSObject: "image/png" as AnyObject],
    statusCode: Int = 200,
    responseTime: TimeInterval = 0) {
      
    OHHTTPStubs.stubRequests(passingTest: requestUrlIncludes(urlPart),
      withStubResponse: fixture(filename: imageName,
        responseHeaders: responseHeaders,
        statusCode: statusCode,
        responseTime: responseTime)
      )
  }
  
  // MARK: - with text
  
  private class func fixture(text: String,
    responseHeaders: [NSObject : AnyObject]?,
    statusCode: Int = 200,
    responseTime: TimeInterval = 0) -> ((URLRequest)->OHHTTPStubsResponse) {
      
    let data = text.data(using: String.Encoding.utf8)!
    
    return { _ in
      var response = OHHTTPStubsResponse(data: data,
        statusCode: Int32(statusCode), headers: responseHeaders)
      
      if responseTime > 0 {
        response = response.requestTime(0, responseTime: responseTime)
      }
      
      return response
    }
  }
  
  class func withText(_ text: String,
    forUrlPart urlPart: String,
    responseHeaders: [NSObject : AnyObject]? = ["Content-Type" as NSObject: "html/text" as AnyObject],
    statusCode: Int = 200,
    responseTime: TimeInterval = 0) {
      
    OHHTTPStubs.stubRequests(passingTest: requestUrlIncludes(urlPart),
      withStubResponse: fixture(text: text,
        responseHeaders: responseHeaders,
        statusCode: statusCode,
        responseTime: responseTime)
    )
  }
  
  // MARK: - with error
  
  class func withError(_ error: Error,
    forUrlPart urlPart: String) {
      
    let errorResponse = OHHTTPStubsResponse(error: error)
    
    OHHTTPStubs.stubRequests(passingTest: requestUrlIncludes(urlPart),
      withStubResponse: { _ in errorResponse }
    )
  }
}
