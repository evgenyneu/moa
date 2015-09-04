import UIKit
import XCTest

class MoaLoggerTextTests: XCTestCase {
  func testRequestSent() {
    let result = MoaLoggerText(.RequestSent, url: "http://mysite.edu/image.jpg",
      statusCode: nil, error: nil)
    
    MoaString.contains(result, substring: "GET http://mysite.edu/image.jpg")
  }
  
  func testRequestResponseSuccess() {
    let result = MoaLoggerText(.ResponseSuccess, url: "http://mysite.edu/image.jpg",
      statusCode: 200, error: nil)
    
    MoaString.contains(result, substring: "Received http://mysite.edu/image.jpg")
  }
  
  func testRequestError() {
    let result = MoaLoggerText(.ResponseError, url: "http://mysite.edu/image.jpg",
      statusCode: 500, error: MoaError.MissingResponseContentTypeHttpHeader.nsError)
    
    MoaString.contains(result, substring: "Error 500 http://mysite.edu/image.jpg Response HTTP header is missing content type.")
  }
  
  func testRequestCancelled() {
    let result = MoaLoggerText(.RequestCancelled, url: "http://mysite.edu/image.jpg",
      statusCode: nil, error: nil)
    
    MoaString.contains(result, substring: "Cancelled http://mysite.edu/image.jpg")
  }
}