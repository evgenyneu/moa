import WatchKit

private var xoMoaInterfaceImageAssociationKey: UInt8 = 0

/**

Interface image extension for downloading images.

let interfaceImage = WKInterfaceImage()
interfaceImage.moa.url = "http://site.com/image.jpg"

*/
public extension WKInterfaceImage {
  
  /**
  
  Image download extension.
  Assign its `url` property to download and show the image.
  
  let interfaceImage = WKInterfaceImage()
  interfaceImage.moa.url = "http://site.com/image.jpg"
  
  */
  public var moa: Moa {
    get {
      if let value = objc_getAssociatedObject(self, &xoMoaInterfaceImageAssociationKey) as? Moa {
        return value
      } else {
        let moa = Moa(wkInterfaceImage: self)
        objc_setAssociatedObject(self, &xoMoaInterfaceImageAssociationKey, moa, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        return moa
      }
    }
    
    set {
      objc_setAssociatedObject(self, &xoMoaInterfaceImageAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
    }
  }
}

