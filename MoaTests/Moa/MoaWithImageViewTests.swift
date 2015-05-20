import UIKit
import XCTest

class MoaWithImageViewTests: XCTestCase {
  override func tearDown() {
    super.tearDown()
    
    StubHttp.removeAllStubs()
  }
  
  func testSetImageToImageView() {
    StubHttp.with96pxPngImage()
    let responseArrived = expectationWithDescription("response arrived")
    
    let imageView = UIImageView()
    
    let moa = Moa()
    moa.imageView = imageView
    moa.url = "http://evgenii.com/moa/96px.png"
        
    let timer = MoaTimer.runAfter(0.01) { timer in
      if moa.imageView?.image != nil {
        responseArrived.fulfill()
      }
    }
    
    waitForExpectationsWithTimeout(1) { error in }
    
    XCTAssertEqual(96, moa.imageView!.image!.size.width)
  }
}