
import UIKit
import XCTest

class MoaSimulatorTests: XCTestCase {
  
  func testSimulate() {
    MoaSimulator.simulate("image1.jpg")
    
    XCTAssertEqual(["image1.jpg"], MoaSimulator.simulatedUrlParts)
    
    MoaSimulator.stop()
  }
  
  // MARK: - Is simulated
  
  func testIsSimulated_yes() {
    MoaSimulator.simulatedUrlParts = ["image1.jpg"]
    
    let result = MoaSimulator.isSimulated("http://site.com/image1.jpg")
    
    XCTAssert(result)
    
    MoaSimulator.stop()
  }
  
  func testIsSimulated_noDifferectCase() {
    MoaSimulator.simulatedUrlParts = ["Image1.jpg"]
    
    let result = MoaSimulator.isSimulated("http://site.com/image1.jpg")
    
    XCTAssertFalse(result)
    
    MoaSimulator.stop()
  }
  
  func testIsSimulated_noDifferentSctring() {
    MoaSimulator.simulatedUrlParts = ["different"]
    
    let result = MoaSimulator.isSimulated("http://site.com/image1.jpg")
    
    XCTAssertFalse(result)
    
    MoaSimulator.stop()
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