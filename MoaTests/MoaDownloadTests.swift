import UIKit
import XCTest
import Moa

class MoaDownloadTests: XCTestCase {
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
    
    StubHttp.removeAllStubs()
  }
  
  func testLoadPngImage() {
    StubHttp.with96pxPngImage()
    let responseArrived = expectationWithDescription("response arrived")

    let moa = Moa()
    moa.url = "http://evgenii.com/moa/96px.png"
    
    var image: UIImage?

    let timer = MoaTimer.runAfter(0.01) { timer in
      if moa.image != nil {
        image = moa.image
        responseArrived.fulfill()
      }
    }
    
    waitForExpectationsWithTimeout(1) { error in }
    
    XCTAssertEqual(96, image!.size.width)
  }
  
  func testLoadJpegImage() {
    StubHttp.with35pxJpgImage()
    
    let responseArrived = expectationWithDescription("response arrived")
    
    let moa = Moa()
    moa.url = "http://evgenii.com/moa/35px.jpg"
    
    var image: UIImage?
    
    let timer = MoaTimer.runAfter(0.01) { timer in
      if moa.image != nil {
        image = moa.image
        responseArrived.fulfill()
      }
    }
    
    waitForExpectationsWithTimeout(1) { error in }
    
    XCTAssertEqual(35, image!.size.width)
  }

  func testLoadImage_ErrorWhenImageNotFound() {
    StubHttp.withImage("96px.png", forUrlPart: "96px.png", statusCode: 404)
    let responseArrived = expectationWithDescription("response arrived")
    
    let moa = Moa()
    moa.url = "http://evgenii.com/moa/96px.png"
    
    let timer = MoaTimer.runAfter(0.1) { timer in
      responseArrived.fulfill()
    }
    
    waitForExpectationsWithTimeout(1) { error in }
    XCTAssert(moa.image == nil)
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