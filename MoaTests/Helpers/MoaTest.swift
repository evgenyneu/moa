import Foundation

class MoaTest {
  static func nsDataFromFile(name: String) -> NSData {
    let url = NSBundle(forClass: self).URLForResource(name, withExtension: nil)!
    return NSData(contentsOfURL: url)!
  }
}