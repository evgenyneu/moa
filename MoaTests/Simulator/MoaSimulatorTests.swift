
import UIKit
import XCTest

class MoaSimulatorTests: XCTestCase {
  
  override func tearDown() {
    super.tearDown()
    
    MoaSimulator.stop()
  }
  
  func testSimulate() {
    MoaSimulator.simulate("image1.jpg")
    
    XCTAssertEqual(["image1.jpg"], MoaSimulator.simulatedUrlParts)
  }
  
  // MARK: - Is simulated
  
  func testIsSimulated_yes() {
    MoaSimulator.simulatedUrlParts = ["image1.jpg"]
    
    let result = MoaSimulator.isSimulated("http://site.com/image1.jpg")
    
    XCTAssert(result)
  }
  
  func testIsSimulated_noDifferectCase() {
    MoaSimulator.simulatedUrlParts = ["Image1.jpg"]
    
    let result = MoaSimulator.isSimulated("http://site.com/image1.jpg")
    
    XCTAssertFalse(result)
  }
  
  func testIsSimulated_noDifferentSctring() {
    MoaSimulator.simulatedUrlParts = ["different"]
    
    let result = MoaSimulator.isSimulated("http://site.com/image1.jpg")
    
    XCTAssertFalse(result)
  }
  
  // MARK: - Stop
  
  func testStopSimulation() {
    MoaSimulator.simulate("image1.jpg")
    
    MoaSimulator.stop()
    
    XCTAssert(MoaSimulator.simulatedUrlParts.isEmpty)
  }
  
  // MARK: - Register image downloaders
  
  func testRegisterImageDownloader() {
    MoaSimulator.simulate("image1.jpg")
    let downloader = MoaSimulatedImageDownloader(url: "http://site.com/image1.jpg")
    
    XCTAssertEqual(1, MoaSimulator.downloaders.count)
    XCTAssert(MoaSimulator.downloaders[0] === downloader)
  }
  
  func testDoNotRegisterImageDownlaoder() {
    MoaSimulator.simulate("image1.jpg")
    let downloader = MoaSimulatedImageDownloader(url: "http://site.com/different.jpg")
    
    XCTAssertEqual(0, MoaSimulator.downloaders.count)
  }
  
  // MARK: - Stop
  
//  func testCreateForUrl() {
//    let result = MoaSimulator.createForUrl("http://site.com/image1.jpg")
//    XCTAssert(result == nil)
//  }
  
//  func testStop_removeSimulator() {
//    MoaSimulator.started = true
//    
//    MoaSimulator.stop()
//    
//    XCTAssertFalse(MoaSimulator.started)
//  }
  
  func testTestSub() {
//    MoaSimulator.simulateAll()
//
//    let moa = Moa()
//    moa.url = "http://site.com/image1.jpg"
//    moa.url = "http://site.com/image2.jpg"
//    
//    XCTAssertEqual(2, MoaSimulator.urls.count)
//    
//    MoaSimulator.stop()

  }
}