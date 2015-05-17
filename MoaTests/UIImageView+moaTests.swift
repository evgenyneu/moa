import UIKit
import XCTest
import OHHTTPStubs
import Moa

class MoaTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testExample_getCreatesAndStoresMoaInstance() {
    let imageView = UIImageView()
    let moa1 = imageView.moa
    let moa2 = imageView.moa
    XCTAssert(moa1 === moa2)
  }
  
  func testExample_set() {
    let imageView = UIImageView()
    let moa = Moa()
    imageView.moa = moa
    XCTAssert(imageView.moa === moa)
  }
}
