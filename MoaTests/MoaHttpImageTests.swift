import UIKit
import XCTest

class MoaHttpImageTests: XCTestCase {
  override func tearDown() {
    super.tearDown()
    
    StubHttp.removeAllStubs()
  }
  
  func testLoad_allGood() {
    StubHttp.with35pxJpgImage()
    
    var imageFromCallback: UIImage?
    var errorFromCallback: NSError?
    var httpUrlResponseFromCallback: NSHTTPURLResponse?
    
    let task  = MoaHttpImage.createDataTask("http://evgenii.com/moa/35px.jpg",
      onSuccess: { image in
        imageFromCallback = image
      },
      onError: { error, response in
        errorFromCallback = error
        httpUrlResponseFromCallback = response
      }
    )
    
    task?.resume()
    
    moa_eventually(imageFromCallback != nil) {
      XCTAssertEqual(35, imageFromCallback!.size.width)
      XCTAssert(errorFromCallback == nil)
      XCTAssert(httpUrlResponseFromCallback == nil)
    }
  }
  
  func testLoad_httpError404NotFound() {
    StubHttp.withText("error", forUrlPart: "35px.jpg", statusCode: 404)
    
    var imageFromCallback: UIImage?
    var errorFromCallback: NSError?
    var httpUrlResponseFromCallback: NSHTTPURLResponse?
    
    let task  = MoaHttpImage.createDataTask("http://evgenii.com/moa/35px.jpg",
      onSuccess: { image in
        imageFromCallback = image
      },
      onError: { error, response in
        errorFromCallback = error
        httpUrlResponseFromCallback = response
      }
    )
    
    task?.resume()
    
    moa_eventually(httpUrlResponseFromCallback != nil) {
      XCTAssert(imageFromCallback == nil)
      XCTAssertEqual(MoaHttpImageErrors.HttpStatusCodeIsNot200.rawValue, errorFromCallback!.code)
      XCTAssertEqual("MoaHttpImageErrorDomain", errorFromCallback!.domain)
      XCTAssertEqual(404, httpUrlResponseFromCallback!.statusCode)
    }
  }
}