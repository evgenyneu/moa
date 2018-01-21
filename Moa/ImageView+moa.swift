import Foundation

private var xoAssociationKey: UInt8 = 0
private var xo1AssociationKey: UInt8 = 1
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
  
  public var activityIndicator: UIActivityIndicatorView {
    get {
      if let value = objc_getAssociatedObject(self, &xo1AssociationKey) as? UIActivityIndicatorView {
        return value
      } else {
        let activity = UIActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30));
        activity.tintColor = UIColor.lightGray
        activity.center = self.center;
        objc_setAssociatedObject(self, &xo1AssociationKey, activity, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        return activity
      }
    }
    
    set {
      objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
  }
  
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
