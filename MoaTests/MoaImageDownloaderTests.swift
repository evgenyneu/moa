import UIKit
import XCTest

class MoaImageDownloaderTests: XCTestCase {
  // MARK: - startDownload
  
  func testStartDownload_success() {
    StubHttp.with35pxJpgImage()
    
    var imageFromCallback: UIImage?
    var errorFromCallback: NSError?
    var httpUrlResponseFromCallback: NSHTTPURLResponse?
    
    let downloader = MoaImageDownloader()
    downloader.startDownload("http://evgenii.com/moa/35px.jpg",
      onSuccess: { image in
        imageFromCallback = image
      },
      onError: { error, response in
        errorFromCallback = error
        httpUrlResponseFromCallback = response
      }
    )
    
    moa_eventually(imageFromCallback != nil) {
      XCTAssertEqual(35, imageFromCallback!.size.width)
      XCTAssert(errorFromCallback == nil)
      XCTAssert(httpUrlResponseFromCallback == nil)
      XCTAssertFalse(downloader.cancelled)
    }
  }
  
  func testStartDownload_error() {
    StubHttp.withText("error", forUrlPart: "35px.jpg", statusCode: 404)
    
    var imageFromCallback: UIImage?
    var errorFromCallback: NSError?
    var httpUrlResponseFromCallback: NSHTTPURLResponse?
    
    let downloader = MoaImageDownloader()
    downloader.startDownload("http://evgenii.com/moa/35px.jpg",
      onSuccess: { image in
        imageFromCallback = image
      },
      onError: { error, response in
        errorFromCallback = error
        httpUrlResponseFromCallback = response
      }
    )
    
    moa_eventually(errorFromCallback != nil) {
      XCTAssert(imageFromCallback == nil)
      XCTAssertEqual(MoaHttpImageErrors.HttpStatusCodeIsNot200.rawValue, errorFromCallback!.code)
      XCTAssertEqual("MoaHttpImageErrorDomain", errorFromCallback!.domain)
      XCTAssertEqual(404, httpUrlResponseFromCallback!.statusCode)
    }
  }
  
  // MARK: - cancel
  
  func testCancel() {
    StubHttp.withImage("96px.png", forUrlPart: "35px.jpg", statusCode: 200, responseTime: 0.1)
    
    var imageFromCallback: UIImage?
    var errorFromCallback: NSError?
    var httpUrlResponseFromCallback: NSHTTPURLResponse?
    
    let downloader = MoaImageDownloader()
    downloader.startDownload("http://evgenii.com/moa/35px.jpg",
      onSuccess: { image in
        imageFromCallback = image
      },
      onError: { error, response in
        errorFromCallback = error
        httpUrlResponseFromCallback = response
      }
    )
    
    downloader.cancel()
    
    moa_eventually(timeout: 0.3) {
      XCTAssert(downloader.cancelled)
      XCTAssertEqual(NSURLSessionTaskState.Completed, downloader.task!.state)
      XCTAssert(imageFromCallback == nil)
      XCTAssert(errorFromCallback == nil)
      XCTAssert(httpUrlResponseFromCallback == nil)
    }
  }
  
  func testCancel_onDeinit() {
    StubHttp.withImage("35px.jpg", forUrlPart: "35px.jpg", statusCode: 200, responseTime: 0.1)
    
    var imageFromCallback: UIImage?
    var errorFromCallback: NSError?
    var httpUrlResponseFromCallback: NSHTTPURLResponse?
    var task: NSURLSessionDataTask?
  
    let closure:()->() = {
      let downloader = MoaImageDownloader()
      downloader.startDownload("http://evgenii.com/moa/35px.jpg",
        onSuccess: { image in
          imageFromCallback = image
        },
        onError: { error, response in
          errorFromCallback = error
          httpUrlResponseFromCallback = response
        }
      )
      
     task = downloader.task!
    }
    
    closure() // downloader instance will be deallocated in the closure
    
    moa_eventually(timeout: 0.3) {
      XCTAssertEqual(NSURLSessionTaskState.Completed, task!.state)
      XCTAssert(imageFromCallback == nil)
      XCTAssert(errorFromCallback == nil)
      XCTAssert(httpUrlResponseFromCallback == nil)
    }
  }
  
  func testStartDownload_setCancelledToFalse() {
    StubHttp.with35pxJpgImage()
    
    var imageFromCallback: UIImage?
    
    let downloader = MoaImageDownloader()
    downloader.cancelled = true
    
    downloader.startDownload("http://evgenii.com/moa/35px.jpg",
      onSuccess: { image in
        imageFromCallback = image
      },
      onError: { error, response in }
    )
    
    moa_eventually(imageFromCallback != nil) {
      XCTAssertFalse(downloader.cancelled)
    }
  }

}