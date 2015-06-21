/**

Used for simulation of image download in unit tests.

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
  
  /// Remove download simulators and use network.
  public static func clear() {
    simulators = []
  }
  
  // MARK: - Instance
  
  var urlPart: String
  var downloaders = [MoaSimulatedImageDownloader]()
  
  init(urlPart: String) {
    self.urlPart = urlPart
  }

}