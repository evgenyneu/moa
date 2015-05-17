import UIKit
import OHHTTPStubs

class StubHttp {
  class func removeAllStubs() {
    OHHTTPStubs.removeAllStubs()
  }
  
  class func withYellowImage(url: String) {
    withImage("yelow.png", forUrlPart: url)
  }
  
  private class func withImage(imageName: String, forUrlPart url: String) {
    OHHTTPStubs.stubRequestsPassingTest({
      MoaString.contains($0.URL!.absoluteString!, substring: url)
    }) { _ in
      let imagePath = OHPathForFile(imageName, self)!
      
      return OHHTTPStubsResponse(fileAtPath: imagePath,
        statusCode: 200,
        headers: ["Content-Type": "image/png"])
    }
  }
}