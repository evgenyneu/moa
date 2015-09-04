import UIKit
import XCTest

class MoaLoggerTextTests: XCTestCase {
  func testRequestSent() {
    let result = MoaLoggerText(.RequestSent, url: "http://mysite.edu/image.jpg",
      statusCode: nil, error: nil)
    
    XCTAssertEqual("[moa] GET http://mysite.edu/image.jpg", result)
  }
  
  func testRequestResponseSuccess() {
    let result = MoaLoggerText(.ResponseSuccess, url: "http://mysite.edu/image.jpg",
      statusCode: 200, error: nil)
    
    XCTAssertEqual("[moa] Received http://mysite.edu/image.jpg", result)
  }
  
  func testRequestError() {
    let result = MoaLoggerText(.ResponseError, url: "http://mysite.edu/image.jpg",
      statusCode: 500, error: MoaError.MissingResponseContentTypeHttpHeader.nsError)
    
    XCTAssertEqual("[moa] Error 500 http://mysite.edu/image.jpg Response HTTP header is missing content type.", result)
  }
  
  func testRequestCancelled() {
    let result = MoaLoggerText(.RequestCancelled, url: "http://mysite.edu/image.jpg",
      statusCode: nil, error: nil)
    
    XCTAssertEqual("[moa] Cancelled http://mysite.edu/image.jpg", result)
  }
}