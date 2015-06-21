
import UIKit
import XCTest

class MoaSimulatorTests: XCTestCase {
  
  func testStart_createSimulator() {
    MoaSimulator.start()
    XCTAssert(MoaSimulator.instance != nil)
  }
  
  func testStop_removeSimulator() {
    MoaSimulator.instance = MoaSimulator()
    
    MoaSimulator.stop()
    
    XCTAssert(MoaSimulator.instance == nil)
  }
  
  func testTestSub() {
//    MoaSimulator.start()
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