import UIKit
import moa

class CollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func prepareForDisplay() {
    backgroundColor = MoaColor.random
    
    if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
      let url = appDelegate.randomImageUrl.url
//      println("Downloading: \(url)")
      imageView.moa.url = url
    }
  }
}