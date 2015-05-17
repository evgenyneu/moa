
import UIKit

public final class Moa {
  private var imageDownloader: MoaImageDownloader?
  
  public init() { }
  
  public var url: String? {
    didSet {
      imageDownloader?.cancel() // cancel previous download

      if let url = url {
        startDownload(url)
      }
    }
  }
  
  public var image: UIImage?
  
  public func cancel() {
    imageDownloader?.cancel()
  }
  
  private func startDownload(url: String) {
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