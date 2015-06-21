/**

Used for simulation of image download. It can be useful in unit tests if you want to check which images where requested. One can supply UIImage objects for specific request URLs.

*/
public struct MoaSimulator {  
  static var simulatedUrlParts = [String]()
  
  public static func simulate(urlPart: String) {
    simulatedUrlParts.append(urlPart)
  }
  
  static func isSimulated(url: String) -> Bool {
    return contains(simulatedUrlParts) { urlPart in 
      MoaString.contains(url, substring: urlPart)
    }
  }
  
  static func stop() {
    simulatedUrlParts = []
  }
}