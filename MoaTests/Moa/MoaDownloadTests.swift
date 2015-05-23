import UIKit
import XCTest

class MoaDownloadTests: XCTestCase {
  override func tearDown() {
    super.tearDown()
    
    StubHttp.removeAllStubs()
  }
  
  func testLoadPngImage() {
    StubHttp.with96pxPngImage()

    var imageResponse: UIImage?
    let moa = Moa()
    moa.url = "http://evgenii.com/moa/96px.png"

    moa.onSuccessAsync = { image in
      imageResponse = image
      return nil
    }
    
    moa_eventually(imageResponse != nil) {
      XCTAssertEqual(96, imageResponse!.size.width)
    }
  }
  
  func testLoadJpegImage() {
    StubHttp.with35pxJpgImage()
    
    var imageResponse: UIImage?
    let moa = Moa()
    moa.url = "http://evgenii.com/moa/35px.jpg"
    
    moa.onSuccessAsync = { image in
      imageResponse = image
      return nil
    }
    
    moa_eventually(imageResponse != nil) {
      XCTAssertEqual(35, imageResponse!.size.width)
    }
  }

  func testLoadImage_errorWhenImageNotFound() {
    StubHttp.withImage("96px.png", forUrlPart: "96px.png", statusCode: 404)
    
    var imageResponse: UIImage?
    let moa = Moa()
    moa.url = "http://evgenii.com/moa/96px.png"
    
    moa.onSuccessAsync = { image in
      imageResponse = image
      return nil
    }
    
    moa_eventually {
      XCTAssert(imageResponse == nil)
    }
  }

  func testLoadImage_errorWhenResponseIsNotAnImageType() {
    StubHttp.withImage("96px.png", forUrlPart: "96px.png",
      responseHeaders: ["Content-Type": "text/html"])
    
    var imageResponse: UIImage?
    let moa = Moa()
    moa.url = "http://evgenii.com/moa/96px.png"
    
    moa.onSuccessAsync = { image in
      imageResponse = image
      return nil
    }
  
    moa_eventually {
      XCTAssert(imageResponse == nil)
    }
  }

  func testLoadImage_errorWhenResponseDataIsNotImage() {
    StubHttp.withImage("text.txt", forUrlPart: "96px.png")
    
    var imageResponse: UIImage?
    let moa = Moa()
    moa.url = "http://evgenii.com/moa/96px.png"
    
    moa.onSuccessAsync = { image in
      imageResponse = image
      return nil
    }
    
    moa_eventually {
      XCTAssert(imageResponse == nil)
    }
  }
}