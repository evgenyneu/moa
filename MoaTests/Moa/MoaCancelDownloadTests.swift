import UIKit
import XCTest

class MoaCancelDownloadTests: XCTestCase {  
  override func tearDown() {
    super.tearDown()
    
    StubHttp.removeAllStubs()
  }
  
  func testCancelDownload() {
    // Make 96px.png image reponse is slow so it is received in 0.3 seconds
    StubHttp.withImage("96px.png", forUrlPart: "96px.png", statusCode: 200, responseTime: 0.3)
    
    let moa = Moa()
    moa.url = "http://evgenii.com/moa/96px.png"
    
    // Cancel download before 96px.png image has arrived
    let timerChangeImage = MoaTimer.runAfter(0.01) { timer in
      moa.cancel()
    }
    
    // Wait more than 0.3 seconds (96px.png image response) to make sure it never comes back.
    // It proves that 96px.png image download was cancelled.
    moa_eventually(timeout: 0.5) {
      XCTAssert(moa.image == nil)
    }
  }
  
  func testCancelDownloadBySettingNilUrl() {
    // Make 96px.png image reponse is slow so it is received in 0.3 seconds
    StubHttp.withImage("96px.png", forUrlPart: "96px.png", statusCode: 200, responseTime: 0.3)
    
    let moa = Moa()
    moa.url = "http://evgenii.com/moa/96px.png"
    
    // Set url property to nil before 96px.png image has arrived
    let timerChangeImage = MoaTimer.runAfter(0.01) { timer in
      moa.url = nil
    }
    
    // Wait more than 0.3 seconds (96px.png image response) to make sure it never comes back.
    // It proves that 96px.png image download was cancelled.
    moa_eventually(timeout: 0.5) {
      XCTAssert(moa.image == nil)
    }
  }
  
  func testCancelDownloadAutomaticalyWhenNewImageIsRequested() {
    // Make 96px.png image reponse is slow so it is received in 0.3 seconds
    StubHttp.withImage("96px.png", forUrlPart: "96px.png", statusCode: 200, responseTime: 0.3)
    
    StubHttp.with35pxJpgImage()
    
    let moa = Moa()
    moa.url = "http://evgenii.com/moa/96px.png"
    
    // Request 35px.jpg image before 96px.png image has arrived
    let timerChangeImage = MoaTimer.runAfter(0.01) { timer in
      moa.url = "http://evgenii.com/moa/35px.jpg"
    }
    
    // Wait more than 0.3 seconds (96px.png image response) to make sure it never comes back.
    // It proves that 96px.png image download was cancelled.
    moa_eventually(timeout: 0.5) {
      XCTAssertEqual(35, moa.image!.size.width)
    }
  }
}