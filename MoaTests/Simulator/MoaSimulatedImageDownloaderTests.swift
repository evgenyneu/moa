
import UIKit
import XCTest

class MoaSimulatedImageDownloaderTests: XCTestCase {
  func testInitForUrl_urlIsNotSimulated() {
    let result = MoaSimulatedImageDownloader(url: "http://site.com/moa.jpg")
    
    XCTAssertEqual("http://site.com/moa.jpg", result.url)
  }
  
  func testDownload_simulateSuccess() {
    let downloader = MoaSimulatedImageDownloader(url: "http://site.com/image1.jpg")
    
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: NSHTTPURLResponse?
    
    downloader.startDownload("http://site.com/image1.jpg",
      onSuccess: { image in
        imageResponse = image
      },
      onError: { error, response in
        errorResponse = error
        httpUrlResponse = response
    })
    

    let image = TestBundle.image("96px.png")!
    downloader.respondWithImage(image)
    
    XCTAssertEqual(96, imageResponse!.size.width)
    XCTAssert(errorResponse == nil)
    XCTAssert(httpUrlResponse == nil)
  }
  
  func testDownload_simulateError() {
    let downloader = MoaSimulatedImageDownloader(url: "http://site.com/image1.jpg")
    
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: NSHTTPURLResponse?
    
    downloader.startDownload("http://site.com/image1.jpg",
      onSuccess: { image in
        imageResponse = image
      },
      onError: { error, response in
        errorResponse = error
        httpUrlResponse = response
    })
    
    downloader.respondWithError()
    
    XCTAssert(imageResponse == nil)
    XCTAssertEqual(MoaHttpImageErrors.SimulatedError.rawValue, errorResponse!.code)
    XCTAssert(httpUrlResponse == nil)
  }
  
  func testCancel() {
    let result = MoaSimulatedImageDownloader(url: "http://site.com/moa.jpg")
    
    XCTAssertFalse(result.cancelled)
    
    result.cancel()
    
    XCTAssert(result.cancelled)
  }
}