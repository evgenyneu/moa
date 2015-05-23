//
// UIImageView extension for downloading image.
//
// Example
// -------
//
//   let imageView = UIImageView()
//   imageView.moa.url = "http://site.com/moa.jpg"
//

import UIKit

private var xoAssociationKey: UInt8 = 0

public extension UIImageView {
  public var moa: Moa {
    get {
      if let value = objc_getAssociatedObject(self, &xoAssociationKey) as? Moa {
        return value
      } else {
        let moa = Moa(imageView: self)
        objc_setAssociatedObject(self, &xoAssociationKey, moa, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        return moa
      }
    }
    
    set {
      objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
    }
  }
}