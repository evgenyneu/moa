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
    var errorFromCallback: NSError?
    var httpUrlResponseFromCallback: NSHTTPURLResponse?
    
    let dataDask = MoaHttp.createDataTask("http://server.net/path",
      onSuccess: { data, response in
        responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
      },
      onError: { error, response in
        errorFromCallback = error
        httpUrlResponseFromCallback = response
      }
    )
    
    dataDask?.resume()

    moa_eventually(responseString != nil) {
      XCTAssertEqual("Hello world!", responseString!)
      XCTAssert(errorFromCallback == nil)
      XCTAssert(httpUrlResponseFromCallback == nil)
    }
  }
  
  func testLoad_errorNotConnectedToInternet() {
    // Code: -1009
    let notConnectedErrorCode = Int(CFNetworkErrors.CFURLErrorNotConnectedToInternet.rawValue)

    let notConnectedError = NSError(domain: NSURLErrorDomain,
      code: notConnectedErrorCode, userInfo: nil)

    StubHttp.withError(notConnectedError, forUrlPart: "server.net")
    
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
    
    moa_eventually(errorFromCallback != nil) {
      XCTAssertFalse(successCalled)
      XCTAssertEqual(-1009, errorFromCallback!.code)
      XCTAssertEqual("NSURLErrorDomain", errorFromCallback!.domain)
      XCTAssert(httpUrlResponseFromCallback == nil)
    }
  }
  
  func testLoad_errorIncorrectUrl() {
    var successCalled = false
    var errorFromCallback: NSError?
    var httpUrlResponseFromCallback: NSHTTPURLResponse?
    
    let dataDask = MoaHttp.createDataTask("http://server.net/🐞",
      onSuccess: { data, response in
        successCalled = true
      },
      onError: { error, response in
        errorFromCallback = error
        httpUrlResponseFromCallback = response
      }
    )
    
    dataDask?.resume()
    
    moa_eventually(errorFromCallback != nil) {
      XCTAssertFalse(successCalled)
      XCTAssertEqual(MoaHttpErrors.InvalidUrlString.rawValue, errorFromCallback!.code)
      XCTAssertEqual("MoaHttpErrorDomain", errorFromCallback!.domain)
      XCTAssert(httpUrlResponseFromCallback == nil)
    }
  }  
}