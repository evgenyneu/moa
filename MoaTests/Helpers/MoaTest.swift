import UIKit

class MoaTest {
  static func nsDataFromFile(_ name: String) -> Data {
    let url = Bundle(for: self).urlForResource(name, withExtension: nil)!
    return try! Data(contentsOf: url)
  }
  
  static func uiImageFromFile(_ name: String) -> UIImage {
    return UIImage(data: nsDataFromFile(name))!
  }
}
