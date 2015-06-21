
import UIKit
import XCTest

class MoaSimulatedImageDownloaderTests: XCTestCase {
  
  override func tearDown() {
    super.tearDown()
    
    MoaSimulator.clear()
  }
  
  func testInitForUrl_returnNil_urlIsNotSimulated() {
    let result = MoaSimulatedImageDownloader(url: "http://site.com/moa.jpg")
    XCTAssert(result == nil)
  }
  
  func testInitForUrl_urlIsNotSimulated() {
    MoaSimulator.simulate("moa.jpg")
    
    let result = MoaSimulatedImageDownloader(url: "http://site.com/moa.jpg")
    
    XCTAssertEqual("http://site.com/moa.jpg", result!.url)
  }
}