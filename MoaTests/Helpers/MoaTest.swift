import UIKit

class MoaTest {
  static func nsDataFromFile(name: String) -> NSData {
    let url = Bundle(forClass: self).urlForResource(name, withExtension: nil)!
    return NSData(contentsOfURL: url)!
  }
  
  static func uiImageFromFile(name: String) -> UIImage {
    return UIImage(data: nsDataFromFile(name))!
  }
}
