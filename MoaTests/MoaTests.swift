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
  
  func testLoadImage() {
    StubHttp.withYellowImage("yellow.jpg")
    let responseArrived = expectationWithDescription("response arrived")

    let moa = Moa()
    moa.url = "http://evgenii.com/moa/yellow.jpg"
    
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
    StubHttp.withImage("yellow.png", forUrlPart: "yellow.jpg", statusCode: 404)
    let responseArrived = expectationWithDescription("response arrived")
    
    let moa = Moa()
    moa.url = "http://evgenii.com/moa/yellow.jpg"
    
    let timer = MoaTimer.runAfter(0.1) { timer in
      responseArrived.fulfill()
    }
    
    waitForExpectationsWithTimeout(1) { error in }
    XCTAssert(moa.image == nil)
  }
  
  func testLoadImage_ErrorWhenResponseIsNotAnImageType() {
    StubHttp.withImage("yellow.png",
      forUrlPart: "yellow.jpg",
      responseHeaders: ["Content-Type": "text/html"])

    let responseArrived = expectationWithDescription("response arrived")
    
    let moa = Moa()
    moa.url = "http://evgenii.com/moa/yellow.jpg"
    
    let timer = MoaTimer.runAfter(0.1) { timer in
      responseArrived.fulfill()
    }
    
    waitForExpectationsWithTimeout(1) { error in }
    XCTAssert(moa.image == nil)
  }
  
  func testLoadImage_ErrorWhenResponseDataIsNotImage() {
    StubHttp.withImage("text.txt", forUrlPart: "yellow.jpg")
    
    let responseArrived = expectationWithDescription("response arrived")
    
    let moa = Moa()
    moa.url = "http://evgenii.com/moa/yellow.jpg"
    
    let timer = MoaTimer.runAfter(0.1) { timer in
      responseArrived.fulfill()
    }
    
    waitForExpectationsWithTimeout(1) { error in }
    XCTAssert(moa.image == nil)
  }
  
  // MARK: - Cancelling download
  
  func testCancellingDownload() {
    // Make yellow image reponse slow so it received in 0.3 seconds
    StubHttp.withImage("yellow.png", forUrlPart: "yellow.jpg", statusCode: 200, responseTime: 0.3)
    
    StubHttp.withGreenImage("green.jpg")

    let responseArrived = expectationWithDescription("response arrived")
    
    let moa = Moa()
    moa.url = "http://evgenii.com/moa/yellow.jpg"
    
    // Request green image image before yellow image download has finished
    let timerChangeImage = MoaTimer.runAfter(0.01) { timer in
      moa.url = "http://evgenii.com/moa/green.jpg"
    }
    
    var image: UIImage?
    
    let timerWaitingForFish = MoaTimer.runAfter(0.5) { timer in
      // Wait more than 0.3 seconds (yellow response) to make sure it never comes back
      // Which proves that yellow image download was cancelled
      image = moa.image
      responseArrived.fulfill()
    }
    
    waitForExpectationsWithTimeout(2) { error in }
    
    let color = MoaImage.pixelColorAtImageCenter(image!)
    XCTAssertEqual(UIColor.greenColor(), color)
  }
}