import UIKit
import OHHTTPStubs

class StubHttp {
  class func removeAllStubs() {
    OHHTTPStubs.removeAllStubs()
  }
  
  class func with96pxPngImage() {
    let imageName = "96px.png"
    withImage(imageName, forUrlPart: imageName, responseHeaders: ["Content-Type": "image/png"])
  }
  
  class func with67pxPngImage() {
    let imageName = "67px.png"
    withImage(imageName, forUrlPart: imageName, responseHeaders: ["Content-Type": "image/png"])
  }
  
  class func with35pxJpgImage() {
    let imageName = "35px.jpg"
    withImage(imageName, forUrlPart: imageName, responseHeaders: ["Content-Type": "image/jpeg"])
  }
  
  class func requestUrlIncludes(urlPart:String) -> (NSURLRequest->Bool) {
    return { req in
      MoaString.contains(req.URL!.absoluteString!, substring: urlPart)
    }
  }
  
  private class func fixture(#filename: String,
    responseHeaders: [NSObject : AnyObject]?,
    statusCode: Int = 200,
    responseTime: NSTimeInterval = 0) -> (NSURLRequest->OHHTTPStubsResponse) {
      
    let filePath = NSBundle(forClass: self).pathForResource(filename, ofType: nil)!
    
    return { _ in
      var response = OHHTTPStubsResponse(fileAtPath: filePath,
        statusCode: Int32(statusCode), headers: responseHeaders)
      
      if responseTime > 0 {
        response = response.requestTime(0, responseTime: responseTime)
      }
      
      return response
    }
  }
  
  class func withImage(imageName: String,
    forUrlPart urlPart: String,
    responseHeaders: [NSObject : AnyObject]? = ["Content-Type": "image/png"],
    statusCode: Int = 200,
    responseTime: NSTimeInterval = 0) {
      
    OHHTTPStubs.stubRequestsPassingTest(requestUrlIncludes(urlPart),
      withStubResponse: fixture(filename: imageName,
        responseHeaders: responseHeaders,
        statusCode: statusCode,
        responseTime: responseTime)
      )
  }
  
  // MARK: - with text
  
  private class func fixture(#text: String,
    responseHeaders: [NSObject : AnyObject]?,
    statusCode: Int = 200,
    responseTime: NSTimeInterval = 0) -> (NSURLRequest->OHHTTPStubsResponse) {
      
      let data = text.dataUsingEncoding(NSUTF8StringEncoding)!
      
      return { _ in
        var response = OHHTTPStubsResponse(data: data,
          statusCode: Int32(statusCode), headers: responseHeaders)
        
        if responseTime > 0 {
          response = response.requestTime(0, responseTime: responseTime)
        }
        
        return response
      }
  }
  
  class func withText(text: String,
    forUrlPart urlPart: String,
    responseHeaders: [NSObject : AnyObject]? = ["Content-Type": "html/text"],
    statusCode: Int = 200,
    responseTime: NSTimeInterval = 0) {
      
      OHHTTPStubs.stubRequestsPassingTest(requestUrlIncludes(urlPart),
        withStubResponse: fixture(text: text,
          responseHeaders: responseHeaders,
          statusCode: statusCode,
          responseTime: responseTime)
      )
  }
}