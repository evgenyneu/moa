import UIKit
import XCTest

class MoaWithImageViewTests: XCTestCase {
  override func tearDown() {
    super.tearDown()
    
    StubHttp.removeAllStubs()
  }
  
  func testSetImageToImageView() {
    StubHttp.with96pxPngImage()
    
    let imageView = UIImageView()
    
    let moa = Moa()
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: NSHTTPURLResponse?
    
    moa.onSuccessAsync = { image in
      imageResponse = image
      return nil
    }
    
    moa.onErrorAsync = { error, response in
      errorResponse = error
      httpUrlResponse = response
    }

    moa.imageView = imageView
    moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(moa.imageView?.image != nil) {
      XCTAssertEqual(96, imageView.image!.size.width)
      XCTAssertEqual(96, imageResponse!.size.width)
      XCTAssert(errorResponse == nil)
      XCTAssert(httpUrlResponse == nil)
    }
  }
}