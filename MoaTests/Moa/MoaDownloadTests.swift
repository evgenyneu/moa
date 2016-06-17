import UIKit
import XCTest

class MoaDownloadTests: XCTestCase {
  override func tearDown() {
    super.tearDown()
    
    StubHttp.removeAllStubs()
    Moa.errorImage = nil
  }
  
  func testLoadPngImage() {
    StubHttp.with96pxPngImage()

    let moa = Moa()
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: NSHTTPURLResponse?

    moa.onSuccessAsync = { image in
      imageResponse = image
      return nil
    }
    
    moa.onErrorAsync = { error, response in
      errorResponse = error
      httpUrlResponse = response
    }
    
    moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(imageResponse != nil) {
      XCTAssertEqual(96, imageResponse!.size.width)
      XCTAssert(errorResponse == nil)
      XCTAssert(httpUrlResponse == nil)
    }
  }
  
  func testLoadJpegImage() {
    StubHttp.with35pxJpgImage()
    
    let moa = Moa()
    var imageResponse: UIImage?
    
    moa.onSuccessAsync = { image in
      imageResponse = image
      return nil
    }
    
    moa.url = "http://evgenii.com/moa/35px.jpg"
    
    moa_eventually(imageResponse != nil) {
      XCTAssertEqual(35, imageResponse!.size.width)
    }
  }

  func testLoadImage_errorWhenImageNotFound() {
    StubHttp.withImage("96px.png", forUrlPart: "96px.png", statusCode: 404)
    
    let moa = Moa()
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: NSHTTPURLResponse?
    
    moa.onSuccessAsync = { image in
      imageResponse = image
      return nil
    }
    
    moa.onErrorAsync = { error, response in
      errorResponse = error
      httpUrlResponse = response
    }
    
    moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(errorResponse != nil) {
      XCTAssert(imageResponse == nil)
      XCTAssertEqual(MoaError.HttpStatusCodeIsNot200._code, errorResponse!.code)
      XCTAssertEqual(1, errorResponse!.code)
      XCTAssertEqual("MoaError", errorResponse!.domain)
      XCTAssertEqual(404, httpUrlResponse!.statusCode)
    }
  }
  
  func testLoadImage_noInternetConnectionError() {
    // Code: -1009
    let notConnectedErrorCode = Int(CFNetworkErrors.CFURLErrorNotConnectedToInternet.rawValue)
    
    let notConnectedError = NSError(domain: NSURLErrorDomain,
      code: notConnectedErrorCode, userInfo: nil)
    
    StubHttp.withError(notConnectedError, forUrlPart: "96px.png")
    
    let moa = Moa()
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: NSHTTPURLResponse?
    
    moa.onSuccessAsync = { image in
      imageResponse = image
      return nil
    }
    
    moa.onErrorAsync = { error, response in
      errorResponse = error
      httpUrlResponse = response
    }
    
    moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(errorResponse != nil) {
      XCTAssert(imageResponse == nil)
      
      XCTAssertEqual(-1009, errorResponse!.code)
      XCTAssertEqual("NSURLErrorDomain", errorResponse!.domain)
      XCTAssert(httpUrlResponse == nil)
    }
  }

  func testLoadImage_errorWhenResponseIsNotAnImageType() {
    StubHttp.withImage("96px.png", forUrlPart: "96px.png",
      responseHeaders: ["Content-Type": "text/html"])
    
    let moa = Moa()
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: NSHTTPURLResponse?
    
    moa.onSuccessAsync = { image in
      imageResponse = image
      return nil
    }
    
    moa.onErrorAsync = { error, response in
      errorResponse = error
      httpUrlResponse = response
    }
    
    moa.url = "http://evgenii.com/moa/96px.png"
  
    moa_eventually(errorResponse != nil) {
      XCTAssert(imageResponse == nil)

      XCTAssertEqual(MoaError.NotAnImageContentTypeInResponseHttpHeader._code,
        errorResponse!.code)
  
      XCTAssertEqual("MoaError", errorResponse!.domain)
      XCTAssertEqual(200, httpUrlResponse!.statusCode)
    }
  }

  func testLoadImage_errorWhenResponseDataIsNotImage() {
    StubHttp.withImage("text.txt", forUrlPart: "96px.png")
    
    let moa = Moa()
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: NSHTTPURLResponse?
    
    moa.onSuccessAsync = { image in
      imageResponse = image
      return nil
    }
    
    moa.onErrorAsync = { error, response in
      errorResponse = error
      httpUrlResponse = response
    }
    
    moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually {
      XCTAssert(imageResponse == nil)
      XCTAssertEqual(MoaError.FailedToReadImageData._code, errorResponse!.code)
      XCTAssertEqual(4, errorResponse!.code)
      XCTAssertEqual("MoaError", errorResponse!.domain)
      XCTAssertEqual(200, httpUrlResponse!.statusCode)
    }
  }
  
  // MARK: - On success callback (main queue)
  
  func testOnSuccessCallback_mainQueue() {
    StubHttp.with96pxPngImage()
    
    let moa = Moa()
    var imageResponse: UIImage?
    
    moa.onSuccess = { image in
      imageResponse = image
      return nil
    }
    
    moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(imageResponse != nil) {
      XCTAssertEqual(96, imageResponse!.size.width)
    }
  }
  
  func testOnSuccessCallback_mainQueue_getsImageFromOnSuccessAsync() {
    StubHttp.with96pxPngImage()
    
    let moa = Moa()
    var imageResponse: UIImage?
    
    moa.onSuccessAsync = { image in
      return TestBundle.image("67px.png")
    }
    
    moa.onSuccess = { image in
      imageResponse = image
      return nil
    }
    
    moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(imageResponse != nil) {
      XCTAssertEqual(67, imageResponse!.size.width)
    }
  }
  
  // MARK: - On error callback (main queue)
  
  func testOnErrorCallback_mainQueue() {
    StubHttp.withImage("96px.png", forUrlPart: "96px.png", statusCode: 404)
    
    let moa = Moa()
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: NSHTTPURLResponse?
    
    moa.onSuccess = { image in
      imageResponse = image
      return nil
    }
    
    moa.onError = { error, response in
      errorResponse = error
      httpUrlResponse = response
    }
    
    moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(errorResponse != nil) {
      XCTAssert(imageResponse == nil)
      XCTAssertEqual(MoaError.HttpStatusCodeIsNot200._code, errorResponse!.code)
      XCTAssertEqual(1, errorResponse!.code)
      XCTAssertEqual("MoaError", errorResponse!.domain)
      XCTAssertEqual(404, httpUrlResponse!.statusCode)
    }
  }
  
  // MARK: - Supply error image
  
  func testSupplyErrorImage() {
    StubHttp.withImage("96px.png", forUrlPart: "96px.png", statusCode: 404)
    
    let moa = Moa()
    moa.errorImage = TestBundle.image("67px.png")
    
    var imageResponseAsync: UIImage?
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: NSHTTPURLResponse?
    
    moa.onSuccessAsync = { image in
      imageResponseAsync = image
      return image
    }
    
    moa.onSuccess = { image in
      imageResponse = image
      return nil
    }
    
    moa.onErrorAsync = { error, response in
      errorResponse = error
      httpUrlResponse = response
    }
    
    moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(imageResponse != nil && errorResponse != nil) {
      XCTAssertEqual(67, imageResponseAsync!.size.width)
      XCTAssertEqual(67, imageResponse!.size.width)
      XCTAssertEqual(MoaError.HttpStatusCodeIsNot200._code, errorResponse!.code)
      XCTAssertEqual(1, errorResponse!.code)
      XCTAssertEqual("MoaError", errorResponse!.domain)
      XCTAssertEqual(404, httpUrlResponse!.statusCode)
    }
  }
  
  // MARK: - Supply global error image
  
  func testSupplyGlobalErrorImage() {
    StubHttp.withImage("96px.png", forUrlPart: "96px.png", statusCode: 404)
    
    let moa = Moa()
    Moa.errorImage = TestBundle.image("67px.png")
    
    var imageResponseAsync: UIImage?
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: NSHTTPURLResponse?
    
    moa.onSuccessAsync = { image in
      imageResponseAsync = image
      return image
    }
    
    moa.onSuccess = { image in
      imageResponse = image
      return nil
    }
    
    moa.onErrorAsync = { error, response in
      errorResponse = error
      httpUrlResponse = response
    }
    
    moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(imageResponse != nil && errorResponse != nil) {
      XCTAssertEqual(67, imageResponseAsync!.size.width)
      XCTAssertEqual(67, imageResponse!.size.width)
      XCTAssertEqual(MoaError.HttpStatusCodeIsNot200._code, errorResponse!.code)
      XCTAssertEqual(1, errorResponse!.code)
      XCTAssertEqual("MoaError", errorResponse!.domain)
      XCTAssertEqual(404, httpUrlResponse!.statusCode)
    }
  }
  
  func testSupplyGlobalErrorImage_localImageIsUsedWithBothAreSupplied() {
    StubHttp.withImage("96px.png", forUrlPart: "96px.png", statusCode: 404)
    
    let moa = Moa()
    Moa.errorImage = TestBundle.image("67px.png")
    moa.errorImage = TestBundle.image("35px.jpg")
    var imageResponseAsync: UIImage?
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: NSHTTPURLResponse?
    
    moa.onSuccessAsync = { image in
      imageResponseAsync = image
      return image
    }
    
    moa.onSuccess = { image in
      imageResponse = image
      return nil
    }
    
    moa.onErrorAsync = { error, response in
      errorResponse = error
      httpUrlResponse = response
    }
    
    moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(imageResponse != nil && errorResponse != nil) {
      XCTAssertEqual(35, imageResponseAsync!.size.width)
      XCTAssertEqual(35, imageResponse!.size.width)
      XCTAssertEqual(MoaError.HttpStatusCodeIsNot200._code, errorResponse!.code)
      XCTAssertEqual(1, errorResponse!.code)
      XCTAssertEqual("MoaError", errorResponse!.domain)
      XCTAssertEqual(404, httpUrlResponse!.statusCode)
    }
  }


}