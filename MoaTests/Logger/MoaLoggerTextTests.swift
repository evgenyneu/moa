import UIKit
import XCTest

class MoaLoggerTextTests: XCTestCase {
  func testRequestSent() {
    let result = MoaLoggerText(.requestSent, url: "http://mysite.edu/image.jpg",
      statusCode: nil, error: nil)
    
    XCTAssert(MoaString.contains(result, substring: "GET http://mysite.edu/image.jpg"))
  }
  
  func testRequestResponseSuccess() {
    let result = MoaLoggerText(.responseSuccess, url: "http://mysite.edu/image.jpg",
      statusCode: 200, error: nil)
    
    XCTAssert(MoaString.contains(result, substring: "Received http://mysite.edu/image.jpg"))
  }
  
  func testRequestError() {
    let result = MoaLoggerText(.responseError, url: "http://mysite.edu/image.jpg",
      statusCode: 500, error: MoaError.missingResponseContentTypeHttpHeader.nsError)
    
    XCTAssert(MoaString.contains(result, substring: "Error 500 http://mysite.edu/image.jpg Response HTTP header is missing content type."))
  }
  
  func testRequestCancelled() {
    let result = MoaLoggerText(.requestCancelled, url: "http://mysite.edu/image.jpg",
      statusCode: nil, error: nil)
    
    XCTAssert(MoaString.contains(result, substring: "Cancelled http://mysite.edu/image.jpg"))
  }
}
