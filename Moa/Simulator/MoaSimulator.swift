import UIKit

/**

Simulates image download in unit tests instead of sending real network requests.

Example

    override func tearDown() {
      super.tearDown()

      MoaSimulator.clear()
    }

    func testDownload() {
      MoaSimulator.simulate("image.jpg")

      imageView.moa.url = "http://site.com/image.jpg"

     
    }

*/
public final class MoaSimulator {

  /// Array of currently registered simulators.
  static var simulators = [MoaSimulator]()
  
  
  /**
  
  Returns a simulator that will be used to catch image requests that have matching URLs. This method is usually called at the beginning of the unit test.
  
  :param: urlPart: Image download request that include the supplied urlPart will be simulated. All other requests will continue to real network.
  
  :returns: Simulator object. It is usually used in unit test to verify which request have been sent and simulating server response by calling its respondWithImage and respondWithError methods.
  
  */
  public static func simulate(urlPart: String) -> MoaSimulator {
    let simulator = MoaSimulator(urlPart: urlPart)
    simulators.append(simulator)
    return simulator
  }
  
  static func simulatorsMatchingUrl(url: String) -> [MoaSimulator] {
    return simulators.filter { simulator in
      MoaString.contains(url, substring: simulator.urlPart)
    }
  }
  
  static func createDownloader(url: String) -> MoaSimulatedImageDownloader? {
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
  
  /// Remove simulators and use real network instead.
  public static func clear() {
    simulators = []
  }
  
  // MARK: - Instance
  
  var urlPart: String
  
  /// The image that will be used to respond to all future download requests
  var autorespondWithImage: UIImage?
  
  var autorespondWithError: (error: NSError?, response: NSHTTPURLResponse?)?
  
  /// Array of registered image downloaders.
  public var downloaders = [MoaSimulatedImageDownloader]()
  
  init(urlPart: String) {
    self.urlPart = urlPart
  }
  
  /**
  
  Respond to all future download requests that have matching URLs. Call `clear` method to stop auto responding.
  
  :param: urlPart: Image download request that include the supplied urlPart will automatically and immediately succeed with the supplied image. All other requests will continue to real network.
  
  :param: image: Image that is be passed to success handler of future requests.
  
  */
  public static func autorespondWithImage(urlPart: String, image: UIImage) {
    let simulator = simulate(urlPart)
    simulator.autorespondWithImage = image
  }
  
  
  /**
  
  Fail all future download requests that have matching URLs. Call `clear` method to stop auto responding.
  
  :param: urlPart: Image download request that include the supplied urlPart will automatically and immediately fail. All other requests will continue to real network.
  
  :param: error: Optional error that is passed to the error handler of failed requests.
  
  :param: response: Optional response that is passed to the error handler of failed requests.
  
  */
  public static func autorespondWithError(urlPart: String, error: NSError? = nil,
    response: NSHTTPURLResponse? = nil) {
      
    let simulator = simulate(urlPart)
    simulator.autorespondWithError = (error, response)
  }
  
  /**
  
  Simulate a successful server response with the supplied image.
  
  :param: image: Image that is be passed to success handler of all ongoing requests.
  
  */
  public func respondWithImage(image: UIImage) {
    for downloader in downloaders {
      downloader.respondWithImage(image)
    }
  }
  
  /**
  
  Simulate an error response from server.
  
  :param: error: Optional error that is passed to the error handler of all ongoing requests.
  
  :param: response: Optional response that is passed to the error handler of all ongoing requests.
  
  */
  public func respondWithError(error: NSError? = nil, response: NSHTTPURLResponse? = nil) {
    for downloader in downloaders {
      downloader.respondWithError(error: error, response: response)
    }
  }
}