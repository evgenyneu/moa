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
  
  // MARK: - Download
  
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

  // MARK: - Cancelling download
  
  func testCancelDownload() {
    // Make 96px.png image reponse is slow so it is received in 0.3 seconds
    StubHttp.withImage("96px.png", forUrlPart: "96px.png", statusCode: 200, responseTime: 0.3)
    
    let responseArrived = expectationWithDescription("response arrived")
    
    let moa = Moa()
    moa.url = "http://evgenii.com/moa/96px.png"
    
    // Cancel download before 96px.png image has arrived
    let timerChangeImage = MoaTimer.runAfter(0.01) { timer in
      moa.cancel()
    }
    
    var image: UIImage?
    
    let timerWaitingForFish = MoaTimer.runAfter(0.5) { timer in
      // Wait more than 0.3 seconds (96px.png image response) to make sure it never comes back.
      // It proves that 96px.png image download was cancelled.
      image = moa.image
      responseArrived.fulfill()
    }
    
    waitForExpectationsWithTimeout(2) { error in }
    
    XCTAssert(image == nil)
  }
  
  func testCancelDownloadAutomaticalyWhenNewImageIsRequested() {
    // Make 96px.png image reponse is slow so it is received in 0.3 seconds
    StubHttp.withImage("96px.png", forUrlPart: "96px.png", statusCode: 200, responseTime: 0.3)
    
    StubHttp.with35pxJpgImage()

    let responseArrived = expectationWithDescription("response arrived")
    
    let moa = Moa()
    moa.url = "http://evgenii.com/moa/96px.png"
    
    // Request 35px.jpg image before 96px.png image has arrived
    let timerChangeImage = MoaTimer.runAfter(0.01) { timer in
      moa.url = "http://evgenii.com/moa/35px.jpg"
    }
    
    var image: UIImage?
    
    let timerWaitingForFish = MoaTimer.runAfter(0.5) { timer in
      // Wait more than 0.3 seconds (96px.png image response) to make sure it never comes back.
      // It proves that 96px.png image download was cancelled.
      image = moa.image
      responseArrived.fulfill()
    }
    
    waitForExpectationsWithTimeout(2) { error in }
    
    XCTAssertEqual(35, image!.size.width)
  }
}