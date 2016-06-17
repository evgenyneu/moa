import UIKit
import XCTest

class MoaLoggerTests: XCTestCase {
  override func tearDown() {
    super.tearDown()
    
    StubHttp.removeAllStubs()
    Moa.logger = nil
  }
  
  var logTypes = [MoaLogType]()
  var logUrls = [String]()
  var logStatusCodes = [Int?]()
  var logErrors = [NSError?]()
  
  func testLogger(type: MoaLogType, url: String, statusCode: Int?, error: NSError?) {
    logTypes.append(type)
    logUrls.append(url)
    logStatusCodes.append(statusCode)
    logErrors.append(error)
  }
  
  func testLogger_loadImage() {
    StubHttp.with96pxPngImage()
    Moa.logger = testLogger
    
    let moa = Moa()
    var imageResponse: UIImage?
    
    moa.onSuccessAsync = { image in
      imageResponse = image
      return nil
    }
    
    moa.onErrorAsync = { _, _ in }
    
    moa.url = "http://evgenii.com/moa/96px.png"
    
    // Log the request
    // -------------
    
    XCTAssertEqual(1, logTypes.count)
    XCTAssertEqual(MoaLogType.RequestSent, logTypes[0])
    XCTAssertEqual("http://evgenii.com/moa/96px.png", logUrls[0])
    XCTAssert(logStatusCodes[0] == nil)
    
    moa_eventually(imageResponse != nil) {
      // Log the successful response
      // -------------
      
      XCTAssertEqual(2, self.logTypes.count)
      XCTAssertEqual(MoaLogType.ResponseSuccess, self.logTypes[1])
      XCTAssertEqual("http://evgenii.com/moa/96px.png", self.logUrls[1])
      XCTAssertEqual(200, self.logStatusCodes[1])
      XCTAssert(self.logErrors[1] == nil)
    }
  }
  
  func testLoadImage_noInternetConnectionError() {
    Moa.logger = testLogger

    // Code: -1009
    let notConnectedErrorCode = Int(CFNetworkErrors.CFURLErrorNotConnectedToInternet.rawValue)
    
    let notConnectedError = NSError(domain: NSURLErrorDomain,
      code: notConnectedErrorCode, userInfo: nil)
    
    StubHttp.withError(notConnectedError, forUrlPart: "96px.png")
    
    let moa = Moa()
    var errorResponse: NSError?
    
    moa.onSuccessAsync = { image in return nil }
    
    moa.onErrorAsync = { error, _ in
      errorResponse = error
    }
    
    moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(errorResponse != nil) {
      // Log the error response
      // -------------
      
      XCTAssertEqual(2, self.logTypes.count)
      XCTAssertEqual(MoaLogType.ResponseError, self.logTypes[1])
      XCTAssertEqual("http://evgenii.com/moa/96px.png", self.logUrls[1])
      XCTAssert(self.logStatusCodes[1] == nil)
      XCTAssertEqual("The operation couldn’t be completed. (NSURLErrorDomain error -1009.)",
        self.logErrors[1]!.localizedDescription)
    }
  }
  
  func testCancelDownloadBySettingNilUrl() {
    Moa.logger = testLogger

    // Make 96px.png image reponse is slow so it is received in 0.3 seconds
    StubHttp.withImage("96px.png", forUrlPart: "96px.png", statusCode: 200, responseTime: 0.3)
    
    let moa = Moa()
    
    moa.onSuccessAsync = { _ in
      return nil
    }
    
    moa.onErrorAsync = { _, _ in }
    
    moa.url = "http://evgenii.com/moa/96px.png"
    
    XCTAssertEqual(1, self.logTypes.count)

    
    // Set url property to nil before 96px.png image has arrived
    MoaTimer.runAfter(0.01) { timer in
      moa.url = nil
    }
    
    // Wait more than 0.3 seconds (96px.png image response) to make sure it never comes back.
    // It proves that 96px.png image download was cancelled.
    moa_eventually(0.5) {
      // Log the reponse cancel
      // -------------
      
      XCTAssertEqual(2, self.logTypes.count)
      XCTAssertEqual(MoaLogType.RequestCancelled, self.logTypes[1])
      XCTAssertEqual("http://evgenii.com/moa/96px.png", self.logUrls[1])
      XCTAssert(self.logStatusCodes[1] == nil)
      XCTAssert(self.logErrors[1] == nil)
    }
  }

}