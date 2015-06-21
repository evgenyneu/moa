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
  
  /// Array of registered image downloaders.
  public var downloaders = [MoaSimulatedImageDownloader]()
  
  init(urlPart: String) {
    self.urlPart = urlPart
  }
  
  /**
  
  Respond to existing download requests with the supplied image.
  
  :param: image: Image that will be passed to success handler
  
  */
  public func respondWithImage(image: UIImage) {
    for downloader in downloaders {
      downloader.respondWithImage(image)
    }
  }
  
  /**
  
  Respond to existing download requests with the error.
  
  */
  public func respondWithError(error: NSError? = nil, response: NSHTTPURLResponse? = nil) {
    for downloader in downloaders {
      downloader.respondWithError(error: error, response: response)
    }
  }
}