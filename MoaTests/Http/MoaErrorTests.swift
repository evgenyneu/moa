import UIKit
import XCTest

class MoaErrorTests: XCTestCase {  
  func testCreateMoaError() {
    var error: Error = MoaError.invalidUrlString
    XCTAssertEqual(0, error._code)
    XCTAssertEqual(MoaError.invalidUrlString._code, error._code)
    XCTAssertEqual("moaTests.MoaError", error._domain)
    
    error = MoaError.httpStatusCodeIsNot200
    XCTAssertEqual(1, error._code)
    XCTAssertEqual(MoaError.httpStatusCodeIsNot200._code, error._code)
    XCTAssertEqual("moaTests.MoaError", error._domain)
    
    error = MoaError.missingResponseContentTypeHttpHeader
    XCTAssertEqual(2, error._code)
    XCTAssertEqual(MoaError.missingResponseContentTypeHttpHeader._code, error._code)
    XCTAssertEqual("moaTests.MoaError", error._domain)
    
    error = MoaError.notAnImageContentTypeInResponseHttpHeader
    XCTAssertEqual(3, error._code)
    XCTAssertEqual(MoaError.notAnImageContentTypeInResponseHttpHeader._code, error._code)
    XCTAssertEqual("moaTests.MoaError", error._domain)
    
    error = MoaError.failedToReadImageData
    XCTAssertEqual(4, error._code)
    XCTAssertEqual(MoaError.failedToReadImageData._code, error._code)
    XCTAssertEqual("moaTests.MoaError", error._domain)
    
    error = MoaError.simulatedError
    XCTAssertEqual(5, error._code)
    XCTAssertEqual(MoaError.simulatedError._code, error._code)
    XCTAssertEqual("moaTests.MoaError", error._domain)
  }
}
