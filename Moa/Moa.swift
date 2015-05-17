
import UIKit

public final class Moa {
  private var imageDownloader: MoaImageDownloader?
  private var _url: String?
  
  public init() { }
  
  public var url: String? {
    get {
      return _url
    }
    
    set {
      if let newValue = newValue {
        _url = newValue
        startDownload(newValue)
      }
    }
  }
  
  public var image: UIImage?
  
  public func cancel() {
    imageDownloader?.cancel()
  }
  
  private func startDownload(url: String) {
    imageDownloader?.cancel() // cancel previous download
    
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
  }
}