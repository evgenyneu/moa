
//
// UIImageView moa extension.
//

import UIKit

private var xoAssociationKey: UInt8 = 0

public extension UIImageView {
  public var moa: Moa {
    get {
      if let value = objc_getAssociatedObject(self, &xoAssociationKey) as? Moa {
        return value
      } else {
        let newValue = Moa()
        objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        return newValue
      }
    }
    
    set {
      objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
    }
  }
}