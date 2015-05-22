import UIKit
import XCTest

class MoaHttpTests: XCTestCase {
  override func tearDown() {
    super.tearDown()
    
    StubHttp.removeAllStubs()
  }
  
  func testLoad() {
    StubHttp.withText("Hello world!", forUrlPart: "path")
    
    var responseString: NSString?
    
    let dataDask = MoaHttp.createDataTask("http://server.net/path",
      onSuccess: { data, response in
        responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
      },
      onError: { error, response in }
    )
    
    dataDask?.resume()

    moa_eventually(responseString != nil) {
      XCTAssertEqual("Hello world!", responseString!)
    }
  }
}