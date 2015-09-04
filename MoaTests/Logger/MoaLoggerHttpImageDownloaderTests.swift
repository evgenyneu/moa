import UIKit
import XCTest

class MoaLoggerHttpImageDownloaderTests: XCTestCase {
  override func tearDown() {
    super.tearDown()
    
    StubHttp.removeAllStubs()
  }
  
  // MARK: - startDownload
  
  var logTypes = [MoaLogType]()
  var logUrls = [String]()
  var logStatusCodes = [Int?]()
  var logErrors = [NSError?]()
  
  func testLogger(type: MoaLogType, url: String, statusCode: Int?, error: NSError?) {
    logTypes.append(type)
    logUrls.append(url)
    logStatusCodes.append(statusCode)
    logErrors.append(error)
  }
  
  func testLogger_startDownloadSuccess() {
    StubHttp.with35pxJpgImage()
    
    var imageFromCallback: UIImage?
    
    let downloader = MoaHttpImageDownloader(logger: testLogger)
    downloader.startDownload("http://evgenii.com/moa/35px.jpg",
      onSuccess: { image in
        imageFromCallback = image

      },
      onError: { error, response in
      }
    )
    
    // Log the request
    // -------------
    
    XCTAssertEqual(1, logTypes.count)
    XCTAssertEqual(MoaLogType.RequestSent, logTypes[0])
    XCTAssertEqual("http://evgenii.com/moa/35px.jpg", logUrls[0])
    XCTAssert(logStatusCodes[0] == nil)
    
    moa_eventually(imageFromCallback != nil) {
      // Log the successful response
      // -------------
      
      XCTAssertEqual(2, self.logTypes.count)
      XCTAssertEqual(MoaLogType.ResponseSuccess, self.logTypes[1])
      XCTAssertEqual("http://evgenii.com/moa/35px.jpg", self.logUrls[1])
      XCTAssertEqual(200, self.logStatusCodes[1])
    }
  }
  
  func testLogger_startDownloadError() {
    StubHttp.withText("error", forUrlPart: "35px.jpg", statusCode: 404)
    
    var errorFromCallback: NSError?
    
    let downloader = MoaHttpImageDownloader(logger: testLogger)
    downloader.startDownload("http://evgenii.com/moa/35px.jpg",
      onSuccess: { _ in },
      onError: { error, _ in
        errorFromCallback = error
      }
    )
    
    moa_eventually(errorFromCallback != nil) {
      // Log the error response
      // -------------
      
      XCTAssertEqual(2, self.logTypes.count)
      XCTAssertEqual(MoaLogType.ResponseError, self.logTypes[1])
      XCTAssertEqual("http://evgenii.com/moa/35px.jpg", self.logUrls[1])
      XCTAssertEqual(404, self.logStatusCodes[1])
    }
  }
  
  func testLogger_cancel() {
    StubHttp.withImage("96px.png", forUrlPart: "35px.jpg", statusCode: 200, responseTime: 0.1)
    
    let downloader = MoaHttpImageDownloader(logger: testLogger)
    downloader.startDownload("http://evgenii.com/moa/35px.jpg",
      onSuccess: { _ in },
      onError: { _, _ in }
    )
    
    downloader.cancel()
    
    moa_eventually(0.3) {
      // Log the reponse cancel
      // -------------
      
      XCTAssertEqual(2, self.logTypes.count)
      XCTAssertEqual(MoaLogType.RequestCancelled, self.logTypes[1])
      XCTAssertEqual("http://evgenii.com/moa/35px.jpg", self.logUrls[1])
      XCTAssert(self.logStatusCodes[1] == nil)
    }
  }
}