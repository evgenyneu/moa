import UIKit
import XCTest

class UIImageViewMoaExtensionTests: XCTestCase {
  func testGetCreatesAndStoresMoaInstance() {
    let imageView = UIImageView()
    let moa1 = imageView.moa
    let moa2 = imageView.moa
    
    XCTAssert(moa1 === moa2)
  }
  
  func testSet() {
    let imageView = UIImageView()
    let moa = Moa()
    imageView.moa = moa
    
    XCTAssert(imageView.moa === moa)
  }
}
