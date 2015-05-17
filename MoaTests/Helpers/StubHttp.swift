import UIKit
import OHHTTPStubs

class StubHttp {
  class func removeAllStubs() {
    OHHTTPStubs.removeAllStubs()
  }
  
  class func withYellowImage(url: String) {
    withImage("yellow.png", forUrlPart: url)
  }
  
  private class func requestUrlIncludes(urlPart:String) -> (NSURLRequest->Bool) {
    return { req in
      MoaString.contains(req.URL!.absoluteString!, substring: urlPart)
    }
  }
  
  private class func fixture(filename: String,
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
      withStubResponse: fixture(imageName,
        responseHeaders: responseHeaders,
        statusCode: statusCode,
        responseTime: responseTime)
      )
  }
}