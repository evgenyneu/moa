import UIKit
import XCTest

class MoaLoggerTests: XCTestCase {
  override func tearDown() {
    super.tearDown()
    
    StubHttp.removeAllStubs()
  }
  
  var logTypes = [MoaLogType]()
  var logUrls = [String]()
  var logStatusCodes = [Int?]()
  
  func testLogger(type: MoaLogType, url: String, statusCode: Int?) {
    logTypes.append(type)
    logUrls.append(url)
    logStatusCodes.append(statusCode)
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
    }
  }
}