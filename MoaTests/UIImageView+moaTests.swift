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
  
  func testExample() {
    let imageView = UIImageView()
    imageView.moa.url = "http://evgenii.com/moa/ant.jpg"
    XCTAssertEqual("http://evgenii.com/moa/ant.jpg", imageView.moa.url)
  }

}
