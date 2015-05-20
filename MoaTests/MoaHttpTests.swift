import UIKit
import XCTest

class MoaHttpTests: XCTestCase {
  override func tearDown() {
    super.tearDown()
    
    StubHttp.removeAllStubs()
  }
  
  func testLoad() {
    StubHttp.withText("Hello world!", forUrlPart: "path")
    
    let responseArrived = expectationWithDescription("response arrived")
    
    var responseString: NSString?
    
    let dataDask = MoaHttp.createDataTask("http://server.net/path",
      onSuccess: { data, response in
        responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
      },
      onError: { error, response in }
    )
    
    dataDask?.resume()
    
    let timer = MoaTimer.runAfter(0.01) { timer in
      if responseString != nil {
        responseArrived.fulfill()
      }
    }
    
    waitForExpectationsWithTimeout(1) { error in }

    XCTAssertEqual("Hello world!", responseString!)
  }
}