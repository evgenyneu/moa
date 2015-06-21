
import UIKit
import XCTest

class MoaSimulatedImageDownloaderTests: XCTestCase {
  func testInitForUrl_urlIsNotSimulated() {
    let result = MoaSimulatedImageDownloader(url: "http://site.com/moa.jpg")
    
    XCTAssertEqual("http://site.com/moa.jpg", result.url)
  }
}