
import UIKit
import XCTest

class MoaSimulatorTests: XCTestCase {
  
  override func tearDown() {
    super.tearDown()
    
    MoaSimulator.clear()
    Moa.errorImage = nil
  }
  
  func testSimulate() {
    let result = MoaSimulator.simulate("image1.jpg")
    
    XCTAssertEqual("image1.jpg", result.urlPart)
    
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
  
  func testDoNotRegisterImageDownloader() {
    let simulator = MoaSimulator(urlPart: "image1.jpg")
    MoaSimulator.simulators.append(simulator)
    
    XCTAssertEqual(0, simulator.downloaders.count)
  }
  
  // MARK: - Stop
  
  func testStopSimulation() {
    let simulator = MoaSimulator(urlPart: "image1.jpg")
    MoaSimulator.simulators.append(simulator)
    
    MoaSimulator.clear()
    
    XCTAssert(MoaSimulator.simulators.isEmpty)
  }
  
  // MARK: - Register downloaders
  
  func testRegisterSimulators() {
    let simulator = MoaSimulator.simulate("site.com")

    let moa = Moa()
    moa.url = "http://site.com/image1.jpg"
    moa.url = "http://site.com/image2.jpg"
    moa.url = "http://different.com/image3.jpg"
    
    XCTAssertEqual(2, simulator.downloaders.count)
    XCTAssertEqual("http://site.com/image1.jpg", simulator.downloaders[0].url)
    XCTAssertEqual("http://site.com/image2.jpg", simulator.downloaders[1].url)
  }
  
  // MARK: - Simulate successful response

  func testDownload_simulateSuccess() {
    let simulator = MoaSimulator.simulate("image1.jpg")
    let downloader = MoaSimulatedImageDownloader(url: "http://site.com/image1.jpg")
    simulator.downloaders.append(downloader)
    
    var imageResponse: UIImage?
    var errorResponse: Error?
    var httpUrlResponse: HTTPURLResponse?
    
    downloader.startDownload("http://site.com/image1.jpg",
      onSuccess: { image in
        imageResponse = image
      },
      onError: { error, response in
        errorResponse = error
        httpUrlResponse = response
      })
    

    let image = TestBundle.image("35px.jpg")!
    simulator.respondWithImage(image)
    
    XCTAssertEqual(35, imageResponse!.size.width)
    XCTAssert(errorResponse == nil)
    XCTAssert(httpUrlResponse == nil)
  }
  
  func testDownload_simulateError() {
    let simulator = MoaSimulator.simulate("image1.jpg")
    let downloader = MoaSimulatedImageDownloader(url: "http://site.com/image1.jpg")
    simulator.downloaders.append(downloader)
    
    var imageResponse: UIImage?
    var errorResponse: Error?
    var httpUrlResponse: HTTPURLResponse?
    
    downloader.startDownload("http://site.com/image1.jpg",
      onSuccess: { image in
        imageResponse = image
      },
      onError: { error, response in
        errorResponse = error
        httpUrlResponse = response
    })
    
    let error = NSError(domain: "test", code: 543_534, userInfo: nil)
    
    let response = HTTPURLResponse(url: NSURL(string: "http://error.com")! as URL, statusCode: 422,
      httpVersion: nil, headerFields: nil)
    
    simulator.respondWithError(error, response: response)
    
    XCTAssert(imageResponse == nil)
    XCTAssertEqual(543_534, errorResponse!._code)
    XCTAssertEqual(422, httpUrlResponse!.statusCode)
  }
  
  // MARK: - Simulate future downloads with successful response
  
  func testDownload_autorespondWithImage() {
    let image = TestBundle.image("35px.jpg")!

    MoaSimulator.autorespondWithImage("image1.jpg", image: image)
    
    let downloader = MoaSimulator.createDownloader("http://site.com/image1.jpg")!
    
    var imageResponse: UIImage?
    var errorResponse: Error?
    var httpUrlResponse: HTTPURLResponse?
    
    downloader.startDownload("http://site.com/image1.jpg",
      onSuccess: { image in
        imageResponse = image
      },
      onError: { error, response in
        errorResponse = error
        httpUrlResponse = response
    })
    
    XCTAssertEqual(35, imageResponse!.size.width)
    XCTAssert(errorResponse == nil)
    XCTAssert(httpUrlResponse == nil)
  }
  
  // MARK: - Autorespond with error
  
  func testDownload_autorespondWithError() {    
    let error = NSError(domain: "test", code: 543_534, userInfo: nil)
    
    let response = HTTPURLResponse(url: NSURL(string: "http://error.com")! as URL, statusCode: 422,
      httpVersion: nil, headerFields: nil)
    
    MoaSimulator.autorespondWithError("image1.jpg", error: error, response: response)
    
    let downloader = MoaSimulator.createDownloader("http://site.com/image1.jpg")!
    
    var imageResponse: UIImage?
    var errorResponse: Error?
    var httpUrlResponse: HTTPURLResponse?
    
    downloader.startDownload("http://site.com/image1.jpg",
      onSuccess: { image in
        imageResponse = image
      },
      onError: { error, response in
        errorResponse = error
        httpUrlResponse = response
    })
    
    XCTAssert(imageResponse == nil)
    XCTAssertEqual(543_534, errorResponse!._code)
    XCTAssertEqual(422, httpUrlResponse!.statusCode)
  }
}
