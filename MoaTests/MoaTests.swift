import UIKit
import XCTest
import Moa

class MoaTests: XCTestCase {
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
    
    StubHttp.removeAllStubs()
  }
  
  func testLoadImage() {
    StubHttp.withYellowImage("ant.jpg")
    let responseArrived = expectationWithDescription("response arrived")

    let moa = Moa()
    moa.url = "http://evgenii.com/moa/ant.jpg"
    
    var image: UIImage?

    let timer = MoaTimer.runAfter(0.01) { timer in
      if moa.image != nil {
        image = moa.image
        responseArrived.fulfill()
      }
    }
    
    waitForExpectationsWithTimeout(1) { error in }
    
    let color = MoaImage.pixelColorAtImageCenter(image!)
    XCTAssertEqual(UIColor.yellowColor(), color)
  }
  
  func testLoadImage_ErrorWhenImageNotFound() {
    StubHttp.withImage("yellow.png", forUrlPart: "ant.jpg", statusCode: 404)
    let responseArrived = expectationWithDescription("response arrived")
    
    let moa = Moa()
    moa.url = "http://evgenii.com/moa/ant.jpg"
    
    let timer = MoaTimer.runAfter(0.01) { timer in
      responseArrived.fulfill()
    }
    
    waitForExpectationsWithTimeout(1) { error in }
    XCTAssert(moa.image == nil)
  }
  
  func testLoadImage_ErrorWhenResponseIsNotImage() {
    StubHttp.withImage("yellow.png",
      forUrlPart: "ant.jpg",
      responseHeaders: ["Content-Type": "text/html"])

    let responseArrived = expectationWithDescription("response arrived")
    
    let moa = Moa()
    moa.url = "http://evgenii.com/moa/ant.jpg"
    
    let timer = MoaTimer.runAfter(0.01) { timer in
      responseArrived.fulfill()
    }
    
    waitForExpectationsWithTimeout(1) { error in }
    XCTAssert(moa.image == nil)
  }
  
  func testCancellingDownload() {
//    let moa = Moa()
//    moa.url = "http://evgenii.com/moa/ant.jpg"
    
    
  }
}