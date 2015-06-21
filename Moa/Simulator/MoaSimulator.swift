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
public struct MoaSimulator {  
  static var simulatedUrlParts = [String]()
  static var downloaders = [MoaSimulatedImageDownloader]()
  
  public static func simulate(urlPart: String) {
    simulatedUrlParts.append(urlPart)
  }
  
  static func isSimulated(url: String) -> Bool {
    return contains(simulatedUrlParts) { urlPart in 
      MoaString.contains(url, substring: urlPart)
    }
  }
  
  /**
  */
  public static func clear() {
    simulatedUrlParts = []
  }
}