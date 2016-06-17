import UIKit
import XCTest

class MoaWithImageViewTests: XCTestCase {
  override func tearDown() {
    super.tearDown()
    
    StubHttp.removeAllStubs()
    Moa.errorImage = nil
  }
  
  func testSetImageToImageView() {
    StubHttp.with96pxPngImage()
    
    let imageView = UIImageView()
    imageView.moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(imageView.image != nil) {
      XCTAssertEqual(96, imageView.image!.size.width)
    }
  }
  
  func testSetImageToImageView_withCallbacks() {
    StubHttp.with96pxPngImage()
    
    let imageView = UIImageView()
    
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: HTTPURLResponse?
    
    imageView.moa.onSuccessAsync = { image in
      imageResponse = image
      return image
    }
    
    imageView.moa.onErrorAsync = { error, response in
      errorResponse = error
      httpUrlResponse = response
    }
    
    imageView.moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(imageResponse != nil) {
      XCTAssertEqual(96, imageView.image!.size.width)
      XCTAssertEqual(96, imageResponse!.size.width)
      XCTAssert(errorResponse == nil)
      XCTAssert(httpUrlResponse == nil)
    }
  }
  
  func testSetImageToImageView_supplyDifferentImageInSuccessCallback() {
    StubHttp.with96pxPngImage()
    
    let imageView = UIImageView()
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: HTTPURLResponse?
    
    imageView.moa.onSuccessAsync = { image in
      imageResponse = image
      return MoaTest.uiImageFromFile("35px.jpg")
    }
    
    imageView.moa.onErrorAsync = { error, response in
      errorResponse = error
      httpUrlResponse = response
    }
    
    imageView.moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(imageResponse != nil) {
      XCTAssertEqual(35, imageView.image!.size.width)
      XCTAssertEqual(96, imageResponse!.size.width)
      XCTAssert(errorResponse == nil)
      XCTAssert(httpUrlResponse == nil)
    }
  }
  
  func testSetImageToImageView_returnNilFromSuccessCallback() {
    StubHttp.with96pxPngImage()
    
    let imageView = UIImageView()
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: HTTPURLResponse?
    
    imageView.moa.onSuccessAsync = { image in
      imageResponse = image
      return nil
    }
    
    imageView.moa.onErrorAsync = { error, response in
      errorResponse = error
      httpUrlResponse = response
    }
    
    imageView.moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(imageResponse != nil) {
      XCTAssert(imageView.image == nil)
      XCTAssertEqual(96, imageResponse!.size.width)
      XCTAssert(errorResponse == nil)
      XCTAssert(httpUrlResponse == nil)
    }
  }
  
  func testSetImageToImageView_errorWhenImageNotFound() {
    StubHttp.withImage("96px.png", forUrlPart: "96px.png", statusCode: 404)
    
    let imageView = UIImageView()
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: HTTPURLResponse?
    
    imageView.moa.onSuccessAsync = { image in
      imageResponse = image
      return image
    }
    
    imageView.moa.onErrorAsync = { error, response in
      errorResponse = error
      httpUrlResponse = response
    }
    
    imageView.moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(errorResponse != nil) {
      XCTAssert(imageResponse == nil)
      XCTAssertEqual(MoaError.HttpStatusCodeIsNot200._code, errorResponse!.code)
      XCTAssertEqual(1, errorResponse!.code)
      XCTAssertEqual("MoaError", errorResponse!.domain)
      XCTAssertEqual(404, httpUrlResponse!.statusCode)
    }
  }
  
  // MARK: - onSuccess callback (main queue)
  
  func testSetImageToImageView_withOnSuccessCallback() {
    StubHttp.with96pxPngImage()
    
    let imageView = UIImageView()
    
    var imageResponse: UIImage?
    
    imageView.moa.onSuccess = { image in
      imageResponse = image
      return image
    }
    
    imageView.moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(imageResponse != nil) {
      XCTAssertEqual(96, imageView.image!.size.width)
      XCTAssertEqual(96, imageResponse!.size.width)
    }
  }
  
  func testSetImageToImageView_withOnSuccessCallback_supplyDifferentImageWithCallback() {
    StubHttp.with96pxPngImage()
    
    let imageView = UIImageView()
    
    var imageResponse: UIImage?
    
    imageView.moa.onSuccess = { image in
      imageResponse = image
      return TestBundle.image("67px.png")
    }
    
    imageView.moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(imageResponse != nil) {
      XCTAssertEqual(67, imageView.image!.size.width)
    }
  }
  
  // MARK: - onError callback (main queue)
  
  func testSetImageToImageView_errorCallbackMainQueue_whenImageNotFound() {
    StubHttp.withImage("96px.png", forUrlPart: "96px.png", statusCode: 404)
    
    let imageView = UIImageView()
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: HTTPURLResponse?
    
    imageView.moa.onSuccess = { image in
      imageResponse = image
      return image
    }
    
    imageView.moa.onError = { error, response in
      errorResponse = error
      httpUrlResponse = response
    }
    
    imageView.moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(errorResponse != nil) {
      XCTAssert(imageResponse == nil)
      XCTAssertEqual(MoaError.HttpStatusCodeIsNot200._code, errorResponse!.code)
      XCTAssertEqual(1, errorResponse!.code)
      XCTAssertEqual("MoaError", errorResponse!.domain)
      XCTAssertEqual(404, httpUrlResponse!.statusCode)
    }
  }
  
  // MARK: - Supply error image
  
  func testSetImageToImageView_supplyErrorImage() {
    StubHttp.withImage("96px.png", forUrlPart: "96px.png", statusCode: 404)
    
    let imageView = UIImageView()
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: HTTPURLResponse?
    
    imageView.moa.errorImage = TestBundle.image("67px.png")
    
    imageView.moa.onSuccess = { image in
      imageResponse = image
      return image
    }
    
    imageView.moa.onErrorAsync = { error, response in
      errorResponse = error
      httpUrlResponse = response
    }
    
    imageView.moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(imageResponse != nil) {
      XCTAssertEqual(67, imageView.image!.size.width)
      XCTAssertEqual(MoaError.HttpStatusCodeIsNot200._code, errorResponse!.code)
      XCTAssertEqual(1, errorResponse!.code)
      XCTAssertEqual("MoaError", errorResponse!.domain)
      XCTAssertEqual(404, httpUrlResponse!.statusCode)
    }
  }
  
  func testSetImageToImageView_supplyGlobalErrorImage() {
    StubHttp.withImage("96px.png", forUrlPart: "96px.png", statusCode: 404)
    
    let imageView = UIImageView()
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: HTTPURLResponse?
    
    Moa.errorImage = TestBundle.image("35px.jpg")
    
    imageView.moa.onSuccess = { image in
      imageResponse = image
      return image
    }
    
    imageView.moa.onErrorAsync = { error, response in
      errorResponse = error
      httpUrlResponse = response
    }
    
    imageView.moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(imageResponse != nil) {
      XCTAssertEqual(35, imageView.image!.size.width)
      XCTAssertEqual(MoaError.HttpStatusCodeIsNot200._code, errorResponse!.code)
      XCTAssertEqual(1, errorResponse!.code)
      XCTAssertEqual("MoaError", errorResponse!.domain)
      XCTAssertEqual(404, httpUrlResponse!.statusCode)
    }
  }
}
