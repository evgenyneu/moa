
import UIKit
import XCTest

class MoaSimulatorIntegrationTests: XCTestCase {
  
  override func tearDown() {
    super.tearDown()
    MoaSimulator.clear()
    StubHttp.removeAllStubs()
    Moa.errorImage = nil
  }

  func testSimulateImageDownload() {
    let simulator = MoaSimulator.simulate("35px.png")
    
    let moa = Moa()
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: HTTPURLResponse?
    
    moa.onSuccessAsync = { image in
      imageResponse = image
      return nil
    }
    
    moa.onErrorAsync = { error, response in
      errorResponse = error
      httpUrlResponse = response
    }
    
    moa.url = "http://evgenii.com/moa/35px.png"
    
    XCTAssertEqual(1, simulator.downloaders.count)
    XCTAssertEqual("http://evgenii.com/moa/35px.png", simulator.downloaders[0].url)
    
    let image = TestBundle.image("35px.jpg")!
    simulator.respondWithImage(image)

    XCTAssertEqual(35, imageResponse!.size.width)
    XCTAssert(errorResponse == nil)
    XCTAssert(httpUrlResponse == nil)
  }
  
  func testSimulateImageDownload_dotNotCatch() {
    let simulator = MoaSimulator.simulate("different") // The image will not be cached by moa simulator
    StubHttp.with96pxPngImage() // Will be cached by OHHTTPSubs instead
    
    let moa = Moa()
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: HTTPURLResponse?
    
    moa.onSuccessAsync = { image in
      imageResponse = image
      return nil
    }
    
    moa.onErrorAsync = { error, response in
      errorResponse = error
      httpUrlResponse = response
    }
    
    moa.url = "http://evgenii.com/moa/96px.png"
    
    XCTAssertEqual(0, simulator.downloaders.count)
    
    moa_eventually(imageResponse != nil) {
      XCTAssertEqual(96, imageResponse!.size.width)
      XCTAssert(errorResponse == nil)
      XCTAssert(httpUrlResponse == nil)
    }
  }
  
  func testAutorespondToImageDownloads() {
    let image = TestBundle.image("35px.jpg")!
    let simulator = MoaSimulator.autorespondWithImage("35px.png", image: image)
    
    let moa = Moa()
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: HTTPURLResponse?
    
    moa.onSuccessAsync = { image in
      imageResponse = image
      return nil
    }
    
    moa.onErrorAsync = { error, response in
      errorResponse = error
      httpUrlResponse = response
    }
    
    moa.url = "http://evgenii.com/moa/35px.png"
    
    XCTAssertEqual(1, simulator.downloaders.count)
    XCTAssertEqual("http://evgenii.com/moa/35px.png", simulator.downloaders[0].url)
    
    XCTAssertEqual(35, imageResponse!.size.width)
    XCTAssert(errorResponse == nil)
    XCTAssert(httpUrlResponse == nil)
  }
  
  func testImageDownloadToImageView() {
    // Create simulator to catch downloads of the given image
    let simulator = MoaSimulator.simulate("35px.jpg")
    
    // Download the image
    let imageView = UIImageView()
    imageView.moa.url = "http://site.com/35px.jpg"
    
    // Check the image download has been requested
    XCTAssertEqual(1, simulator.downloaders.count)
    XCTAssertEqual("http://site.com/35px.jpg", simulator.downloaders[0].url)
    
    // Simulate server response with the given image
    let bundle = Bundle(forClass: self.dynamicType)
    let image =  UIImage(named: "35px.jpg", inBundle: bundle, compatibleWithTraitCollection: nil)!
    simulator.respondWithImage(image)

    // Check the image has arrived
    XCTAssertEqual(35, imageView.image!.size.width)
  }
  
  func testAutorespondWithImageDownloadToImageView() {
    // Create simulator to catch downloads of the given image
    let bundle = Bundle(forClass: self.dynamicType)
    let image =  UIImage(named: "35px.jpg", inBundle: bundle, compatibleWithTraitCollection: nil)!
    let simulator = MoaSimulator.autorespondWithImage("35px.jpg", image: image)
    
    // Download the image
    let imageView = UIImageView()
    imageView.moa.url = "http://site.com/35px.jpg"
    
    // Check the image download has been requested
    XCTAssertEqual(1, simulator.downloaders.count)
    XCTAssertEqual("http://site.com/35px.jpg", simulator.downloaders[0].url)
    
    // Check the image has arrived
    XCTAssertEqual(35, imageView.image!.size.width)
  }
}
