import UIKit
import XCTest

class MoaHttpTests: XCTestCase {
  override func tearDown() {
    super.tearDown()
    
    StubHttp.removeAllStubs()
  }
  
  func testLoad_allGood() {
    StubHttp.withText("Hello world!", forUrlPart: "server.net")
    
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
  
  func testLoad_error404NotFound() {
    StubHttp.withText("Hello world!", forUrlPart: "server.net", statusCode: 404)
    
    var successCalled = false
    var errorFromCallback: NSError?
    var httpUrlResponseFromCallback: NSHTTPURLResponse?
    
    let dataDask = MoaHttp.createDataTask("http://server.net/path",
      onSuccess: { data, response in
        successCalled = true
      },
      onError: { error, response in
        errorFromCallback = error
        httpUrlResponseFromCallback = response
      }
    )
    
    dataDask?.resume()
    
    moa_eventually(httpUrlResponseFromCallback != nil) {
      XCTAssertFalse(successCalled)
      XCTAssert(errorFromCallback == nil)
      XCTAssertEqual(404, httpUrlResponseFromCallback!.statusCode)
    }
  }
}