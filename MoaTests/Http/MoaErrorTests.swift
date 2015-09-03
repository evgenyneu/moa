import UIKit
import XCTest

class MoaErrorTests: XCTestCase {
  /// MARK: - From error
  
  func testFromError() {
    var error = NSError(domain: "something.MoaError", code: 0, userInfo: nil)
    var result = MoaError.fromError(error)
    XCTAssertEqual(MoaError.InvalidUrlString, result)
    
    error = NSError(domain: "something.MoaError", code: 1, userInfo: nil)
    result = MoaError.fromError(error)
    XCTAssertEqual(MoaError.HttpStatusCodeIsNot200, result)
    
    error = NSError(domain: "something.MoaError", code: 2, userInfo: nil)
    result = MoaError.fromError(error)
    XCTAssertEqual(MoaError.MissingResponseContentTypeHttpHeader, result)
    
    error = NSError(domain: "something.MoaError", code: 3, userInfo: nil)
    result = MoaError.fromError(error)
    XCTAssertEqual(MoaError.NotAnImageContentTypeInResponseHttpHeader, result)
    
    error = NSError(domain: "something.MoaError", code: 4, userInfo: nil)
    result = MoaError.fromError(error)
    XCTAssertEqual(MoaError.FailedToReadImageData, result)
    
    error = NSError(domain: "something.MoaError", code: 5, userInfo: nil)
    result = MoaError.fromError(error)
    XCTAssertEqual(MoaError.SimulatedError, result)
  }
  
  func testWhenDomainIsDifferent() {
    let error = NSError(domain: "different", code: 0, userInfo: nil)
    let result = MoaError.fromError(error)
    XCTAssert(result == nil)
  }
  
  func testGetNsError() {
    var error = MoaError.InvalidUrlString.nsError
    XCTAssertEqual("MoaError", error.domain)
    XCTAssertEqual(0, error.code)
    XCTAssertEqual("Invalid URL.", error.localizedDescription)
    
    error = MoaError.HttpStatusCodeIsNot200.nsError
    XCTAssertEqual(1, error.code)
    XCTAssertEqual("Response HTTP status code is not 200.", error.localizedDescription)
    
    error = MoaError.MissingResponseContentTypeHttpHeader.nsError
    XCTAssertEqual(2, error.code)
    XCTAssertEqual("Response HTTP header is missing content type.", error.localizedDescription)
    
    error = MoaError.NotAnImageContentTypeInResponseHttpHeader.nsError
    XCTAssertEqual(3, error.code)
    XCTAssertEqual("Response content type is not an image type. Content type needs to be  'image/jpeg', 'image/pjpeg' or 'image/png'", error.localizedDescription)
    
    error = MoaError.FailedToReadImageData.nsError
    XCTAssertEqual(4, error.code)
    XCTAssertEqual("Could not convert response data to an image format.", error.localizedDescription)
    
    error = MoaError.SimulatedError.nsError
    XCTAssertEqual(5, error.code)
    XCTAssertEqual("Test error.", error.localizedDescription)
  }
}