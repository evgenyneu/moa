import Foundation

/**

Simulates image download in unit tests instead of sending real network requests.

Example:

    override func tearDown() {
      super.tearDown()

      MoaSimulator.clear()
    }

    func testDownload() {
      // Create simulator to catch downloads of the given image
      let simulator = MoaSimulator.simulate("35px.jpg")

      // Download the image
      let imageView = UIImageView()
      imageView.moa.url = "http://site.com/35px.jpg"

      // Check the image download has been requested
      XCTAssertEqual(1, simulator.downloaders.count)
      XCTAssertEqual("http://site.com/35px.jpg", simulator.downloaders[0].url)

      // Simulate server response with the given image
      let bundle = NSBundle(forClass: self.dynamicType)
      let image =  UIImage(named: "35px.jpg", inBundle: bundle, compatibleWithTraitCollection: nil)!
      simulator.respondWithImage(image)

      // Check the image has arrived
      XCTAssertEqual(35, imageView.image!.size.width)
    }

*/
public final class MoaSimulator {

  /// Array of currently registered simulators.
  static var simulators = [MoaSimulator]()
  
  /**
  
  Returns a simulator that will be used to catch image requests that have matching URLs. This method is usually called at the beginning of the unit test.
  
  - parameter urlPart: Image download request that include the supplied urlPart will be simulated. All other requests will continue to real network.
  
  - returns: Simulator object. It is usually used in unit test to verify which request have been sent and simulating server response by calling its respondWithImage and respondWithError methods.
  
  */
  @discardableResult
  public static func simulate(_ urlPart: String) -> MoaSimulator {
    let simulator = MoaSimulator(urlPart: urlPart)
    simulators.append(simulator)
    return simulator
  }
  
  /**
  
  Respond to all future download requests that have matching URLs. Call `clear` method to stop auto responding.
  
  - parameter urlPart: Image download request that include the supplied urlPart will automatically and immediately succeed with the supplied image. All other requests will continue to real network.
  
  - parameter image: Image that is be passed to success handler of future requests.
  
  - returns: Simulator object. It is usually used in unit test to verify which request have been sent.  One does not need to call its `respondWithImage` method because it will be called automatically for all matching requests.
  
  */
  @discardableResult
  public static func autorespondWithImage(_ urlPart: String, image: MoaImage) -> MoaSimulator {
    let simulator = simulate(urlPart)
    simulator.autorespondWithImage = image
    return simulator
  }
  
  /**
  
  Fail all future download requests that have matching URLs. Call `clear` method to stop auto responding.
  
  - parameter urlPart: Image download request that include the supplied urlPart will automatically and immediately fail. All other requests will continue to real network.
  
  - parameter error: Optional error that is passed to the error handler of failed requests.
  
  - parameter response: Optional response that is passed to the error handler of failed requests.
  
  - returns: Simulator object. It is usually used in unit test to verify which request have been sent.  One does not need to call its `respondWithError` method because it will be called automatically for all matching requests.
  
  */
  @discardableResult
  public static func autorespondWithError(_ urlPart: String, error: Error? = nil,
    response: HTTPURLResponse? = nil) -> MoaSimulator {
      
    let simulator = simulate(urlPart)
    simulator.autorespondWithError = (error, response)
    return simulator
  }
  
  /// Stop using simulators and use real network instead.
  public static func clear() {
    simulators = []
  }
  
  static func simulatorsMatchingUrl(_ url: String) -> [MoaSimulator] {
    return simulators.filter { simulator in
      MoaString.contains(url, substring: simulator.urlPart)
    }
  }
  
  static func createDownloader(_ url: String) -> MoaSimulatedImageDownloader? {
    let matchingSimulators = simulatorsMatchingUrl(url)
    
    if !matchingSimulators.isEmpty {
      let downloader = MoaSimulatedImageDownloader(url: url)

      for simulator in matchingSimulators {
        simulator.downloaders.append(downloader)
        
        if let autorespondWithImage = simulator.autorespondWithImage {
          downloader.autorespondWithImage = autorespondWithImage
        }
        
        if let autorespondWithError = simulator.autorespondWithError {
          downloader.autorespondWithError = autorespondWithError
        }
      }
      
      return downloader
    }
    
    return nil
  }
  
  // MARK: - Instance
  
  var urlPart: String
  
  /// The image that will be used to respond to all future download requests
  var autorespondWithImage: MoaImage?
  
  var autorespondWithError: (error: Error?, response: HTTPURLResponse?)?
  
  /// Array of registered image downloaders.
  public var downloaders = [MoaSimulatedImageDownloader]()
  
  init(urlPart: String) {
    self.urlPart = urlPart
  }
  
  /**
  
  Simulate a successful server response with the supplied image.
  
  - parameter image: Image that is be passed to success handler of all ongoing requests.
  
  */
  public func respondWithImage(_ image: MoaImage) {
    for downloader in downloaders {
      downloader.respondWithImage(image)
    }
  }
  
  /**
  
  Simulate an error response from server.
  
  - parameter error: Optional error that is passed to the error handler of all ongoing requests.
  
  - parameter response: Optional response that is passed to the error handler of all ongoing requests.
  
  */
  public func respondWithError(_ error: Error? = nil, response: HTTPURLResponse? = nil) {
    for downloader in downloaders {
      downloader.respondWithError(error, response: response)
    }
  }
}
