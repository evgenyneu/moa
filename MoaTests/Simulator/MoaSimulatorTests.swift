
import UIKit
import XCTest

class MoaSimulatorTests: XCTestCase {
  
  override func tearDown() {
    super.tearDown()
    
    MoaSimulator.clear()
  }
  
  func testSimulate() {
    MoaSimulator.simulate("image1.jpg")
    
    XCTAssertEqual(1, MoaSimulator.simulators.count)
    XCTAssertEqual("image1.jpg", MoaSimulator.simulators[0].urlPart)
  }
  
  // MARK: - Simulators marthing url
  
  func testSimulatorsMatchingUrl() {
    let simulator1 = MoaSimulator(urlPart: "http://site.com")
    MoaSimulator.simulators.append(simulator1)
    
    let simulator2 = MoaSimulator(urlPart: "image1.jpg")
    MoaSimulator.simulators.append(simulator2)
    
    let simulator3 = MoaSimulator(urlPart: "moa.jpg")
    MoaSimulator.simulators.append(simulator3)
    
    let result = MoaSimulator.simulatorsMatchingUrl("http://site.com/image1.jpg")
    
    XCTAssertEqual(2, result.count)
    XCTAssertEqual("http://site.com", result[0].urlPart)
    XCTAssertEqual("image1.jpg", result[1].urlPart)
  }
  
  func testSimulatorsMatchingUrl_noMatch() {
    let simulator1 = MoaSimulator(urlPart: "http://site.com")
    MoaSimulator.simulators.append(simulator1)
    
    let simulator2 = MoaSimulator(urlPart: "image1.jpg")
    MoaSimulator.simulators.append(simulator2)
    
    let simulator3 = MoaSimulator(urlPart: "moa.jpg")
    MoaSimulator.simulators.append(simulator3)
    
    let result = MoaSimulator.simulatorsMatchingUrl("http://moa.com")
    
    XCTAssertEqual(0, result.count)
  }
  
  func testSimulatorsMatchingUrl_noMatch_differentCase() {
    let simulator = MoaSimulator(urlPart: "Image1.jpg")
    MoaSimulator.simulators.append(simulator)
    
    let result = MoaSimulator.simulatorsMatchingUrl("http://site.com/image1.jpg")
    
    XCTAssertEqual(0, result.count)
  }

  // MARK: - Create image downloader
  
  func testCreateImageDownloader() {
    let simulator = MoaSimulator(urlPart: "image1.jpg")
    MoaSimulator.simulators.append(simulator)
    
    let downloader =  MoaSimulator.createDownloader("http://site.com/image1.jpg")
    
    XCTAssertEqual(1, simulator.downloaders.count)
    XCTAssert(simulator.downloaders[0] === downloader)
  }
  
  func testDoNotRegisterImageDownlaoder() {
    let simulator = MoaSimulator(urlPart: "image1.jpg")
    MoaSimulator.simulators.append(simulator)
    
    let downloader = MoaSimulatedImageDownloader(url: "http://site.com/different.jpg")
    
    XCTAssertEqual(0, simulator.downloaders.count)
  }
  
  // MARK: - Stop
  
  func testStopSimulation() {
    let simulator = MoaSimulator(urlPart: "image1.jpg")
    MoaSimulator.simulators.append(simulator)
    
    MoaSimulator.clear()
    
    XCTAssert(MoaSimulator.simulators.isEmpty)
  }
  
  // MARK: - Stop
  
//  func testDownload() {
//    let simulator = MoaSimulator.simulate("image1.jpg")
//
//    let moa = Moa()
//    moa.url = "http://site.com/image1.jpg"
//    moa.url = "http://site.com/image2.jpg"
//    
//    XCTAssertEqual(1, simulator.downloaders.count)
//    XCTAssertEqual("http://site.com/image1.jpg", simulator.downloaders[0].url)
//  }
//  
//  func testDownload_respondWithImage() {
//    let downloader = MoaSimulator.simulate("image1.jpg")
//    
//    let moa = Moa()
//    moa.url = "http://site.com/image1.jpg"
//    moa.url = "http://site.com/image2.jpg"
//    
//    XCTAssertEqual(1, MoaSimulator.downloaders.count)
//    XCTAssertEqual("http://site.com/image1.jpg", MoaSimulator.downloaders[0].url)
//    
//    let image = TestBundle.image("96px.png")
//    downloader.respond(image)
//  }
}