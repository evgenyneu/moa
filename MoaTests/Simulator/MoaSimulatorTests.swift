
import UIKit
import XCTest

class MoaSimulatorTests: XCTestCase {
  
  override func tearDown() {
    super.tearDown()
    
    MoaSimulator.clear()
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
    
    MoaSimulator.clear()
    
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
  
  func testTestSub() {
//    let image = TestBundle.image("96px.png")
    MoaSimulator.simulate("image1.jpg")

    let moa = Moa()
    moa.url = "http://site.com/image1.jpg"
    moa.url = "http://site.com/image2.jpg"
    
    XCTAssertEqual(1, MoaSimulator.downloaders.count)
    XCTAssertEqual("http://site.com/image1.jpg", MoaSimulator.downloaders[0].url)

    
  }
}