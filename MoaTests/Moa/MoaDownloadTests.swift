import UIKit
import XCTest

class MoaDownloadTests: XCTestCase {
  
  override func tearDown() {
    super.tearDown()
    
    StubHttp.removeAllStubs()
  }
  
  func testLoadPngImage() {
    StubHttp.with96pxPngImage()

    let moa = Moa()
    moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(moa.image != nil) {
      XCTAssertEqual(96, moa.image!.size.width)
    }
  }
  
  func testLoadJpegImage() {
    StubHttp.with35pxJpgImage()
        
    let moa = Moa()
    moa.url = "http://evgenii.com/moa/35px.jpg"
    
    moa_eventually(moa.image != nil) {
      XCTAssertEqual(35, moa.image!.size.width)
    }
  }

  func testLoadImage_ErrorWhenImageNotFound() {
    StubHttp.withImage("96px.png", forUrlPart: "96px.png", statusCode: 404)
    
    let moa = Moa()
    moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(timeout: 0.1) {
      XCTAssert(moa.image == nil)
    }
  }

  func testLoadImage_ErrorWhenResponseIsNotAnImageType() {
    StubHttp.withImage("96px.png", forUrlPart: "96px.png",
      responseHeaders: ["Content-Type": "text/html"])

    let responseArrived = expectationWithDescription("response arrived")
    
    let moa = Moa()
    moa.url = "http://evgenii.com/moa/96px.png"
    
    let timer = MoaTimer.runAfter(0.1) { timer in
      responseArrived.fulfill()
    }
    
    waitForExpectationsWithTimeout(1) { error in }
    XCTAssert(moa.image == nil)
  }

  func testLoadImage_ErrorWhenResponseDataIsNotImage() {
    StubHttp.withImage("text.txt", forUrlPart: "96px.png")
    
    let responseArrived = expectationWithDescription("response arrived")
    
    let moa = Moa()
    moa.url = "http://evgenii.com/moa/96px.png"
    
    let timer = MoaTimer.runAfter(0.1) { timer in
      responseArrived.fulfill()
    }
    
    waitForExpectationsWithTimeout(1) { error in }
    XCTAssert(moa.image == nil)
  }
}