
import UIKit

public final class Moa {
  private var imageDownloader: MoaImageDownloader?
  var image: UIImage?
  weak var imageView: UIImageView?

  public init() { }
  
  public var url: String? {
    didSet {
      cancel()
      
      if let url = url {
        startDownload(url)
      }
    }
  }
  
  public func cancel() {
    imageDownloader?.cancel()
    imageDownloader = nil
  }
  
  private func startDownload(url: String) {
    cancel()
    imageDownloader = MoaImageDownloader()
    
    imageDownloader?.startDownload(url,
      onSuccess: { [weak self] image in
        self?.onHandleSuccess(image)
      },
      onError: { error, response in }
    )
  }
  
  private func onHandleSuccess(image: UIImage) {
    self.image = image
    
    if let imageView = imageView {
      dispatch_async(dispatch_get_main_queue()) {
        imageView.image = image
      }
    }
  }
}