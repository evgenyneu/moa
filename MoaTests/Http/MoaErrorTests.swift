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
}