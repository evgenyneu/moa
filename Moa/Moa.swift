
import UIKit

public final class Moa {
  private var imageDownloader: MoaImageDownloader?
  public var image: UIImage?
  public weak var imageView: UIImageView?

  public init() { }
  
  public var url: String? {
    didSet {
      if let url = url {
        startDownload(url)
      } else {
        cancel()
      }
    }
  }
  
  public func cancel() {
    imageDownloader = nil // Download is cancelled on deinit
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