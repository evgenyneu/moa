// 
// Helper classes for working with UIImage
//

import UIKit

struct MoaImage {
  static func pixelColorInImage(image: UIImage, atPoint point: CGPoint) -> UIColor {
    
    let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage))
    let data = CFDataGetBytePtr(pixelData)
    
    var pixelInfo = ((image.size.width  * point.y) + point.x ) * 4 // 4 bytes per pixel
    
    let red = data[Int(pixelInfo + 0)]
    let green = data[Int(pixelInfo + 1)]
    let blue  = data[Int(pixelInfo + 2)]
    let alpha = data[Int(pixelInfo + 3)]
  
    return UIColor(
      red: CGFloat(Double(red) / 255.0),
      green: CGFloat(Double(green) / 255.0),
      blue: CGFloat(Double(blue) / 255.0),
      alpha: CGFloat(Double(alpha) / 255.0))
  }
  
  static func pixelColorAtImageCenter(image: UIImage) -> UIColor {
    let centerPoint = CGPoint(
      x: image.size.width / 2,
      y: image.size.height / 2
    )
    
    return pixelColorInImage(image, atPoint: centerPoint)
  }
}