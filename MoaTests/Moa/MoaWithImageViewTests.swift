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
    moa.imageView = imageView
    moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(moa.imageView?.image != nil) {
      XCTAssertEqual(96, moa.imageView!.image!.size.width)
    }
  }
}