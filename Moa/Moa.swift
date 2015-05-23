//
// Downloads an image by url.
//
// Example
// -------
//
//   let moa = Moa()
//   moa.onSuccessAsync = { image in
//     return image
//   }
//   moa.url = "http://site.com/moa.jpg"
//

import UIKit

public final class Moa {
  private var imageDownloader: MoaImageDownloader?
  private weak var imageView: UIImageView?

  public init() { }
  
  init(imageView: UIImageView) {
    self.imageView = imageView
  }
  
  public var url: String? {
    didSet {
      cancel()
      
      if let url = url {
        startDownload(url)
      }
    }
  }
  
  public var onSuccessAsync: ((UIImage)->(UIImage?))?
  public var onErrorAsync: ((NSError, NSHTTPURLResponse?)->())?
  
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
      onError: { [weak self] error, response in
        self?.onErrorAsync?(error, response)
      }
    )
  }
  
  private func onHandleSuccess(image: UIImage) {
    var imageForView: UIImage? = image
    
    if let onSuccessAsync = onSuccessAsync {
      imageForView = onSuccessAsync(image)
    }
    
    if let imageView = imageView {
      dispatch_async(dispatch_get_main_queue()) {
        imageView.image = imageForView
      }
    }
  }
}