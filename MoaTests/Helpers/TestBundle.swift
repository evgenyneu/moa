import UIKit

class TestBundle {
  class func image(named: String) -> UIImage? {
    let bundle = Bundle(forClass: self)
    
    return UIImage(named: named,
      inBundle: bundle, compatibleWithTraitCollection: nil)
  }
}
