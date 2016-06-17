import Foundation

private var xoAssociationKey: UInt8 = 0

/**

Image view extension for downloading images.

    let imageView = UIImageView()
    imageView.moa.url = "http://site.com/image.jpg"

*/
public extension MoaImageView {
  /**
  
  Image download extension.
  Assign its `url` property to download and show the image in the image view.
  
      // iOS
      let imageView = UIImageView()
      imageView.moa.url = "http://site.com/image.jpg"
  
      // OS X
      let imageView = NSImageView()
      imageView.moa.url = "http://site.com/image.jpg"
  
  */
  public var moa: Moa {
    get {
      if let value = objc_getAssociatedObject(self, &xoAssociationKey) as? Moa {
        return value
      } else {
        let moa = Moa(imageView: self)
        objc_setAssociatedObject(self, &xoAssociationKey, moa, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        return moa
      }
    }
    
    set {
      objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
  }
}
